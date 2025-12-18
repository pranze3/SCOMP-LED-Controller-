# VHDL LED Controller 

This repository contains the VHDL implementation of a custom memory-mapped peripheral for the **SCOMP (Simple Computer)** architecture. Designed for the **Intel DE-10 Lite FPGA**, this peripheral provides independent, gamma-corrected PWM brightness control for up to 10 LEDs, ensuring smooth and flicker-free visual transitions.

## <u>**Project Overview**</u>
The core objective was to move beyond simple "On/Off" LED control to a system capable of 256 levels of perceptually accurate brightness. Standard linear PWM often looks "steppy" to the human eye at low brightness levels; this design solves that by implementing a **Gamma Correction Lookup Table (LUT)** directly in hardware.

The peripheral integrates seamlessly into the SCOMP I/O bus, allowing software to control LED states and brightness via specific memory addresses without requiring complex interrupts or manual timing loops.

## <u>**Architecture & Design**</u>
I implemented the core logic in VHDL (primarily in `ledcontroller.vhd`), prioritizing resource efficiency and modularity.

* **Count-and-Compare PWM:** Instead of using 10 separate timers, I designed a shared 8-bit counter that increments every clock cycle. The system compares this counter against the threshold values for all 10 channels simultaneously to generate the PWM waveforms.
* **Gamma Correction:** The 8-bit brightness values written by software are not used directly. They are passed through a hardware Lookup Table (LUT) that maps linear input values to a non-linear gamma curve. This compresses low-end values and expands the upper range to align with human visual perception.
* **Memory-Mapped Interface:**
    * `0x01` (LED_EN): A bitmask to enable/disable specific LEDs.
    * `0x20` - `0x29`: Individual 8-bit brightness registers for LEDs 0-9.

## <u>**Hardware Implementation**</u>
The design was synthesized and tested on the **Terasic DE-10 Lite** board (Intel MAX 10 FPGA).

* **SCOMP Integration:** The module connects to the standard SCOMP peripheral bus (`IO_DATA`, `IO_WRITE`, `IO_ADDR`), acting as a secondary device.
* **Efficiency:** By decoupling the "Enable" logic from the "Brightness" logic, the system allows for complex patterns (like blinking a dimmed LED) without needing to reload brightness values constantly.

## <u>**Tools Used**</u>
VHDL, Intel Quartus Prime, ModelSim (Simulation), SCOMP Assembly.
