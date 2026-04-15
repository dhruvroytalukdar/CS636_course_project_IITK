# ==========================================
# Configuration Variables
# ==========================================
CXX = clang++ -std=c++20
CC = clang

# Fetch LLVM build flags dynamically
LLVM_CXXFLAGS = $(shell llvm-config --cxxflags)
LLVM_LDFLAGS = $(shell llvm-config --ldflags)

# Flags for building LLVM loadable modules (.so)
PASS_FLAGS = -fPIC -shared -O3

# Source files for your test program and runtime
TEST_SRC = ./src/sharing_patterns.cpp
RUNTIME_SRC = runtime.cpp
RUNTIME_OBJ = runtime.o

# The pass pipeline names (MUST match the names registered in llvmGetPassPluginInfo)
# Update these if your PassPluginInfo registers different string names!
BASE_PASS_CMD = base-pass
TARGET_PASS_CMD = shared-ptr-analysis


# ==========================================
# Standard Targets
# ==========================================
.PHONY: all clean run

all: base target

# ==========================================
# 1. Build the Runtime Library
# ==========================================
$(RUNTIME_OBJ): $(RUNTIME_SRC)
	$(CXX) -O3 -c $< -o $@

# ==========================================
# 2. Build the LLVM Passes (.so files)
# ==========================================
base_pass.so: base_pass.cpp
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

target_pass.so: target_pass.cpp
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

# ==========================================
# 3. Compile the Test Code to LLVM IR (.bc)
# ==========================================
# Using -O1 to run mem2reg and clean up noisy alloca instructions
test.bc: $(TEST_SRC)
	$(CXX) -emit-llvm -O0 -fno-inline -fno-builtin \
	       -fno-omit-frame-pointer -g \
	       -c $< -o $@
	# $(CC) -O0 -emit-llvm -c $< -o $@

# ==========================================
# 4. Run the Passes via opt
# ==========================================
test_base.bc: test.bc base_pass.so
	opt -load-pass-plugin=./base_pass.so  -passes="$(BASE_PASS_CMD)" $< -o $@

test_target.bc: test.bc target_pass.so
	opt -load-pass-plugin=./target_pass.so -passes="$(TARGET_PASS_CMD)" $< -o $@

# ==========================================
# 5. Link IR with Runtime to create Binaries
# ==========================================
base: test_base.bc $(RUNTIME_OBJ)
	$(CXX) $< $(RUNTIME_OBJ) -o $@ -lpthread

target: test_target.bc $(RUNTIME_OBJ)
	$(CXX) $< $(RUNTIME_OBJ) -o $@ -lpthread

# ==========================================
# Execution Target
# ==========================================
run: base target
	@echo "==============================="
	@echo "=== Executing BASE Binary   ==="
	@echo "==============================="
	./base
	@echo ""
	@echo "==============================="
	@echo "=== Executing TARGET Binary ==="
	@echo "==============================="
	./target

# ==========================================
# Cleanup
# ==========================================
clean:
	rm -f *.so *.bc *.o base target
