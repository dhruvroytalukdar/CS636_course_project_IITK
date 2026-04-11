# LLVM Configuration
CXX = clang++
OPT = opt
LLVM_CXXFLAGS = $(shell llvm-config --cxxflags)
LLVM_LDFLAGS = $(shell llvm-config --ldflags)

# File names
PASS_SRC = wcp_instrumentation.cpp
PASS_OBJ = wcp_instpass.so
RUNTIME_SRC = wcp_runtime.cpp
RUNTIME_OBJ = wcp_runtime.o
TARGET_SRC = target.cpp
TARGET_IR = target.ll
INSTRUMENTED_IR = instrumented.ll
FINAL_EXEC = instrumented_target

all: $(FINAL_EXEC)

# 1. Compile the LLVM Pass into a shared object (.so)
$(PASS_OBJ): $(PASS_SRC)
	$(CXX) -O3 -shared -fPIC $(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) $< -o $@

# 2. Compile the Runtime Library into an object file
$(RUNTIME_OBJ): $(RUNTIME_SRC)
	$(CXX) -O3 -c $< -o $@

# 3. Emit LLVM IR for the Target Program
$(TARGET_IR): $(TARGET_SRC)
	$(CXX) -O0 -S -emit-llvm $< -o $@

# 4. Run the Pass over the Target IR using the New Pass Manager
$(INSTRUMENTED_IR): $(TARGET_IR) $(PASS_OBJ)
	$(OPT) -load-pass-plugin=./$(PASS_OBJ) -passes="instrument-memory" $< -S -o $@

# 5. Compile the Instrumented IR and Link with the Runtime Library
$(FINAL_EXEC): $(INSTRUMENTED_IR) $(RUNTIME_OBJ)
	$(CXX) $(INSTRUMENTED_IR) $(RUNTIME_OBJ) -o $@

# 6. Execute the final instrumented program
run: $(FINAL_EXEC)
	./$(FINAL_EXEC)


clean:
	rm -f *.so *.o *.ll

	# ... (Previous variable definitions for CXX, OPT, LLVM_CXXFLAGS, etc. remain the same)

# New variables for Escape Analysis
ESCAPE_PASS_SRC = escape_instrumentation.cpp
ESCAPE_PASS_OBJ = escape_instpass.so
BUILD_DIR = build
ESCAPE_IR = $(BUILD_DIR)/instrumented_escape.ll
ESCAPE_EXEC = $(BUILD_DIR)/instrumented_escape

# Updated Phony targets
.PHONY: all clean run instrument_escape

# ... (Previous rules for PASS_OBJ, RUNTIME_OBJ, TARGET_IR remain the same)

# 1. Compile the Escape Analysis LLVM Pass
$(ESCAPE_PASS_OBJ): $(ESCAPE_PASS_SRC)
	$(CXX) -O3 -shared -fPIC $(LLVM_CXXFLAGS) $(LLVM_LDFLAGS) $< -o $@

# 2. Run Escape Analysis Pass and output to build directory
$(ESCAPE_IR): $(TARGET_IR) $(ESCAPE_PASS_OBJ)
	mkdir -p $(BUILD_DIR)
	$(OPT) -load-pass-plugin=./$(ESCAPE_PASS_OBJ) -passes="shared-ptr-analysis" $< -S -o $@

# 3. Link the Instrumented IR with the Runtime and place the binary in build/
$(ESCAPE_EXEC): $(ESCAPE_IR) $(RUNTIME_OBJ)
	$(CXX) $^ -o $@

# 4. Master target for Escape Instrumentation
instrument_escape: $(ESCAPE_EXEC)

# Updated clean rule to remove build directory
clean:
	rm -rf *.so *.o *.ll $(BUILD_DIR)
