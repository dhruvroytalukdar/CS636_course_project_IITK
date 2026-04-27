# ==============================================================================
# CONFIGURATION & TOOLCHAIN
# ==============================================================================

CXX         := clang++
CC          := clang
OPT         := opt
M4          := m4
LLVM_CONFIG := llvm-config

# LLVM Flags
LLVM_CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
LLVM_LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags)

# Common Flags for Blackscholes (Pthreads Version)
COMMON_FLAGS := -DENABLE_THREADS -pthread -DN=960 -DNCO=4 -g -O1
TSAN_FLAGS   := -fsanitize=thread

# ==============================================================================
# FILES & TARGETS
# ==============================================================================

# Blackscholes Base & Generated Pthread files
SRC_BASE := blackscholes.c
MACROS   := c.m4.pthreads
M4_SRC   := blackscholes.m4.cpp
SRC_DIR := ../../../../../fasttrack/
# Instrumentation Pass
PASS_SRC := $(SRC_DIR)escape_instrumentation.cpp
PASS_SO  := build/wcp-pass.so
PASS_CMD := shared-ptr-analysis 

# Runtime
RUNTIME_SRC := $(SRC_DIR)fasttrack_runtime.cpp
RUNTIME_OBJ := build/wcp_runtime.o

# Output Binaries
TARGET_BIN      := blackscholes
TARGET_TSAN     := $(TARGET_BIN)_tsan
TARGET_INST     := $(TARGET_BIN)_inst

# ==============================================================================
# BUILD RULES
# ==============================================================================

.PHONY: all clean tsan instrument pass runtime run_inst

all: tsan

# 1. M4 GENERATION (Pthread version)
# ------------------------------------------------------------------------------
$(M4_SRC): $(SRC_BASE)
	@echo "[*] Generating pthread source via m4..."
	$(M4) ./$(MACROS) $< > $@

# 2. TSAN BUILD
# ------------------------------------------------------------------------------
tsan: clean $(M4_SRC)
	@echo "[*] Building TSAN binary..."
	$(CXX) $(COMMON_FLAGS) $(TSAN_FLAGS) $(M4_SRC) -o $(TARGET_TSAN)
	@echo "[+] TSAN build complete: ./$(TARGET_TSAN)"

# 3. BUILD PASS & RUNTIME
# ------------------------------------------------------------------------------
build_dir:
	@mkdir -p build

pass: build_dir $(PASS_SRC)
	@echo "[*] Building LLVM Pass..."
	$(CXX) $(LLVM_CXXFLAGS) -fPIC -shared -o $(PASS_SO) $(PASS_SRC) $(LLVM_LDFLAGS)

runtime: build_dir $(RUNTIME_SRC)
	@echo "[*] Building Runtime..."
	$(CXX) $(COMMON_FLAGS) -c $(RUNTIME_SRC) -o $(RUNTIME_OBJ) -fPIC

# 4. INSTRUMENT, LINK & RUN
# ------------------------------------------------------------------------------
instrument: clean pass runtime $(M4_SRC)
	@echo "[*] Step 1: Generating LLVM IR..."
	$(CXX) $(COMMON_FLAGS) -emit-llvm -S $(M4_SRC) -o build/$(TARGET_BIN).ll

	@echo "[*] Step 2: Running instrumentation pass..."
	$(OPT) -load-pass-plugin=./$(PASS_SO) \
	       -passes=$(PASS_CMD) \
	       -S build/$(TARGET_BIN).ll -o build/$(TARGET_BIN)_inst.ll

	@echo "[*] Step 3: Compiling instrumented IR and linking runtime..."
	$(CXX) $(COMMON_FLAGS) build/$(TARGET_BIN)_inst.ll $(RUNTIME_OBJ) -o $(TARGET_INST)

	@echo "[+] Build complete. Running instrumented binary..."
	@echo "--------------------------------------------------------"
	./$(TARGET_INST) 16 ../inputs/in_16.txt out.txt

# ==============================================================================
# CLEAN
# ==============================================================================
clean:
	@echo "[*] Cleaning workspace..."
	rm -rf build/
	rm -f $(TARGET_TSAN) $(TARGET_INST) $(M4_SRC)
# # ================================

# # CONFIG

# # ================================

# CXX := clang++
# CC  := clang
# M4  := m4

# TARGET := blackscholes

# SRC_BASE := blackscholes.c
# M4_SRC   := blackscholes.m4.cpp

# MACROS := c.m4.pthreads
# M4_BASE := .

# # LLVM

# LLVM_CONFIG := llvm-config
# LLVM_CXXFLAGS := $(shell $(LLVM_CONFIG) --cxxflags)
# LLVM_LDFLAGS  := $(shell $(LLVM_CONFIG) --ldflags)

# # Passes

# BASE_PASS_SO   := ./build/libfasttrack-pass.so
# TARGET_PASS_SO := ./build/libshared-ptr-analysis.so

# BASE_PASS_CMD   := fasttrack-pass
# TARGET_PASS_CMD := shared-ptr-analysis

