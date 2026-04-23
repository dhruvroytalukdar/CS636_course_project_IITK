# ==========================================
# Configuration Variables
# ==========================================
CXX = clang++ -std=c++20 -g
CC = clang -g

LLVM_CXXFLAGS = $(shell llvm-config --cxxflags)
LLVM_LDFLAGS = $(shell llvm-config --ldflags)

PASS_FLAGS = -fPIC -shared -O3

PASS_DIR = ../../
RUNTIME_SRC = $(PASS_DIR)runtime.cpp
RUNTIME_OBJ = runtime.o

BASE_PASS = $(PASS_DIR)base_pass.cpp
TARGET_PASS = $(PASS_DIR)escape_pass_ver2.cpp 

BASE_PASS_CMD = base-pass
TARGET_PASS_CMD = shared-ptr-analysis

# ==========================================
# Directory Layout & File Discovery
# ==========================================
OBJ_DIR = obj
TSAN_DIR = thread_san

# Dynamically find all .c and .cpp files in the nested bug directories
SRCS_C := $(wildcard Benchmarks/bug*/src/*.c)
SRCS_CPP := $(wildcard Benchmarks/bug*/src/*.cpp)

# Mirror the nested structure inside the object directory
# e.g., Benchmarks/bug1/src/test-js.c -> obj/bug1/src/test-js.ll
LL_FILES := $(patsubst Benchmarks/%.c, $(OBJ_DIR)/%.ll, $(SRCS_C)) \
            $(patsubst Benchmarks/%.cpp, $(OBJ_DIR)/%.ll, $(SRCS_CPP))

BASE_LL := $(LL_FILES:.ll=_base.ll)
TARGET_LL := $(LL_FILES:.ll=_target.ll)
BIN_BASE := $(LL_FILES:.ll=_base)
BIN_TARGET := $(LL_FILES:.ll=_target)

# Mirror the nested structure inside the TSAN directory
TSAN_BIN := $(patsubst Benchmarks/%.c, $(TSAN_DIR)/%_tsan, $(SRCS_C)) \
            $(patsubst Benchmarks/%.cpp, $(TSAN_DIR)/%_tsan, $(SRCS_CPP))

# ==========================================
# Standard Targets
# ==========================================
.PHONY: all clean run tsan

all: base target

# ==========================================
# Runtime & Passes
# ==========================================
$(RUNTIME_OBJ): $(RUNTIME_SRC)
	$(CXX) -O3 -c $< -o $@

base_pass.so: $(BASE_PASS)
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

target_pass.so: $(TARGET_PASS)
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

# ==========================================
# Compile to LLVM IR
# ==========================================
$(OBJ_DIR)/%.ll: Benchmarks/%.c
	@mkdir -p $(dir $@)
	$(CC) -emit-llvm -S -O0 -fno-inline -fno-builtin \
           -fno-omit-frame-pointer -g $< -o $@

$(OBJ_DIR)/%.ll: Benchmarks/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) -emit-llvm -S -O0 -fno-inline -fno-builtin \
           -fno-omit-frame-pointer -g $< -o $@

# ==========================================
# Run Passes
# ==========================================
$(OBJ_DIR)/%_base.ll: $(OBJ_DIR)/%.ll base_pass.so
	opt -S -load-pass-plugin=./base_pass.so \
        -passes="$(BASE_PASS_CMD)" $< -o $@

$(OBJ_DIR)/%_target.ll: $(OBJ_DIR)/%.ll target_pass.so
	opt -S -load-pass-plugin=./target_pass.so \
        -passes="$(TARGET_PASS_CMD)" $< -o $@

# ==========================================
# Link Binaries (Normal)
# ==========================================
$(OBJ_DIR)/%_base: $(OBJ_DIR)/%_base.ll $(RUNTIME_OBJ)
	$(CXX) -g $< $(RUNTIME_OBJ) -o $@ -lpthread

$(OBJ_DIR)/%_target: $(OBJ_DIR)/%_target.ll $(RUNTIME_OBJ)
	$(CXX) -g $< $(RUNTIME_OBJ) -o $@ -lpthread

base: $(BIN_BASE)
target: $(BIN_TARGET)

# ==========================================
# TSAN Build
# ==========================================
$(TSAN_DIR)/%_tsan: Benchmarks/%.c
	@mkdir -p $(dir $@)
	$(CC) -fsanitize=thread -g $< -o $@ -lpthread

$(TSAN_DIR)/%_tsan: Benchmarks/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) -fsanitize=thread -g $< -o $@ -lpthread

tsan: $(TSAN_BIN)
	@for bin in $(TSAN_BIN); do \
		echo "=== Running TSAN $$bin ==="; \
		$$bin || echo "--- TSAN Run Halted (Race Detected or Error) ---"; \
	done

# ==========================================
# Run all binaries
# ==========================================
run: all
	@for bin in $(BIN_BASE); do \
		echo "=== Running $$bin ==="; \
		$$bin || echo "--- Run Halted ---"; \
	done
	@for bin in $(BIN_TARGET); do \
		echo "=== Running $$bin ==="; \
		$$bin || echo "--- Run Halted ---"; \
	done

# ==========================================
# Cleanup
# ==========================================
clean:
	rm -rf $(OBJ_DIR) $(TSAN_DIR) *.so *.o
