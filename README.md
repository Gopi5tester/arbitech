* Aout the code
* ├── src/
* │   ├── CPU.v
* │   ├── ALU.v
* │   ├── RegisterFile.v
* │   ├── MemoryInterface.v
* │   ├── ControlUnit.v
* │   └── TopLevelCPU.v
* ├── test/
* │   ├── test_CPU.v
* │   ├── test_ALU.v
* │   └── test_RegisterFile.v
* └── docs/
    └── architecture_specification.md
* This test bench only implements single block of codes if you want the know about one block easily copy the module test represent in the verilog test code and run the block of code .
This Verilog CPU design integrates several modules to form a simple, 19-bit CPU. The `TopLevelCPU` module connects the `CPU`, `RegisterFile`, `ALU`, `MemoryInterface`, and `ControlUnit`.
The `CPU` module manages the Program Counter (PC) and instruction flow. It updates the PC and registers based on opcode operations like ADD, SUB, MUL, DIV, and JMP.
The `ALU` performs arithmetic and logical operations based on the opcode, supporting operations such as addition, subtraction, multiplication, division, increment, decrement, AND, OR, XOR, and NOT.
The `RegisterFile` handles reading from and writing to registers, while the `MemoryInterface` manages memory read/write operations.
The `ControlUnit` decodes instructions to extract opcode, register addresses, and immediate values. 
Testbenches for each module verify their functionality through various test scenarios, ensuring the integrated CPU performs as expected.
