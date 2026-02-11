# Pipelined 8-bit ALU Design & Verification

## Project Overview
A high-performance **2-stage pipelined ALU** designed in SystemVerilog. This project demonstrates synchronous digital design principles, pipelining for increased throughput, and automated verification methodologies.

## Features
- **Pipelined Architecture:** Separated into Fetch and Execute stages to optimize the critical path.
- **8 Operations:** ADD, SUB, AND, OR, XOR, NOT, SLL, SRL.
- **Control Logic:** Features an asynchronous active-low reset.
- **Status Flags:** Supports Carry-out detection for 8-bit arithmetic.

## Verification Strategy
Instead of manual waveform inspection, this project utilizes a **Self-Checking Testbench**.
- **Tasks:** Used SystemVerilog tasks to drive stimulus and compare outputs against a golden model.
- **Automated Logs:** The simulation prints `[PASS]` or `[FAIL]` status for every test case.
- **Corner Cases:** Verified 8-bit overflow (255+1) and underflow (0-1).

## 📊 Simulation Results
![ALU Waveform](docs/Screenshot 2026-02-11 185845.png
.png)
*Figure 1: Waveform showing 2-cycle latency between input sampling and output result.*

### Console Log Snippet:
```text
[PASS] Time:36000 | Op:000 | A: 10 B:  5 | Result: 15 Carry:0
[PASS] Time:56000 | Op:000 | A:255 B:  1 | Result:  0 Carry:1
[PASS] Time:76000 | Op:001 | A: 20 B:  4 | Result: 16 Carry:0
[PASS] Time:96000 | Op:001 | A:  0 B:  1 | Result:255 Carry:1
[PASS] Time:116000 | Op:110 | A: 10 B:  0 | Result: 20 Carry:0
[FAIL] Time:136000 | Op:000 | Expected: 20 Carry:0 | Got: 15 Carry:0
