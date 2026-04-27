# Making Data Race Detection Efficient: Dynamic and Static Analysis

## Project Structure
* `/fasttrack`: Contains implementation for FastTrack, FastTrack with sharing and FastTrack with escape analysis.
* `/benchmarks`: Contains the target programs to be instrumented and tested with race detector.
* `/wcp`: Contains implementation for plain WCP, WCP with static analysis, and WCP with escape analysis.

## How to Build and Run

1. **Prerequisites:** Ensure `clang`, `clang++`, `opt`, and `llvm-config` are installed and in your system's PATH (Tested on LLVM 20+).
2. **Navigate to the desired directory:**
   - For FastTrack: 
     ```bash
     cd fasttrack
     ```
   - For WCP:
     ```bash
     cd wcp
     ```
3. **Get helper message** on compilation and execution:
   ```bash
   make help
   ```
3. **Compile and run all four version (plain, plain with sharing analysis, plain with escape analysis, and plain with sharing and escape analysis):**
   ```bash
   make run
   ```
4. **Clean Intermediate Files:**
   ```bash
   make clean
   ```