# # Runtime

# RUNTIME_SRC := runtime2.cpp
# RUNTIME_OBJ := runtime.o

# # TSAN

# TSAN_FLAGS := -fsanitize=thread -g -O1

# # Common flags

# COMMON_FLAGS := -DENABLE_THREADS -pthread -DN=960 -DNCO=4

# # ================================

# # DEFAULT

# # ================================

# all: tsan

# # ================================

# # M4 GENERATION (pthread version)

# # ================================

# $(M4_SRC): $(SRC_BASE)
# 	$(M4) $(M4_BASE)/$(MACROS) $< > $@

# # ================================

# # TSAN BUILD

# # ================================

# tsan: clean $(M4_SRC)
# 	$(CXX) $(COMMON_FLAGS) $(TSAN_FLAGS) $(M4_SRC) -o $(TARGET)_tsan

# # ================================

# # BUILD RUNTIME

# # ================================

# $(RUNTIME_OBJ): $(RUNTIME_SRC)
# 	$(CXX) -c $< -o $@ -fPIC

# # ================================

# # BUILD PASSES

# # ================================

# passes:
# 	mkdir -p build
# 	$(CXX) $(LLVM_CXXFLAGS) -fPIC -shared -o $(BASE_PASS_SO) base_pass2.cpp
# 	$(CXX) $(LLVM_CXXFLAGS) -fPIC -shared -o $(TARGET_PASS_SO) target_pass.cpp

# # ================================

# # INSTRUMENTED BUILD

# # ================================

# instrument: clean passes $(RUNTIME_OBJ) $(M4_SRC)

# # Step 1: generate LLVM IR
# 	$(CXX) $(COMMON_FLAGS) -emit-llvm -S $(M4_SRC) -o $(TARGET).ll

# 	# Step 2: run base pass
# 	opt -load-pass-plugin=$(BASE_PASS_SO) \
# 		-passes=$(BASE_PASS_CMD) \
# 		-S $(TARGET).ll -o $(TARGET)_base.ll

# 	# Step 3: run target pass
# 	opt -load-pass-plugin=$(TARGET_PASS_SO) \
# 		-passes=$(TARGET_PASS_CMD) \
# 		-S $(TARGET)_base.ll -o $(TARGET)_inst.ll

# 	# Step 4: compile + link runtime
# 	$(CXX) $(COMMON_FLAGS) $(TARGET)_inst.ll $(RUNTIME_OBJ) -o $(TARGET)_inst

# # ================================

# # CLEAN

# # ================================

# clean:
# 	rm -f *.o *.ll *_tsan *_inst $(M4_SRC)

# PREFIX=${PARSECDIR}/pkgs/apps/blackscholes/inst/${PARSECPLAT}
# M4 = m4
# ifdef source
# 	ifeq "$(source)" "simd" 
# 		SRC = blackscholes.simd.c
# 		CXXFLAGS += -msse3
# 	endif
# else
# 	SRC	= blackscholes.c
# 	ifdef version
# 		ifeq "$(version)" "tbb"
# 			SRC	= blackscholes.tbb.cpp
# 		endif
# 	endif
# endif
# TSAN_FLAGS = -fsanitize=thread -g -O1
# CSRC    = $(SRC)
# TARGET  = blackscholes 
# M4_BASE = .
# MACROS  = c.m4.pthreads

# ifdef version
#   ifeq "$(version)" "pthreads"
#     M4_SRC    = blackscholes.m4.cpp
#     CSRC      = $(M4_SRC)
#     MT        = -DENABLE_THREADS
#     CXXFLAGS += -pthread
#   endif
#   ifeq "$(version)" "openmp"
#     MT        = -DENABLE_OPENMP
#   endif
#   ifeq "$(version)" "tbb"
#     MT        = -DTBB_VERSION
#   endif
# else
#   MT        = 
# endif

# # Default build single precision version
# NCO     = -DNCO=4

# ifdef chk_err
# ERR     = -DERR_CHK
# endif

# ifdef single
# NCO = -DNCO=4
# endif

# ifdef size
# SZ = -DN=$(size)
# else
# SZ = -DN=960
# endif

# ifdef double
# NCO = -DNCO=2
# endif

# CXXFLAGS += $(MT) $(SZ) $(NCO) $(FUNC) $(ERR)

# all: $(TARGET)

# # $(TARGET): clean $(CSRC)
# # 	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(LIBS) -o $(TARGET)
# $(TARGET): clean $(CSRC)
# 	$(CXX) $(CXXFLAGS) $(TSAN_FLAGS) $(CSRC) $(LDFLAGS) $(LIBS) -o $(TARGET)
# $(M4_SRC): $(SRC)
# 	$(M4) $(M4_BASE)/$(MACROS) $< > $@

# clean:
# 	rm -f $(TARGET) $(M4_SRC)

# install:
# 	mkdir -p $(PREFIX)/bin
# 	cp -f $(TARGET) $(PREFIX)/bin/$(TARGET)

