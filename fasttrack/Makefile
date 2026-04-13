# # Variables

# OPT := opt
# LLVM_CONFIG := llvm-config

# # Flags retrieved from llvm-config
# # Note: We filter out some flags that might conflict or be unnecessary for simple plugins
# CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
# LDFLAGS := $(shell $(LLVM_CONFIG) --ldflags)

# # Project Files
# TARGET_SRC ?= target_no_race.cpp
# PASS_SRC := fasttrack_instrumentation.cpp
# RUNTIME_SRC := fasttrack_runtime.cpp

# # Output Names
# PLUGIN := llvmpass.so
# PASS_NAME := fasttrack-pass
# EXECUTABLE := race_detector

# # Intermediate Files
# TARGET_BC := main.bc
# TARGET_INST_BC := main_inst.bc
# RUNTIME_OBJ := fasttrack.o


# # Default Target: Build everything
# all: $(EXECUTABLE)

# # 1. Compile the Runtime Library (fasttrack.cpp -> fasttrack.o)
# $(RUNTIME_OBJ): $(RUNTIME_SRC)
# 	@echo "Compiling Runtime..."
# 	$(CXX) -c $(RUNTIME_SRC) -o $(RUNTIME_OBJ)

# # 2. Build the LLVM Pass Plugin (InstrumentPass.cpp -> InstrumentPass.so)
# $(PLUGIN): $(PASS_SRC)
# 	@echo "Building LLVM Pass..."
# 	$(CXX) -fPIC -shared $(PASS_SRC) -o $(PLUGIN) $(CXXFLAGS) $(LDFLAGS)

# # 3. Emit LLVM IR for the Target (main.cpp -> main.bc)
# $(TARGET_BC): $(TARGET_SRC)
# 	@echo "Generating LLVM IR..."
# 	$(CXX) -emit-llvm -O0 -fno-inline -fno-builtin -fno-omit-frame-pointer \
# 	       -c $(TARGET_SRC) -o $(TARGET_BC) -g

# # 4. Instrument the IR using 'opt' (main.bc -> main_inst.bc)
# $(TARGET_INST_BC): $(TARGET_BC) $(PLUGIN)
# 	@echo "Running Instrumentation Pass..."
# 	$(OPT) -load-pass-plugin=./$(PLUGIN) \
# 	       -passes="default<O0>,$(PASS_NAME)" \
# 	       $(TARGET_BC) -o $(TARGET_INST_BC)

# # 5. Link everything together (main_inst.bc + fasttrack.o -> executable)
# $(EXECUTABLE): $(TARGET_INST_BC) $(RUNTIME_OBJ)
# 	@echo "Linking Final Executable..."
# 	$(CXX) $(TARGET_INST_BC) $(RUNTIME_OBJ) -o $(EXECUTABLE) -lpthread

# # Run the program
# run: $(EXECUTABLE)
# 	@echo "Running Race Detector..."
# 	./$(EXECUTABLE)

# # Clean up all generated files
# clean:
# 	@echo "Cleaning up..."
# 	rm -f $(PLUGIN) $(TARGET_BC) $(TARGET_INST_BC) $(RUNTIME_OBJ) $(EXECUTABLE) *.o *.so *.bc
CXX         := clang++
OPT         := opt
LLVM_CONFIG := llvm-config

CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags)

PASS_SRC   := fasttrack_instrumentation.cpp
PLUGIN     := llvmpass.so
PASS_NAME  := fasttrack-pass

RUNTIME_FT := fasttrack_runtime.cpp
RUNTIME_SA := fasttrack_runtime_with_sa.cpp

TARGET_SRC := test_efficiency_no_race.cpp

TARGET_BC      := efficiency.bc
TARGET_INST_BC := efficiency_inst.bc

RUNTIME_FT_OBJ := runtime_ft.o
RUNTIME_SA_OBJ := runtime_sa.o

BENCH_FT := bench_ft
BENCH_SA := bench_sa

all: $(BENCH_FT) $(BENCH_SA)

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

ESCAPE_PASS_SRC = escape_instrumentation.cpp
ESCAPE_PASS_OBJ = escape_instpass.so
BUILD_DIR = build
ESCAPE_IR = $(BUILD_DIR)/instrumented_escape.ll
ESCAPE_EXEC = $(BUILD_DIR)/instrumented_escape

