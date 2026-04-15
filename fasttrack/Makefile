CXX         := clang++
OPT         := opt
LLVM_CONFIG := llvm-config

CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags)
TSAN_FLAGS = -fsanitize=thread -g -O1

PASS_SRC   := fasttrack_instrumentation.cpp
PLUGIN     := llvmpass.so
PASS_NAME  := fasttrack-pass

RUNTIME_FT := fasttrack_runtime.cpp
RUNTIME_SA := fasttrack_runtime_with_sa_ver4.cpp
TARGET_SRC := test_efficiency_no_race.cpp

TARGET_BC      := efficiency.bc
TARGET_INST_BC := efficiency_inst.bc

RUNTIME_FT_OBJ := runtime_ft.o
RUNTIME_SA_OBJ := runtime_sa.o

BENCH_FT := bench_ft
BENCH_SA := bench_sa

all: $(BENCH_FT) $(BENCH_SA)

# --- TSAN Build ---
bench_tsan: $(TARGET_SRC)
	@echo "[Build] Compiling TSAN Baseline..."
	$(CXX) $(TSAN_FLAGS) $(TARGET_SRC) -o bench_tsan -lpthread

# --- LLVM IR Generation ---
# Generates human-readable LLVM IR (.ll) so Python can map !dbg tags to lines
target_ir: $(TARGET_SRC)
	@echo "[Build] Generating LLVM IR for Debug Mapping..."
	$(CXX) -S -emit-llvm -g $(TARGET_SRC) -o $(basename $(TARGET_SRC)).ll

# --- Automated Comparison Pipeline ---
compare: bench_tsan target_ir bench_ft bench_sa
	@echo "========================================"
	@echo " Running Executions..."
	@echo "========================================"
	-./bench_tsan 2>&1 | tee out_tsan.txt > /dev/null
	-./bench_ft 2>&1 | tee out_ft.txt > /dev/null
	-./bench_sa 2>&1 | tee out_sa.txt > /dev/null
	@echo "[Done] Logs saved."
	@echo "\n========================================"
	@echo " Running Automated Python Analysis..."
	@echo "========================================"
	@python3 compare_races.py $(TARGET_SRC)

# Clean up generated baseline files
clean_compare:
	rm -f bench_tsan out_tsan.txt out_ft.txt out_sa.txt *.ll

$(PLUGIN): $(PASS_SRC)
	@echo "[1] Building LLVM pass..."
	$(CXX) -fPIC -shared $(PASS_SRC) -o $(PLUGIN) $(CXXFLAGS) $(LDFLAGS)

$(TARGET_BC): $(TARGET_SRC)
	@echo "[2] Compiling target to bitcode..."
	$(CXX) -emit-llvm -O0 -fno-inline -fno-builtin \
	       -fno-omit-frame-pointer -g \
	       -c $(TARGET_SRC) -o $(TARGET_BC)

$(TARGET_INST_BC): $(TARGET_BC) $(PLUGIN)
	@echo "[3] Instrumenting bitcode..."
	$(OPT) -load-pass-plugin=./$(PLUGIN) \
	       -passes="default<O0>,$(PASS_NAME)" \
	       $(TARGET_BC) -o $(TARGET_INST_BC)

$(RUNTIME_FT_OBJ): $(RUNTIME_FT)
	@echo "[4a] Compiling plain FT runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_FT) -o $(RUNTIME_FT_OBJ)

$(RUNTIME_SA_OBJ): $(RUNTIME_SA)
	@echo "[4b] Compiling SA+FT runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_SA) -o $(RUNTIME_SA_OBJ)

$(BENCH_FT): $(TARGET_INST_BC) $(RUNTIME_FT_OBJ)
	@echo "[5a] Linking bench_ft..."
	$(CXX) $(TARGET_INST_BC) $(RUNTIME_FT_OBJ) -o $(BENCH_FT) -lpthread

$(BENCH_SA): $(TARGET_INST_BC) $(RUNTIME_SA_OBJ)
	@echo "[5b] Linking bench_sa..."
	$(CXX) $(TARGET_INST_BC) $(RUNTIME_SA_OBJ) -o $(BENCH_SA) -lpthread

help:
	@echo "================================================================"
	@echo "                FastTrack LLVM Build System"
	@echo "================================================================"
	@echo "Available commands:"
	@echo "  make all     - Build both bench_ft and bench_sa executables (Default)"
	@echo "  make compare - Run automated TSAN validation using Python"
	@echo "  make run     - Execute both benchmarks and compare race reports & time"
	@echo "  make debug   - Disassemble instrumented bitcode and show call counts"
	@echo "  make clean   - Remove all build artifacts, object files, and logs"
	@echo "================================================================"

run: $(BENCH_FT) $(BENCH_SA)
	@echo ""
	@echo "====== Plain FastTrack ======"
	./$(BENCH_FT) 2>&1 | tee out_ft.txt
	@echo ""
	@echo "====== FastTrack + Sharing Analysis ======"
	./$(BENCH_SA) 2>&1 | tee out_sa.txt
	@echo ""
	@echo "====== Comparison ======"
	@FT=$$(grep -c 'FASTTRACK LOG' out_ft.txt 2>/dev/null || echo 0); \
	 SA=$$(grep -c 'FASTTRACK LOG' out_sa.txt 2>/dev/null || echo 0); \
	 echo "Race reports  plain FT : $${FT}"; \
	 echo "Race reports  SA + FT  : $${SA}"
	@echo ""
	@echo "Wall time (ms):"
	@grep "Launch to finish" out_ft.txt | sed 's/^/  plain FT : /'
	@grep "Launch to finish" out_sa.txt | sed 's/^/  SA + FT  : /'
	@echo ""
	@echo "First race report:"
	@grep 'FASTTRACK LOG' out_ft.txt | head -1 | sed 's/^/  plain FT : /'
	@grep 'FASTTRACK LOG' out_sa.txt | head -1 | sed 's/^/  SA + FT  : /'

debug: $(TARGET_INST_BC)
	llvm-dis $(TARGET_INST_BC) -o /tmp/inst.ll
	@echo "Instrumentation call counts:"
	@printf "  __ft_read   : "; grep -c "call.*__ft_read"   /tmp/inst.ll || echo 0
	@printf "  __ft_write  : "; grep -c "call.*__ft_write"  /tmp/inst.ll || echo 0
	@printf "  __ft_lock   : "; grep -c "call.*__ft_lock"   /tmp/inst.ll || echo 0
	@printf "  __ft_unlock : "; grep -c "call.*__ft_unlock" /tmp/inst.ll || echo 0

clean:
	rm -f $(PLUGIN) $(TARGET_BC) $(TARGET_INST_BC) \
	      $(RUNTIME_FT_OBJ) $(RUNTIME_SA_OBJ) \
	      $(BENCH_FT) $(BENCH_SA) bench_tsan \
	      out_ft.txt out_sa.txt out_tsan.txt *.o *.so *.bc *.ll

.PHONY: all run debug clean clean_compare help target_ir compare