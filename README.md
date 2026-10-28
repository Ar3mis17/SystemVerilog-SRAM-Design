# SRAM Memory Design in SystemVerilog

A compact SystemVerilog project implementing and verifying two synchronous SRAM architectures: a 32-bit-wide memory with 1,024 addressable words, and a four-bank memory organization with 256 words per bank.

## Overview

### 1. 32-bit SRAM — 1,024 words
- 1,024 memory locations, each 32 bits wide.
- 10-bit address input.
- Synchronous write and registered read data.
- Testbench writes and reads back eight locations, checking the returned data.

### 2. Four-bank SRAM
- Four independently selected banks.
- 256 words per bank, with each word 32 bits wide.
- 2-bit bank selector and 8-bit address.
- Testbench writes distinct values to the same address in each bank and verifies the readback.

## Repository Contents

| File | Description |
|---|---|
| `sram_64kb.sv` | 1,024 × 32-bit synchronous SRAM model |
| `tb_sram_64kb.sv` | Testbench for SRAM write/read verification |
| `sram_4bank.sv` | Four-bank SRAM model, 256 × 32 bits per bank |
| `tb_sram_4bank.sv` | Testbench for bank selection and readback verification |

Only the essential SystemVerilog source and testbench files are included. Simulator-generated databases, build directories, logs, and other temporary files are intentionally excluded.

## Requirements

- Cadence Xcelium (`xrun`) or another simulator with SystemVerilog support.
- A terminal configured to run the simulator.

## Run the Simulations

Run these commands from the repository directory.

### 32-bit SRAM

```bash
xrun -sv sram_64kb.sv tb_sram_64kb.sv -top tb_sram_64kb
```

### Four-bank SRAM

```bash
xrun -sv sram_4bank.sv tb_sram_4bank.sv -top tb_sram_4bank
```

The testbenches generate a 10 ns clock, perform write operations, read the stored values, compare them against expected data, and print `PASS` or `FAIL` results. A successful run ends with `$finish`.

## Simulation Output

The following output is from the included testbenches. Simulator startup messages and environment-specific warnings are omitted.

### 32-bit SRAM

```text
Starting SRAM write phase
WRITE: address=5 data=11111111
WRITE: address=17 data=22222222
WRITE: address=100 data=33333333
WRITE: address=250 data=44444444
WRITE: address=511 data=55555555
WRITE: address=700 data=66666666
WRITE: address=900 data=77777777
WRITE: address=1023 data=88888888
Starting SRAM read/verify phase
PASS: address=5 data=11111111
PASS: address=17 data=22222222
PASS: address=100 data=33333333
PASS: address=250 data=44444444
PASS: address=511 data=55555555
PASS: address=700 data=66666666
PASS: address=900 data=77777777
PASS: address=1023 data=88888888
SRAM 64KB TEST PASS
Simulation complete via $finish
```

### Four-bank SRAM

```text
Starting four-bank SRAM write phase
WRITE: bank=0 address=10 data=11111111
WRITE: bank=1 address=10 data=22222222
WRITE: bank=2 address=10 data=33333333
WRITE: bank=3 address=10 data=44444444
Starting four-bank SRAM read/verify phase
PASS: bank=0 data=11111111
PASS: bank=1 data=22222222
PASS: bank=2 data=33333333
PASS: bank=3 data=44444444
FOUR-BANK SRAM TEST PASS
Simulation complete via $finish
```

## Design Notes

- Both memory models use positive-edge-triggered sequential logic.
- Reads are registered, so the output updates on the rising clock edge.
- The memory arrays are behavioral models intended for RTL simulation and learning; synthesis results depend on the target device and tool settings.
- The testbenches use explicit data comparisons (`!==`) to detect mismatches, including unknown values.

## License

No license is specified. Add a license file if you intend to grant others explicit permission to use, modify, and distribute this code.
