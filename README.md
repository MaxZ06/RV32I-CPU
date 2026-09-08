# RV32I CPU

A 32-bit, single-cycle RISC-V processor written in Verilog for the RV32I base integer instruction set. The repository includes modular RTL and an Intel Quartus Prime project for a Cyclone V FPGA.

> **Status:** Work in progress. The core includes integer arithmetic, branches, jumps, and load/store control logic. System-instruction support and CSR integration are incomplete.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Simulation and Program Loading](#simulation-and-program-loading)
- [Current Limitations](#current-limitations)
- [Contributing](#contributing)
- [License](#license)

## Features

- Single-cycle datapath with a 32-bit program counter and ALU.
- 32 general-purpose registers with two asynchronous read ports and one synchronous write port; reads of `x0` always return zero.
- Separate instruction and data memories with asynchronous reads.
- Immediate generation for I, S, B, U, and J instruction formats.
- Signed and unsigned comparisons for branches and set-less-than operations.

The control unit contains logic for the following instructions. This list describes implementation coverage, not verified ISA compliance.

| Category | Instructions |
| --- | --- |
| Register arithmetic and logic | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| Immediate arithmetic and logic | `ADDI`, `SLLI`, `SLTI`, `SLTIU`, `XORI`, `SRLI`, `SRAI`, `ORI`, `ANDI` |
| Loads | `LB`, `LH`, `LW`, `LBU`, `LHU` |
| Stores | `SB`, `SH`, `SW` |
| Conditional branches | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| Jumps | `JAL`, `JALR` |
| Upper immediates | `LUI`, `AUIPC` |
| Memory ordering | `FENCE` (advances the PC without a datapath action) |

## Architecture

The top-level module, `single_cycle_CPU`, connects instruction fetch, instruction decoding, register reads, execution, data-memory access, and register writeback. The next PC is selected between `PC + 4` and a branch or jump target.

| Top-level port | Direction | Description |
| --- | --- | --- |
| `clk` | Input | Rising-edge clock for the PC, register writes, and data-memory writes. |
| `reset` | Input | Active-high, synchronous reset that sets the PC to zero. It does not clear registers or memories. |

Instruction memory holds **256 32-bit words**, indexed by `pc_out[9:2]`. Data memory holds **512 32-bit entries**, indexed directly by `ALUout[8:0]`; see [Current Limitations](#current-limitations) for its addressing behavior.

## Project Structure

```text
.
|-- README.md
|-- LICENSE
|-- single_cycle_CPU.qpf          # Quartus project
|-- single_cycle_CPU.qsf          # Device and source assignments
`-- src/single_cycle_cpu_src/
    |-- single_cycle_CPU.v       # Top-level core and interconnect
    |-- control_unit.v           # Instruction decoding and control signals
    |-- ALU.v                    # Arithmetic, logic, and shifts
    |-- comparitor_unit.v        # Signed and unsigned comparisons
    |-- imm_handler.v            # Immediate extraction and extension
    |-- regFile.v                # General-purpose register file
    |-- pc.v                     # Program counter
    |-- instruction_mem.v        # Instruction memory
    |-- data_mem.v               # Data memory and load/store formatting
    |-- datapath_mod.v           # Multiplexers and datapath helpers
    `-- csr_units.v              # CSR modules under development
```

## Getting Started

### Requirements

- Intel Quartus Prime with Cyclone V device support. The project was created with **Quartus Prime Lite 18.1**.
- A Verilog simulator for functional testing.

### Open and Build the Quartus Project

1. Clone or download this repository and open `single_cycle_CPU.qpf` in Quartus Prime.
2. Confirm the top-level entity is `single_cycle_CPU`. The configured device is **5CSEBA6U23I7** in the Cyclone V family.
3. Resolve the existing project blockers before compiling:
   - Remove the stale `datapath_modules.v` source assignment; the repository contains `src/single_cycle_cpu_src/datapath_mod.v` instead, which is already assigned.
   - Fix the unfinished `csr_handler` syntax in `csr_units.v`, or exclude that file while working on the core, which does not instantiate the CSR modules.
4. Select **Processing > Start Compilation**. Generated outputs are configured to go into `output_files/`.

Board deployment also requires suitable pin assignments, clock constraints, and a way to initialize the program and observe execution. The current top-level module exposes only `clk` and `reset`.

## Simulation and Program Loading

The repository does not currently include a testbench, program image, or automated regression suite. Instruction memory has no initialization block or built-in program loader.

To exercise the core in a simulator:

1. Create a testbench that instantiates `single_cycle_CPU` and generates a clock.
2. Load 32-bit instruction words into the instance's `imem.memory` array before execution, for example using `$readmemh` from the testbench. Fill unused locations with a defined instruction such as `ADDI x0, x0, 0` (`00000013`).
3. Initialize any data-memory or register values that the test requires. Registers other than `x0` and memory contents are otherwise undefined until written.
4. Assert `reset` across a rising clock edge, then deassert it before normal execution.
5. Check internal signals such as `pc_out`, `current_instruction`, `rf.rfReg`, and `dmem.memory` against expected results.

Reset only affects the PC; register and data-memory writes are not gated by reset. Account for this when preparing the testbench.

## Current Limitations

- **System instructions:** `ECALL` and `EBREAK` have no implemented trap handling. CSR modules are unfinished and are not connected to the top-level core.
- **Address bounds:** Instruction and data addresses are truncated to the available index bits. There is no implemented address-range or alignment exception handling.
- **Unsupported instructions:** Unhandled encodings fall through to default control signals.

## Contributing

Issues and pull requests are welcome. For RTL changes, describe the affected instructions or modules and include simulation results or a focused testbench when possible. Useful areas for contributions include instruction-level tests, byte-addressed data memory, CSR and trap support, and FPGA integration.

## License

Distributed under the [MIT License](LICENSE). Copyright (c) 2026 MaxZ06.
