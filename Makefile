# LLVM Configuration
CXX = clang++
OPT = opt
LLVM_CXXFLAGS = $(shell llvm-config --cxxflags)
LLVM_LDFLAGS = $(shell llvm-config --ldflags)

# File names
PASS_SRC = InstrumentMemory.cpp
PASS_OBJ = InstrumentMemoryPass.so
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

.PHONY: all clean