# FPGA Digital Clock

A 24-hour clock, stopwatch and countdown timer written in Verilog for the Terasic DE1-SoC. All three use the board's 50 MHz clock and share its six seven-segment digits. A mode controller routes the push-buttons to the selected function. Three red LEDs show which mode is active.

## Get the project

```sh
git clone https://github.com/JamesCondos/FPGA_Clock.git
cd FPGA_Clock/Final_Design_FPGA_Clock
```

## Run on the board

Use a DE1-SoC with the Cyclone V device `5CSEMA5F31C6`, a USB-Blaster connection, and Quartus Prime Programmer. You can program the board directly using the included [compiled FPGA image](Final_Design_FPGA_Clock/output_files/Final_Clock_Project.sof).

1. Power the board and connect its USB-Blaster port to the computer.
2. Open **Tools → Programmer** in Quartus Prime. Under **Hardware Setup**, select the USB-Blaster and set the programming mode to **JTAG**.
3. Use **Auto Detect** to show the JTAG chain. Select the Cyclone V FPGA entry and use **Change File** to select `output_files/Final_Clock_Project.sof`.
4. Check **Program/Configure** for the FPGA and click **Start**. At 100%, `LEDR[9]` should be lit and the rightmost pair of digits should count seconds.

To rebuild after editing the Verilog, install Quartus Prime Lite with Cyclone V device support. The archived build used version 22.1. Run the following from the project directory in a shell with Quartus on its path, then program the resulting `.sof` as above. [Original build report](Final_Design_FPGA_Clock/output_files/Final_Clock_Project.flow.rpt)

```sh
quartus_sh --flow compile Final_Clock_Project
```

### Controls

Press `KEY[3]` to cycle through the modes.

| Mode | Display | Controls |
| --- | --- | --- |
| Clock · `LEDR[9]` | Hours, minutes, seconds | Hold `KEY[2]` for one second to edit seconds. Further presses select minutes, hours and then normal timekeeping. `KEY[1]` adds and `KEY[0]` subtracts from the selected field. |
| Stopwatch · `LEDR[8]` | Minutes, seconds, hundredths | `KEY[0]` starts or pauses the stopwatch. `KEY[2]` clears the count. |
| Countdown · `LEDR[7]` | Hours, minutes, seconds | Press `KEY[2]` to stop and clear. While stopped, use `KEY[1]` to add seconds. `KEY[0]` starts or pauses the timer. `LEDR[0]` signals completion. |

## Try the mode selector in a simulator

This example uses Icarus Verilog (`iverilog` and `vvp`) in a Bash shell on Linux or WSL. Run it from the same project directory. The test bench drives the top-level design with a 20 ns clock period, presses and releases `KEY[3]` three times, and reads the three mode LEDs after each press.

```bash
sim_dir=$(mktemp -d)
iverilog -g2012 -s watch_demo -o "$sim_dir/watch.vvp" ./*.v /dev/stdin <<'VERILOG'
`timescale 1ns/1ps
module watch_demo;
  reg clk = 0;
  reg [3:0] keys;
  wire [9:0] leds;
  Final_watch watch(.CLOCK_50(clk), .KEY(keys), .SW(2'b00), .LEDR(leds));
  always #10 clk = ~clk;

  initial begin
    keys = 4'b1111;
    #40;
    $display("Clock:     %b", leds[9:7]);
    repeat (3) begin
      keys[3] = 0;
      #40;
      keys[3] = 1;
      #40;
      $display("Next mode: %b", leds[9:7]);
    end
    $finish;
  end
endmodule
VERILOG
vvp "$sim_dir/watch.vvp"
```

Icarus may report port-width warnings during compilation. The run prints the following mode sequence.

```text
Clock:     100
Next mode: 010
Next mode: 001
Next mode: 100
```

## How it works

The top-level module connects the mode controller to the timekeeping modules and display. The clock divides the 50 MHz input into one-second ticks and rolls over after 23:59:59. The stopwatch uses a 500,000-cycle divider for hundredths of a second. The project gave me practical experience with sequential and combinational logic, finite-state machines, synthesis and debugging on hardware. [Top-level wiring](Final_Design_FPGA_Clock/Final_Watch.v) · [Clock counters](Final_Design_FPGA_Clock/Time.v) · [Stopwatch](Final_Design_FPGA_Clock/Stop_watch.v) · [Countdown](Final_Design_FPGA_Clock/CDT.v)
