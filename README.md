
# APB GPIO Controller (Verilog)

## Overview

This project implements an APB-based General Purpose Input/Output (GPIO) Controller in Verilog.

The GPIO peripheral allows software to:

- Configure GPIO pins as input or output
- Write data to output pins
- Read external input pin values
- Access GPIO registers through an APB interface
- Support tri-state GPIO operation

The design was verified using a directed Verilog testbench.

---

## Features

- APB Slave Interface
- Configurable GPIO Direction Register
- GPIO Data Output Register
- GPIO Data Input Register
- Tri-state GPIO Pins
- Register Read/Write Support
- Simple Directed Testbench Verification

---

## Register Map

| Address | Register   | Description               |
|---------|------------|---------------------------|
| 0x00    | DATAOUT    | GPIO Output Data Register |
| 0x04    | DIR        | GPIO Direction Register   |
| 0x08    | DATAIN     | GPIO Input Data Register  |
| 0x0C    | INT_EN     | Interrupt Enable Register |
| 0x10    | INT_STATUS | Interrupt Status Register |

---

## GPIO Direction Control

| DIR Bit | Mode |
|----------|------|
| 0 | Input |
| 1 | Output |

Example:

```text
DIR = 0x000000FF
```

Lower 8 GPIO pins operate as outputs.

---

## Project Structure

```text
APB_GPIO_Verilog/
│
├── rtl/
│   ├── gpio_top.v
│   ├── gpio_ctrl.v
│   └── gpio_prt_interface.v
│
├── tb/
│   └── apb_gpio_tb.v
│
└── README.md
```

---

## Verification Scenario

### Test 1
Write DIR Register

```text
Address = 0x04
Data    = 0x000000FF
```

Expected:
- Lower 8 GPIO pins configured as outputs

### Test 2
Write DATAOUT Register

```text
Address = 0x00
Data    = 0x0000000A
```

Expected:
- GPIO output pins drive 0x0A

### Test 3
Read DIR Register

Expected:

```text
0x000000FF
```

### Test 4
Configure GPIO as Inputs

```text
DIR = 0x00000000
```

### Test 5
Read External GPIO Inputs

External Value:

```text
0x000000AA
```

Expected:

```text
DATAIN = 0x000000AA
```

---

## Simulation Results

The waveform confirms:

- Successful APB register writes
- Successful APB register reads
- Correct GPIO output driving
- Correct GPIO input readback
- Proper tri-state behavior

---

## Tools Used

- Verilog HDL
- Vivado Simulator
- GTKWave (optional)

---

## Future Improvements

- APB4 Support
- GPIO Interrupt Logic
- Edge/Level Trigger Detection
- UVM-Based Verification Environment
- Functional Coverage

---

## Author

Joel Chris Sam Rajesh S

GitHub: https://github.com/Joelchrissamrajesh
LinkedIn: <your-linkedin-profile>
