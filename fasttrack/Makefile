CXX         := clang++
OPT         := opt
LLVM_CONFIG := llvm-config

CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags)
TSAN_FLAGS = -fsanitize=thread -g -O1

# ──────────────────────────────────────────────────────────────────
# SOURCE FILES
# ──────────────────────────────────────────────────────────────────
PASS_SRC       := fasttrack_instrumentation.cpp
PASS_NAME      := fasttrack-pass

ESCAPE_PASS_SRC := escape_instrumentation.cpp

# ESCAPE_PASS_SRC := testing_temp_dir/escape_pass_ver2.cpp 
# TARGET_DIR     := targets/old_targets_dhruv
TARGET_DIR     := targets/old_targets_dhruv

RUNTIME_FT     := fasttrack_runtime.cpp
RUNTIME_SA     := fasttrack_runtime_with_sa_ver4.cpp
TARGET_SRC     := $(TARGET_DIR)/test_efficiency.cpp

# ──────────────────────────────────────────────────────────────────
# BUILD DIRECTORY — all generated files live here
# ──────────────────────────────────────────────────────────────────
BUILD_DIR := build

# ──────────────────────────────────────────────────────────────────
# DERIVED PATHS  (all inside BUILD_DIR)
# ──────────────────────────────────────────────────────────────────
PLUGIN         := $(BUILD_DIR)/llvmpass.so
ESCAPE_PASS_OBJ := $(BUILD_DIR)/escape_instpass.so

TARGET_BC      := $(BUILD_DIR)/efficiency.bc
TARGET_INST_BC := $(BUILD_DIR)/efficiency_inst.bc
TARGET_LL      := $(BUILD_DIR)/$(basename $(TARGET_SRC)).ll

RUNTIME_FT_OBJ    := $(BUILD_DIR)/runtime_ft.o
RUNTIME_SA_OBJ    := $(BUILD_DIR)/runtime_sa.o
RUNTIME_FT_RR_OBJ := $(BUILD_DIR)/runtime_ft_rr.o
RUNTIME_SA_RR_OBJ := $(BUILD_DIR)/runtime_sa_rr.o

BENCH_TSAN    := $(BUILD_DIR)/bench_tsan
BENCH_FT      := $(BUILD_DIR)/bench_ft
BENCH_SA      := $(BUILD_DIR)/bench_sa
BENCH_FT_RR   := $(BUILD_DIR)/bench_ft_rr
BENCH_SA_RR   := $(BUILD_DIR)/bench_sa_rr

ESCAPE_IR      := $(BUILD_DIR)/instrumented_escape.ll
ESCAPE_EXEC    := $(BUILD_DIR)/instrumented_escape
ESCAPE_EXEC_SA := $(BUILD_DIR)/instrumented_escape_sa


# Output logs also inside build/
OUT_FT         := $(BUILD_DIR)/out_ft.txt
OUT_SA         := $(BUILD_DIR)/out_sa.txt
OUT_TSAN       := $(BUILD_DIR)/out_tsan.txt
OUT_ESCAPE     := $(BUILD_DIR)/out_escape.txt
OUT_ESCAPE_SA  := $(BUILD_DIR)/out_escape_sa.txt

# ──────────────────────────────────────────────────────────────────
# DEFAULT TARGET
# ──────────────────────────────────────────────────────────────────
all: $(BENCH_FT) $(BENCH_SA)

# ──────────────────────────────────────────────────────────────────
# DIRECTORY GUARD — every rule that writes into build/ depends on this
# ──────────────────────────────────────────────────────────────────
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ──────────────────────────────────────────────────────────────────
# [0] TSAN BASELINE
# ──────────────────────────────────────────────────────────────────
$(BENCH_TSAN): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[0] Compiling TSAN baseline..."
	$(CXX) $(TSAN_FLAGS) $(TARGET_SRC) -o $@ -lpthread

bench_tsan: $(BENCH_TSAN)

# ──────────────────────────────────────────────────────────────────
# [1] LLVM PASS PLUGIN
# ──────────────────────────────────────────────────────────────────
$(PLUGIN): $(PASS_SRC) | $(BUILD_DIR)
	@echo "[1] Building FastTrack LLVM pass..."
	$(CXX) -fPIC -shared $(PASS_SRC) -o $@ $(CXXFLAGS) $(LDFLAGS)

# ──────────────────────────────────────────────────────────────────
# [2] COMPILE TARGET TO BITCODE
# ──────────────────────────────────────────────────────────────────
$(TARGET_BC): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[2] Compiling target to bitcode..."
	$(CXX) -emit-llvm -O0 -fno-inline -fno-builtin \
	       -fno-omit-frame-pointer -g \
	       -c $(TARGET_SRC) -o $@

# ──────────────────────────────────────────────────────────────────
# [2b] HUMAN-READABLE IR (for Python race mapper)
# ──────────────────────────────────────────────────────────────────
$(TARGET_LL): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[2b] Generating human-readable LLVM IR..."
	$(CXX) -S -emit-llvm -g $(TARGET_SRC) -o $@

target_ir: $(TARGET_LL)

