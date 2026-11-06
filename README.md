# UART_Implementation_on_Basys3
This project implements a UART-based communication system on the **Basys 3 Artix-7 FPGA** board. When connected to a PC via USB-UART and interfaced with a terminal (e.g., PuTTY),
characters typed into the terminal are received by the FPGA, processed, and echoed back. LEDs and the 7-segment display give real-time feedback.

## 📦 Repository Contents
├── src/ <br>
│ ├── uart_test.v # Top module connecting UART to LEDs & display  <br>
│ ├── uart_top.v # Complete UART controller with TX & RX <br>
│ ├── baud_rate_generator.v # Generates ticks for 9600 baud <br>
│ ├── debounce_explicit.v # Debouncer for push button <br>
│ ├── uart_rx.v # UART receiver <br>
│ ├── uart_tx.v # UART transmitter <br>
├── constraints/ <br>
│ └── basys3_uart.xdc # Pin mapping for Basys 3 <br>
├── README.md <br>


---

## ⚙️ How the System Works

### 1. UART Communication Flow

- **Transmitting from PC (via PuTTY)**: Characters typed are sent over USB-UART.
- **UART RX Module** receives serial data and converts it to 8-bit parallel form.
- **UART TX Module** transmits 8-bit parallel data back as serial.
- **Button (`btnL`)** is used to trigger both UART **read** and **write** operations.
- **Debouncer** ensures clean button signal.
- **LEDs** display received ASCII code.
- **7-Segment Display** lights up if UART RX FIFO is full or empty.

### 2. Data Processing

- The top-level module includes the line:  assign rec_data1 = rec_data + 1.
- This increments the received ASCII code by 1 before sending it back. 
- Input: a (ASCII 97) → FPGA sends back: b (ASCII 98)
- To echo exact characters, replace with:
assign rec_data1 = rec_data;

## 🛠️ Implementation on Basys 3
- ✅ Requirements:
Vivado (tested with Vivado 2020.2+), Digilent Basys 3 board, USB cable, Serial terminal software (e.g., PuTTY)

## 🔧 Steps
- Open Vivado and create a new project.

- Add Source Files:

- All .v files from src/

- Add Constraints:

- Use the .xdc file from constraints/basys3_uart.xdc

- Set Top Module:uart_test.v

- Synthesize → Implement → Generate Bitstream

- Program Device with the .bit file.

## 🧪 Testing Instructions
- Connect Basys 3 via USB.

- Open Device Manager → Ports (COM & LPT):

- Note which COM port Basys 3 is using.

- Open PuTTY:Select "Serial"

- Baud rate: 9600

- Data bits: 8

- Stop bits: 1

- Parity: None

- Flow Control: None

- Start Session and type characters.

- Press btnL (left button on Basys 3) to trigger UART read/write.

- Observe:LED pattern matches received ASCII code.

- 7-segment display lights based on FIFO status.

- Received characters are echoed back with incremented ASCII.
