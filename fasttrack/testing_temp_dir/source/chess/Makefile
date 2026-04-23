# ==========================================
# Configuration Variables
# ==========================================
CXX = clang++ -std=c++20 -g
CC = clang

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
# Input Files
# ==========================================
FILES = \
    InterlockedWorkStealQueue.cpp \
    InterlockedWorkStealQueueWithState.cpp \
    StateWorkStealQueue.cpp \
    WorkStealQueue.cpp

# SRC_DIR = ../targets/old_targets_dhruv
SRC_DIR = ./
OBJ_DIR = obj
TSAN_DIR = thread_san

# Derived names
LL_FILES = $(FILES:.cpp=.ll)
BASE_LL = $(FILES:.cpp=_base.ll)
TARGET_LL = $(FILES:.cpp=_target.ll)
BIN_BASE = $(FILES:.cpp=_base)
BIN_TARGET = $(FILES:.cpp=_target)

# Add directory prefixes
LL_FILES := $(addprefix $(OBJ_DIR)/, $(LL_FILES))
BASE_LL := $(addprefix $(OBJ_DIR)/, $(BASE_LL))
TARGET_LL := $(addprefix $(OBJ_DIR)/, $(TARGET_LL))
BIN_BASE := $(addprefix $(OBJ_DIR)/, $(BIN_BASE))
BIN_TARGET := $(addprefix $(OBJ_DIR)/, $(BIN_TARGET))

TSAN_BIN := $(addprefix $(TSAN_DIR)/, $(FILES:.cpp=_tsan))

# ==========================================
# Standard Targets
# ==========================================
.PHONY: all clean run tsan dirs

all: dirs base target

dirs:
	mkdir -p $(OBJ_DIR) $(TSAN_DIR)

# ==========================================
# Runtime
# ==========================================
$(RUNTIME_OBJ): $(RUNTIME_SRC)
	$(CXX) -O3 -c $< -o $@

# ==========================================
# Passes
# ==========================================
base_pass.so: $(BASE_PASS)
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

target_pass.so: $(TARGET_PASS)
	$(CXX) $(LLVM_CXXFLAGS) $(PASS_FLAGS) $< -o $@ $(LLVM_LDFLAGS)

# ==========================================
# Compile to LLVM IR
# ==========================================
$(OBJ_DIR)/%.ll: $(SRC_DIR)/%.cpp
	$(CXX) -emit-llvm -S -O0 -fno-inline -fno-builtin \
	       -fno-omit-frame-pointer -g \
	       $< -o $@

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
# Run all binaries
# ==========================================
run: all
	@for bin in $(BIN_BASE); do \
		echo "=== Running $$bin ==="; \
		$$bin; \
	done
	@for bin in $(BIN_TARGET); do \
		echo "=== Running $$bin ==="; \
		$$bin; \
	done

# ==========================================
# TSAN Build
# ==========================================
# $(TSAN_DIR)/%_tsan: $(SRC_DIR)/%.cpp $(RUNTIME_OBJ)
	# $(CXX) -fsanitize=thread -g $< $(RUNTIME_OBJ) -o $@ -lpthread
$(TSAN_DIR)/%_tsan: $(SRC_DIR)/%.cpp
	$(CXX) -fsanitize=thread -g $< -o $@ -lpthread
tsan: dirs $(TSAN_BIN)
	@for bin in $(TSAN_BIN); do \
		echo "=== Running TSAN $$bin ==="; \
		$$bin; \
	done

# ==========================================
# Cleanup
# ==========================================
clean:
	rm -rf $(OBJ_DIR) $(TSAN_DIR) *.so *.o
# PERL=perl.exe 

# LIBFLAGS=/nologo
# CFLAGS=/nologo /EHsc /Zi /Oi $(CLIB) /Gm- /W4 /Gs /D_X86_
# DLLENTRY=_DllMainCRTStartup@12

# ! if "$(BUILDDEBUG)"=="1"
# CLIB=/MDd
# LIBFLAGS=$(LIBFLAGS) /debug
# LINKFLAGS=$(LINKFLAGS) /machine:x86 /debugtype:cv,fixup /debug
# ! else
# CLIB=/MD
# LINKFLAGS=$(LINKFLAGS) /machine:x86 /release 
# ! endif

# runtestloader.dll: runtestloader.cpp twothreads.dll
# ! if "$(INSTALLTEST)"=="1"
# 	copy /y $*.cpp ..\Installer\Tests\Win32
# ! endif
# 	cl /LD $(CFLAGS) runtestloader.cpp twothreads.lib

# .SUFFIXES: .cpp  .dll

# .cpp.dll:
# ! if "$(INSTALLTEST)"=="1"
# 	copy /y $*.cpp ..\Installer\Tests\Win32
# ! endif
# 	cl /LD $(CFLAGS) /Fe$@ /Fd$*.pdb $< \
# 		/link $(LINKFLAGS) /incremental:no /subsystem:console \
# 		/entry:$(DLLENTRY)
# 	mt.exe -manifest $@.manifest -outputresource:$@;2


# vistabuild: 
# 	$(PERL) regression.pl -nog nmake:build dllfile.vista

# build: 
# 	$(PERL) regression.pl -nog nmake:build dllfile

# cleanbuild: 
# 	$(PERL) regression.pl -nog nmake dllfile dllfile.vista

# regress:
# 	$(PERL) regression.pl cmdfile dllfile

# vistaregress:
# 	$(PERL) regression.pl cmdfile dllfile.vista

# golden:
# 	$(PERL) regression.pl -g cmdfile dllfile

# vistagolden:
# 	$(PERL) regression.pl -g cmdfile dllfile.vista

# all: build vistabuild regress vistaregress

# ##############################################################################

# clean:
# 	-del *~ *.obj *.lib *.exp *.pdb *.dll 2>nul