# ──────────────────────────────────────────────────────────────────
# [3] INSTRUMENT BITCODE (FastTrack pass)
# ──────────────────────────────────────────────────────────────────
$(TARGET_INST_BC): $(TARGET_BC) $(PLUGIN)
	@echo "[3] Instrumenting bitcode with FastTrack pass..."
	$(OPT) -load-pass-plugin=./$(PLUGIN) \
	       -passes="default<O0>,$(PASS_NAME)" \
	       $(TARGET_BC) -o $@

# ──────────────────────────────────────────────────────────────────
# [4a-d] RUNTIME OBJECTS
# ──────────────────────────────────────────────────────────────────
$(RUNTIME_FT_OBJ): $(RUNTIME_FT) | $(BUILD_DIR)
	@echo "[4a] Compiling plain FT runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_FT) -o $@

$(RUNTIME_SA_OBJ): $(RUNTIME_SA) | $(BUILD_DIR)
	@echo "[4b] Compiling SA+FT runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_SA) -o $@

$(RUNTIME_FT_RR_OBJ): $(RUNTIME_FT) | $(BUILD_DIR)
	@echo "[4c] Compiling plain FT runtime (record/replay)..."
	$(CXX) -O0 -g -DFT_RECORD_REPLAY -c $(RUNTIME_FT) -o $@

$(RUNTIME_SA_RR_OBJ): $(RUNTIME_SA) | $(BUILD_DIR)
	@echo "[4d] Compiling SA+FT runtime (record/replay)..."
	$(CXX) -O0 -g -DFT_RECORD_REPLAY -c $(RUNTIME_SA) -o $@

# ──────────────────────────────────────────────────────────────────
# [5a-d] LINK BENCHMARKS
# ──────────────────────────────────────────────────────────────────
$(BENCH_FT): $(TARGET_INST_BC) $(RUNTIME_FT_OBJ)
	@echo "[5a] Linking bench_ft..."
	$(CXX) $^ -o $@ -lpthread

$(BENCH_SA): $(TARGET_INST_BC) $(RUNTIME_SA_OBJ)
	@echo "[5b] Linking bench_sa..."
	$(CXX) $^ -o $@ -lpthread

$(BENCH_FT_RR): $(TARGET_INST_BC) $(RUNTIME_FT_RR_OBJ)
	@echo "[5c] Linking bench_ft_rr (record/replay)..."
	$(CXX) $^ -o $@ -lpthread

$(BENCH_SA_RR): $(TARGET_INST_BC) $(RUNTIME_SA_RR_OBJ)
	@echo "[5d] Linking bench_sa_rr (record/replay)..."
	$(CXX) $^ -o $@ -lpthread

# ──────────────────────────────────────────────────────────────────
# [6] ESCAPE ANALYSIS PASS + INSTRUMENTED BINARIES
# ──────────────────────────────────────────────────────────────────
$(ESCAPE_PASS_OBJ): $(ESCAPE_PASS_SRC) | $(BUILD_DIR)
	@echo "[6] Building Escape Analysis LLVM pass..."
	$(CXX) -shared -fPIC $(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) $< -o $@

$(ESCAPE_IR): $(TARGET_BC) $(ESCAPE_PASS_OBJ)
	@echo "[7] Instrumenting bitcode with Escape Analysis pass..."
	$(OPT) -load-pass-plugin=./$(ESCAPE_PASS_OBJ) -passes="shared-ptr-analysis" $< -S -o $@

$(ESCAPE_EXEC): $(ESCAPE_IR) $(RUNTIME_FT_OBJ)
	@echo "[8a] Linking escape_ft..."
	$(CXX) $^ -o $@ -lpthread

$(ESCAPE_EXEC_SA): $(ESCAPE_IR) $(RUNTIME_SA_OBJ)
	@echo "[8b] Linking escape_sa..."
	$(CXX) $^ -o $@ -lpthread

instrument_escape: $(ESCAPE_EXEC) $(ESCAPE_EXEC_SA)