ESCAPE_EXEC_SA = $(BUILD_DIR)/instrumented_escape_sa
.PHONY: all clean run instrument_escape instrumented_escape_sa
$(ESCAPE_PASS_OBJ): $(ESCAPE_PASS_SRC)
	# $(CXX) -O3 -shared -fPIC $(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) $< -o $@
	$(CXX) -shared -fPIC $(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) $< -o $@

$(ESCAPE_IR): $(TARGET_BC) $(ESCAPE_PASS_OBJ)
	mkdir -p $(BUILD_DIR)
	$(OPT) -load-pass-plugin=./$(ESCAPE_PASS_OBJ) -passes="shared-ptr-analysis" $< -S -o $@

$(ESCAPE_EXEC): $(ESCAPE_IR) $(RUNTIME_FT_OBJ)
	$(CXX) $^ -o $@
$(ESCAPE_EXEC_SA): $(ESCAPE_IR) $(RUNTIME_SA_OBJ)
	$(CXX) $^ -o $@

instrument_escape: $(ESCAPE_EXEC)
clean:
	rm -rf *.so *.o *.ll $(BUILD_DIR)

run: $(BENCH_FT) $(BENCH_SA) $(ESCAPE_EXEC) $(ESCAPE_EXEC_SA)
	@echo ""
	@echo "====== Plain FastTrack ======"
	./$(BENCH_FT) 2>&1 | tee out_ft.txt

	@echo ""
	@echo "====== FastTrack + Sharing Analysis ======"
	./$(BENCH_SA) 2>&1 | tee out_sa.txt

	@echo ""
	@echo "====== ESCAPE Instrumented FastTrack ======"
	./$(ESCAPE_EXEC) 2>&1 | tee out_escape.txt

	@echo ""
	@echo "====== ESCAPE + SA Instrumented FastTrack ======"
	./$(ESCAPE_EXEC_SA) 2>&1 | tee out_escape_sa.txt

	@echo ""
	@echo "====== Comparison ======"
	@FT=$$(grep -c 'FASTTRACK LOG' out_ft.txt 2>/dev/null || echo 0); \
	 SA=$$(grep -c 'FASTTRACK LOG' out_sa.txt 2>/dev/null || echo 0); \
	 EA=$$(grep -c 'FASTTRACK LOG' out_escape.txt 2>/dev/null || echo 0); \
	 ESA=$$(grep -c 'FASTTRACK LOG' out_escape_sa.txt 2>/dev/null || echo 0); \
	 echo "Race reports  plain FT : $${FT}"; \
	 echo "Race reports  SA + FT  : $${SA}"; \
	 echo "Race reports  EA       : $${EA}"; \
	 echo "Race reports  EA + SA  : $${ESA}"

	@echo ""
	@echo "Wall time (ms):"
	@grep "Launch to finish" out_ft.txt | sed 's/^/  plain FT      : /'
	@grep "Launch to finish" out_sa.txt | sed 's/^/  SA + FT       : /'
	@grep "Launch to finish" out_escape.txt | sed 's/^/  escape FT   : /'
	@grep "Launch to finish" out_escape_sa.txt | sed 's/^/  escape+SA  : /'

	@echo ""
	@echo "First race report:"
	@grep 'FASTTRACK LOG' out_ft.txt | head -1 | sed 's/^/  plain FT     : /'
	@grep 'FASTTRACK LOG' out_sa.txt | head -1 | sed 's/^/  SA + FT      : /'
	@grep 'FASTTRACK LOG' out_escape.txt | head -1 | sed 's/^/  escape FT   : /'
	@grep 'FASTTRACK LOG' out_escape_sa.txt | head -1 | sed 's/^/  escape+SA  : /'


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
	      $(BENCH_FT) $(BENCH_SA) \
	      $(ESCAPE_EXEC) $(ESCAPE_EXEC_SA) \
	      out_ft.txt out_sa.txt out_escape.txt out_escape_sa.txt \
	      *.o *.so *.bc


.PHONY: all run debug clean
