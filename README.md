
# Spartan6-DSP48A1

This project explores the DSP48A1 slice in Spartan-6 FPGAs, which provides a flexible and efficient structure for implementing Digital Signal Processing (DSP) functions using dedicated hardware resources. The block includes advanced components such as a pre-adder, multiplier, and a post-adder/subtracter, allowing designers to build high-performance filters and arithmetic pipelines with minimal general logic usage.

## Features

Core functionalities supported by the DSP48A1:
- 18-bit Pre-Adder/Subtracter for early-stage operand manipulation
- 18x18 Two's Complement Multiplier with optional input registers
- 48-bit Post-Adder/Subtracter/Accumulator with carry-in support
- Input and Output Pipelines for registered stages (A, B, C, D, M, and P)
- Flexible MUXes and Operand Routing (X, Z, and M paths)
- Cascade Support using BCOUT and PCOUT for chaining slices
- Carry Chain Logic using dedicated carry-in (CIN, CARRYIN) and carry-out paths (CARRYOUT)
- Configurable via OPMODE bits (control logic, register enabling, operand selection)


## Getting Started

To simulate or implement this design, a Verilog simulator such as QuestaSim or Vivado Simulator is required.

**1. Simulating the Design (using `.do` file)**

A `project.do` script is included for automating the simulation process:
- Ensure your simulator is configured properly
- Run the following:
    - In QuestaSim console: `do run_Spartan6_DSP48A1.do`
    - Or from terminal (Linux/macOS): source `run_Spartan6_DSP48A1.do`
    - On Windows: `run_Spartan6_DSP48A1.do`

This will compile all Verilog files, run the testbench, and open the waveform viewer.

**2. Manual Simulation (Optional)**

Alternatively, manually compile all Verilog source files and run the simulation using your simulator’s GUI or terminal.

**3. Testbench Usage**

The testbench `Spartan6_DSP48A1_tb.v` is designed to verify the functionality of the DSP48A1 slice across multiple operational paths. It applies stimulus to all key inputs (A, B, C, D, PCIN, OPMODE, CARRYIN) and checks the resulting outputs against expected values.

**Key Features:**
- Clock generation using a `2ns` period.
- Full reset and enable controls for all pipeline stages (CEA, CEB, CEP, etc.).
- Initial test vector for reset behavior.
- Four directed test cases, each targeting different paths and configurations within the DSP slice.
- Assertions for correctness by comparing DUT outputs (`M`, `P`, `BCOUT`, `PCOUT`, `CARRYOUT`, and `CARRYOUTF`) against expected results.
- Error logging with `$display("ERROR!")` for failed comparisons.
- Stop simulation after all tests using `$stop`.

**Test Scenarios Include:**
- **Path 1:** Standard multiply-accumulate configuration using pre-adder with inputs A, B, D, and carry-in.
- **Path 2:** A variation with different OPMODE to disable accumulation or pre-adder effects.
- **Path 3:** Tests alternate pre-adder/subtracter behavior.
- **Path 4:** Accumulation using `PCIN`, along with changes in carry-in, confirming correct cascading and addition.
## Design Files

- `DSP48A1.v`: Main Verilog module implementing the DSP48A1 architecture.
- `ff_mux.v`: Implements pipeline registers and mux stages within the slice.
- `mux_4to1.v`: Supporting 4-to-1 multiplexer used in operand selection.
- `DSP48A1_tb.v`: Directed Verilog testbench.
- `run_Spartan6_DSP48A1.do`: Script for automating compilation and simulation.
## Block Diagram

![Spartan6 - DSP48A1](https://github.com/Ziad-Mohamed14/Spartan6-DSP48A1/blob/main/DSP48A1-block-diagram.png)

This diagram reflects the internal data path of the Spartan-6 DSP48A1 slice, including pre-adder/subtracter logic, dedicated multiplier, flexible M/Z input muxing, and a 48-bit result path.


