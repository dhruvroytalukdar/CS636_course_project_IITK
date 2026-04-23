# WCP Predictive Data Race Detector - Milestone 1

This repository contains the foundational LLVM pass and runtime infrastructure for our WCP Predictive Data Race Detector. 

Currently, the project successfully demonstrates a dynamic analysis pipeline by intercepting memory `load` and `store` instructions via an LLVM compiler pass and redirecting them to a custom runtime monitoring library.

## Project Structure
* `InstrumentMemory.cpp`: The LLVM Pass (New Pass Manager) that injects callbacks before memory operations.
* `wcp_runtime.cpp`: The runtime library containing callbacks. (Future home of WCP Vector Clock logic).
* `target.cpp`: A dummy C++ program used to verify instrumentation.
* `Makefile`: Build system to compile the pass, emit IR, instrument, and link the final executable.

## How to Build and Run

1. **Prerequisites:** Ensure `clang`, `clang++`, `opt`, and `llvm-config` are installed and in your system's PATH (Tested on LLVM 18+).
2. **Compile everything:**
   ```bash
   make
   ```
3. **Run the instrumented target:**
   ```bash
   make run
   ```
4. **Clean Intermediate Files:**
   ```bash
   make clean
   ```