# ──────────────────────────────────────────────────────────────────
# RUN — execute all four variants and compare
# ──────────────────────────────────────────────────────────────────
run: $(BENCH_FT) $(BENCH_SA) $(ESCAPE_EXEC) $(ESCAPE_EXEC_SA)
	@echo ""
	@echo "====== Plain FastTrack ======"
	./$(BENCH_FT) 2>&1 | tee $(OUT_FT)

	@echo ""
	@echo "====== FastTrack + Sharing Analysis ======"
	./$(BENCH_SA) 2>&1 | tee $(OUT_SA)

	@echo ""
	@echo "====== Escape Analysis + FastTrack ======"
	./$(ESCAPE_EXEC) 2>&1 | tee $(OUT_ESCAPE)

	@echo ""
	@echo "====== Escape Analysis + SA + FastTrack ======"
	./$(ESCAPE_EXEC_SA) 2>&1 | tee $(OUT_ESCAPE_SA)

	@echo ""
	@echo "====== Race Report Counts ======"
	@FT=$$(grep -c 'FASTTRACK LOG' $(OUT_FT) 2>/dev/null || echo 0); \
	 SA=$$(grep -c 'FASTTRACK LOG' $(OUT_SA) 2>/dev/null || echo 0); \
	 EA=$$(grep -c 'FASTTRACK LOG' $(OUT_ESCAPE) 2>/dev/null || echo 0); \
	 ESA=$$(grep -c 'FASTTRACK LOG' $(OUT_ESCAPE_SA) 2>/dev/null || echo 0); \
	 echo "  plain FT       : $${FT}"; \
	 echo "  SA + FT        : $${SA}"; \
	 echo "  escape FT      : $${EA}"; \
	 echo "  escape + SA FT : $${ESA}"

	@echo ""
	@echo "====== Wall Time ======"
	@grep "Launch to finish" $(OUT_FT)        | sed 's/^/  plain FT       : /'
	@grep "Launch to finish" $(OUT_SA)        | sed 's/^/  SA + FT        : /'
	@grep "Launch to finish" $(OUT_ESCAPE)    | sed 's/^/  escape FT      : /'
	@grep "Launch to finish" $(OUT_ESCAPE_SA) | sed 's/^/  escape + SA FT : /'

	@echo ""
	@echo "====== First Race Report ======"
	@grep 'FASTTRACK LOG' $(OUT_FT)        | head -1 | sed 's/^/  plain FT       : /'
	@grep 'FASTTRACK LOG' $(OUT_SA)        | head -1 | sed 's/^/  SA + FT        : /'
	@grep 'FASTTRACK LOG' $(OUT_ESCAPE)    | head -1 | sed 's/^/  escape FT      : /'
	@grep 'FASTTRACK LOG' $(OUT_ESCAPE_SA) | head -1 | sed 's/^/  escape + SA FT : /'

# ──────────────────────────────────────────────────────────────────
# COMPARE — TSAN-based automated Python validation
# ──────────────────────────────────────────────────────────────────
compare: $(BENCH_TSAN) $(TARGET_LL) $(BENCH_FT) $(BENCH_SA)
	@echo "========================================"
	@echo " Running Executions..."
	@echo "========================================"
	-./$(BENCH_TSAN) 2>&1 | tee $(OUT_TSAN) > /dev/null
	-./$(BENCH_FT)   2>&1 | tee $(OUT_FT)   > /dev/null
	-./$(BENCH_SA)   2>&1 | tee $(OUT_SA)   > /dev/null
	@echo "[Done] Logs saved to $(BUILD_DIR)/"
	@echo ""
	@echo "========================================"
	@echo " Running Automated Python Analysis..."
	@echo "========================================"
	@python3 compare_races.py $(TARGET_SRC)


# ──────────────────────────────────────────────────────────────────
# DEBUG — show instrumentation call counts in the instrumented IR
# ──────────────────────────────────────────────────────────────────
debug: $(TARGET_INST_BC)
	@echo "Disassembling instrumented bitcode..."
	llvm-dis $(TARGET_INST_BC) -o $(BUILD_DIR)/inst.ll
	@echo "Instrumentation call counts:"
	@printf "  __ft_read   : "; grep -c "call.*__ft_read"   $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_write  : "; grep -c "call.*__ft_write"  $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_lock   : "; grep -c "call.*__ft_lock"   $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_unlock : "; grep -c "call.*__ft_unlock" $(BUILD_DIR)/inst.ll || echo 0

# ──────────────────────────────────────────────────────────────────
# HELP
# ──────────────────────────────────────────────────────────────────
help:
	@echo "================================================================"
	@echo "            FastTrack LLVM Build System"
	@echo "================================================================"
	@echo "All build artifacts are written to: ./$(BUILD_DIR)/"
	@echo ""
	@echo "Core targets:"
	@echo "  make all              Build bench_ft and bench_sa (default)"
	@echo "  make run              Run all 4 variants and compare races + timing"
	@echo "  make debug            Show __ft_* call counts in instrumented IR"
	@echo "  make clean            Remove entire build/ directory and all logs"
	@echo ""
	@echo "TSAN validation:"
	@echo "  make bench_tsan       Build TSAN-instrumented binary"
	@echo "  make compare          Run TSAN + FT + SA and analyse with Python"
	@echo "  make target_ir        Emit human-readable IR for Python race mapper"
	@echo ""
	@echo "Escape analysis:"
	@echo "  make instrument_escape   Build escape-instrumented binaries (FT and SA)"
	@echo "  build/instrumented_escape    Escape + plain FT binary"
	@echo "  build/instrumented_escape_sa Escape + SA+FT binary"
	@echo ""
	@echo "Output logs (all in build/):"
	@echo "  out_ft.txt            Plain FT run log"
	@echo "  out_sa.txt            SA+FT run log"
	@echo "  out_tsan.txt          TSAN run log"
	@echo "  out_escape.txt        Escape+FT run log"
	@echo "  out_escape_sa.txt     Escape+SA+FT run log"
	@echo "================================================================"

# ──────────────────────────────────────────────────────────────────
# CLEAN
# ──────────────────────────────────────────────────────────────────
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run debug clean help \
        bench_tsan target_ir compare \
        instrument_escape
