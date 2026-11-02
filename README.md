# D Flip-Flop (SystemVerilog)

A SystemVerilog implementation of a positive-edge triggered **D Flip-Flop with Asynchronous Active-High Reset**, along with a self-contained simulation testbench.

---

## 📌 Overview

A D (Data) Flip-Flop is a fundamental digital sequential circuit building block used for storing 1 bit of information. In this design:
- On every **rising edge of the clock (`posedge clk`)**, the output `Q` samples and reflects the value present at input `D`.
- The reset signal (`rst`) is **asynchronous** and **active-high**, overriding the clock to immediately clear the output `Q` to `0` whenever asserted.

---

## 📂 Project Structure

```plaintext
d_ff/
├── d_ff.sv          # Synthesizable D Flip-Flop RTL module
├── d_ff_tb.sv       # Testbench for verification and simulation
├── modelsim.ini     # Simulator configuration (ModelSim / Questa)
└── README.md        # Project documentation
```

---

## ⚙️ Module Interface

### Port List (`d_ff.sv`)

| Port Name | Direction | Type    | Description                                            |
| :-------- | :-------- | :------ | :----------------------------------------------------- |
| `clk`     | `input`   | `logic` | Clock signal (active on positive edge)                 |
| `rst`     | `input`   | `logic` | Asynchronous reset signal (active-high: `1` resets `Q`)|
| `D`       | `input`   | `logic` | Data input                                             |
| `Q`       | `output`  | `logic` | Data output                                            |

### Truth Table

| `rst` | `clk`      | `D` | `Q(t+1)` | Operation        |
| :---: | :--------: | :-: | :------: | :--------------- |
|   1   |     X      |  X  |    0     | Asynchronous Reset |
|   0   | ↑ (rising) |  0  |    0     | Reset / Store 0  |
|   0   | ↑ (rising) |  1  |    1     | Set / Store 1    |
|   0   | 0, 1, or ↓ |  X  |   `Q(t)` | Hold State       |

---

## 💻 RTL Source Code

```systemverilog
module d_ff (
    input  logic D,
    input  logic clk,
    input  logic rst,
    output logic Q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end

endmodule
```

---

## 🧪 Verification & Simulation

The testbench (`d_ff_tb.sv`) applies a 100 MHz clock (period $T = 10\text{ time units}$, toggle every $5\text{ units}$) and exercises:
1. Power-on reset initialization.
2. Data capture across multiple clock cycles ($D = 1$ and $D = 0$).
3. Asynchronous reset assertion mid-operation.
4. Normal operation recovery following reset deassertion.

### Running with ModelSim / QuestaSim

1. Open your terminal in this directory (`d_ff`):
   ```bash
   # Create work library (if not already created)
   vlib work

   # Compile RTL and testbench
   vlog d_ff.sv d_ff_tb.sv

   # Run simulation in command-line mode
   vsim -c d_ff_tb -do "run -all; quit -f"
   ```

2. Alternatively, for GUI mode with waveform viewer:
   ```bash
   vsim d_ff_tb
   ```
   In the ModelSim GUI console:
   ```tcl
   add wave -position insertpoint sim:/d_ff_tb/*
   run -all
   ```

### Running with Icarus Verilog (`iverilog`)

```bash
# Compile with SystemVerilog 2012 support
iverilog -g2012 -o d_ff_sim d_ff.sv d_ff_tb.sv

# Execute simulation
vvp d_ff_sim
```

---

## 📊 Expected Simulation Output

```text
Time=0  | rst=1 | clk=0 | D=0 | Q=0
Time=5  | rst=1 | clk=1 | D=0 | Q=0
Time=10 | rst=0 | clk=0 | D=1 | Q=0
Time=15 | rst=0 | clk=1 | D=1 | Q=1
Time=20 | rst=0 | clk=0 | D=0 | Q=1
Time=25 | rst=0 | clk=1 | D=0 | Q=0
Time=30 | rst=0 | clk=0 | D=1 | Q=0
Time=35 | rst=0 | clk=1 | D=1 | Q=1
Time=40 | rst=0 | clk=0 | D=0 | Q=1
Time=45 | rst=0 | clk=1 | D=0 | Q=0
Time=50 | rst=1 | clk=0 | D=0 | Q=0
Time=60 | rst=0 | clk=0 | D=1 | Q=0
Time=65 | rst=0 | clk=1 | D=1 | Q=1
```

---

## 📄 License

This project is licensed for educational and open-source use.

