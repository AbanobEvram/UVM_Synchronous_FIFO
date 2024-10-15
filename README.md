# UVM_Synchronous_FIFO
## Introduction
 The FIFO (First In, First Out) memory system is a fundamental data structure used to manage data flow in both hardware and software systems. Its main principle is that the first data to enter is also the first to exit, similar to a queue. FIFO is widely used in buffering, communication protocols, and synchronization between data streams with different rates. In verification, the UVM (Universal Verification Methodology) is employed to ensure that the FIFO design behaves as expected. This system includes a detailed verification environment that tests various scenarios for read and write operations, both synchronously and asynchronously.

---
## FIFO Architecture

### Inputs:
- **clk (Clock)**:  
  The clock signal used to synchronize the FIFO's read and write operations. It controls the timing of the internal processes.
  
- **rst_n (Reset, active low)**:  
  An active-low reset signal that initializes or resets the internal states (e.g., pointers, count) when `rst_n` is low.

- **wr_en (Write Enable)**:  
  Controls whether data is written into the FIFO. If `wr_en` is high and the FIFO is not full, data is written to the memory.

- **rd_en (Read Enable)**:  
  Controls whether data is read from the FIFO. If `rd_en` is high and the FIFO is not empty, data is read from the memory.

- **data_in (Input Data)**:  
  The data input that is written into the FIFO when `wr_en` is high. It is represented as a bit vector of size `FIFO_WIDTH`.

### Outputs:
- **data_out (Output Data)**:  
  The data output that is read from the FIFO when `rd_en` is high. The data comes from the location pointed to by the `rd_ptr`.

- **wr_ack (Write Acknowledge)**:  
  A signal that confirms data has been successfully written to the FIFO.

---

## FIFO Internal Signals & Logic

### Internal Registers and Logic
1. **mem (Memory Array)**:  
   The actual memory used by the FIFO to store data. It has a depth of `FIFO_DEPTH`, and each element has a width of `FIFO_WIDTH`.  
   - Example: `reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];`

2. **wr_ptr (Write Pointer)**:  
   This pointer keeps track of the memory location where the next write operation will occur. It increments after each successful write and wraps around to the beginning if the maximum FIFO depth is reached.

3. **rd_ptr (Read Pointer)**:  
   This pointer tracks the memory location from which the next read operation will occur. It increments after each successful read and wraps around when the FIFO reaches its maximum depth.

4. **count (Data Count)**:  
   A register that keeps track of the number of data elements currently stored in the FIFO. It increments when data is written and decrements when data is read.  
   - The `count` value helps determine the FIFO status signals such as `full`, `empty`, `almostfull`, and `almostempty`.

### FIFO Operation Logic

#### Write Operation:
- Data is written into the FIFO when the `wr_en` signal is high and the FIFO is not full (`count < FIFO_DEPTH`).
- The `wr_ptr` increments after each write operation to point to the next available memory location.
- The `wr_ack` signal is set high to acknowledge a successful write operation.
- If a write is attempted while the FIFO is full, the `overflow` signal is set high.

#### Read Operation:
- Data is read from the FIFO when the `rd_en` signal is high and the FIFO is not empty (`count > 0`).
- The `rd_ptr` increments after each read operation to point to the next memory location.
- If a read is attempted while the FIFO is empty, the `underflow` signal is set high.

### Count Logic:
- The `count` is incremented when data is written and decremented when data is read.
- When both read and write operations occur simultaneously:
  - If the FIFO is not full, the `count` is incremented.
  - If the FIFO is not empty, the `count` is decremented.
- The `count` value controls the following status signals:
  - `full = (count == FIFO_DEPTH)`
  - `empty = (count == 0)`
  - `almostfull = (count == FIFO_DEPTH - 1)`
  - `almostempty = (count == 1)`
