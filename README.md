# STM32F407 Bare-Metal I2C Driver with MPU6500

## Project Overview

Implemented a complete I2C master driver from scratch using direct register-level programming and interfaced the MPU6500 IMU sensor for real-time motion data acquisition.

Sensor data was transmitted over UART for monitoring and debugging.

---

## Features

- Bare-metal I2C driver
- MPU6500 integration
- Accelerometer data acquisition
- Gyroscope data acquisition
- UART telemetry
- Register-level implementation

---

## Hardware

- STM32F407G-DISC1
- MPU6500 IMU
- FT232RL USB-UART Converter

---

## Software & Tools

- Embedded C
- CMSIS
- ARM GNU Toolchain
- GNU Make
- OpenOCD
- Logic Analyzer
- PulseView

---

## Architecture

STM32F407
|
I2C
|
MPU6500
|
UART
|
PC Terminal

---

## Results

- Successful I2C communication
- Sensor initialization and configuration
- Real-time motion data acquisition
- Protocol validation using Logic Analyzer

---

## Key Learnings

- I2C protocol
- Sensor interfacing
- Embedded debugging
- Register-level firmware development
