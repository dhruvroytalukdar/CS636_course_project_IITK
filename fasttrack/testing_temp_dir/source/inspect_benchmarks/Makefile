# ==========================================
# Configuration Variables
# ==========================================
CXX = clang++ -std=c++20 -g
# Changed from c11 to gnu11 to support fdopen/fileno POSIX functions
CC = clang -std=gnu11 -g

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
RUN_ENV = run_env

SRCS = $(wildcard *.c)
BASENAMES = $(SRCS:.c=)

# Flat mapping (only one % per rule)
LL_FILES = $(patsubst %.c, $(OBJ_DIR)/%.ll, $(SRCS))
BASE_LL = $(LL_FILES:.ll=_base.ll)
TARGET_LL = $(LL_FILES:.ll=_target.ll)

BIN_BASE = $(patsubst %.c, $(OBJ_DIR)/%_base.x, $(SRCS))
BIN_TARGET = $(patsubst %.c, $(OBJ_DIR)/%_target.x, $(SRCS))
TSAN_BIN = $(patsubst %.c, $(TSAN_DIR)/%_tsan.x, $(SRCS))

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
$(OBJ_DIR)/%.ll: %.c
	@mkdir -p $(OBJ_DIR)
	$(CC) -emit-llvm -S -O0 -fno-inline -fno-builtin \
           -fno-omit-frame-pointer $< -o $@

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
$(OBJ_DIR)/%_base.x: $(OBJ_DIR)/%_base.ll $(RUNTIME_OBJ)
	$(CXX) -g $< $(RUNTIME_OBJ) -o $@ -lpthread

$(OBJ_DIR)/%_target.x: $(OBJ_DIR)/%_target.ll $(RUNTIME_OBJ)
	$(CXX) -g $< $(RUNTIME_OBJ) -o $@ -lpthread

base: $(BIN_BASE)
target: $(BIN_TARGET)

# ==========================================
# TSAN Build
# ==========================================
$(TSAN_DIR)/%_tsan.x: %.c
	@mkdir -p $(TSAN_DIR)
	$(CC) -fsanitize=thread -g $< -o $@ -lpthread

tsan: $(TSAN_BIN)
	@export num_threads=4; \
	for src in $(SRCS); do \
		base=$${src%.c}; \
		args=$$(head -n 1 $$src | grep "args:" | sed 's/.*args:\(.*\)/\1/' | sed "s/{NUMTHREADS}/$$num_threads/g" | sed "s/{OUTFILE}/output.txt/g" || echo ""); \
		bin="$(TSAN_DIR)/$${base}_tsan.x"; \
		if [ -x $$bin ]; then \
			echo "=== Running TSAN $$bin $$args ==="; \
			mkdir -p $(RUN_ENV)/$$base; \
			[ -f bzip_input ] && cp bzip_input $(RUN_ENV)/$$base/ 2>/dev/null || true; \
			(cd $(RUN_ENV)/$$base && ../../$$bin $$args) || echo "--- TSAN Halted ---"; \
		fi \
	done

# ==========================================
# Execution Target
# ==========================================
run: all
	@export num_threads=4; \
	for src in $(SRCS); do \
		base=$${src%.c}; \
		args=$$(head -n 1 $$src | grep "args:" | sed 's/.*args:\(.*\)/\1/' | sed "s/{NUMTHREADS}/$$num_threads/g" | sed "s/{OUTFILE}/output.txt/g" || echo ""); \
		for variant in _base.x _target.x; do \
			bin="$(OBJ_DIR)/$${base}$$variant"; \
			if [ -x $$bin ]; then \
				echo "=== Running $$bin $$args ==="; \
				mkdir -p $(RUN_ENV)/$$base; \
				[ -f bzip_input ] && cp bzip_input $(RUN_ENV)/$$base/ 2>/dev/null || true; \
				(cd $(RUN_ENV)/$$base && ../../$$bin $$args) || echo "--- Run Halted ---"; \
			fi \
		done \
	done

# ==========================================
# Cleanup
# ==========================================
clean:
	rm -rf $(OBJ_DIR) $(TSAN_DIR) $(RUN_ENV) *.so *.o
