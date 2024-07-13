module TopLevelCPU (
    input clk,
    input reset,
    output [18:0] pc,
    output [18:0] result
);
    wire [18:0] instruction;
    wire [18:0] read_data1, read_data2;
    wire [18:0] alu_result;
    wire [3:0] opcode, rd, rs1, rs2;
    wire [18:0] imm;

    // CPU instance
    CPU cpu (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .pc(pc),
        .result(result)
    );

    // Register File instance
    RegisterFile reg_file (
        .clk(clk),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(alu_result),
        .reg_write(1'b1),  // This should be controlled by control unit
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU instance
    ALU alu (
        .opcode(opcode),
        .a(read_data1),
        .b(read_data2),
        .result(alu_result)
    );

    // Memory Interface instance
    MemoryInterface mem_if (
        .clk(clk),
        .address(pc),
        .write_data(alu_result),
        .mem_write(1'b0), // This should be controlled by control unit
        .mem_read(1'b1),
        .read_data(instruction)
    );

    // Control Unit instance
    ControlUnit control (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm)
    );
endmodule

module CPU (
    input clk,
    input reset,
    input [18:0] instruction,
    output [18:0] pc,
    output [18:0] result
);
    reg [18:0] PC;
    reg [18:0] ALU_out;

    wire [3:0] opcode = instruction[18:15];
    wire [3:0] rd = instruction[14:11];
    wire [3:0] rs1 = instruction[10:7];
    wire [3:0] rs2 = instruction[6:3];
    wire [18:0] imm = instruction[18:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 19'b0;
        end else begin
            case (opcode)
                4'b1111: PC <= imm; // JMP
                default: PC <= PC + 1;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            ALU_out <= 19'b0;
        end else begin
            case (opcode)
                4'b0000: ALU_out <= ALU_out; // ADD
                4'b0001: ALU_out <= ALU_out; // SUB
                4'b0010: ALU_out <= ALU_out; // MUL
                4'b0011: ALU_out <= ALU_out; // DIV
                default: ALU_out <= ALU_out;
            endcase
        end
    end

    assign pc = PC;
    assign result = ALU_out;
endmodule

module ALU (
    input [3:0] opcode,
    input [18:0] a,
    input [18:0] b,
    output reg [18:0] result
);
    always @(*) begin
        case (opcode)
            4'b0000: result = a + b; // ADD
            4'b0001: result = a - b; // SUB
            4'b0010: result = a * b; // MUL
            4'b0011: result = a / b; // DIV
            4'b0100: result = a + 1; // INC
            4'b0101: result = a - 1; // DEC
            4'b0110: result = a & b; // AND
            4'b0111: result = a | b; // OR
            4'b1000: result = a ^ b; // XOR
            4'b1001: result = ~a;    // NOT
            default: result = 19'b0;
        endcase
    end
endmodule

module RegisterFile (
    input clk,
    input [3:0] read_reg1,
    input [3:0] read_reg2,
    input [3:0] write_reg,
    input [18:0] write_data,
    input reg_write,
    output [18:0] read_data1,
    output [18:0] read_data2
);
    reg [18:0] registers [15:0];

    always @(posedge clk) begin
        if (reg_write) begin
            registers[write_reg] <= write_data;
        end
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
endmodule

module MemoryInterface (
    input clk,
    input [18:0] address,
    input [18:0] write_data,
    input mem_write,
    input mem_read,
    output [18:0] read_data
);
    reg [18:0] memory [0:524287]; // 2^19 memory locations

    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
    end

    assign read_data = (mem_read) ? memory[address] : 19'b0;
endmodule

module ControlUnit (
    input [18:0] instruction,
    output reg [3:0] opcode,
    output reg [3:0] rd,
    output reg [3:0] rs1,
    output reg [3:0] rs2,
    output reg [18:0] imm
);
    always @(*) begin
        opcode = instruction[18:15];
        rd = instruction[14:11];
        rs1 = instruction[10:7];
        rs2 = instruction[6:3];
        imm = instruction;
    end
endmodule
