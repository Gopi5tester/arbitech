module testbench;
    reg clk;
    reg reset;
    wire [18:0] pc;
    wire [18:0] result;
    TopLevelCPU dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
     
        reset = 1;
        #10;
        reset = 0;
        #100;

        #500; 

        $stop;
    end
    initial begin
        $monitor("Time = %0t, PC = %h, Result = %h", $time, pc, result);
    end
endmodule

module test_CPU;
    reg clk;
    reg reset;
    wire [18:0] pc;
    wire [18:0] result;
    TopLevelCPU uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .result(result)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        #100;
        reset = 0;
        #1000;
        $stop;
    end
endmodule
module ALU_tb;
    reg [3:0] opcode;
    reg [18:0] a;
    reg [18:0] b;
    wire [18:0] result;

    ALU uut (
        .opcode(opcode),
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        // Test ADD
        opcode = 4'b0000; a = 19'd10; b = 19'd20;
        #10;
        // Test SUB
        opcode = 4'b0001; a = 19'd20; b = 19'd10;
        #10;
        // Test MUL
        opcode = 4'b0010; a = 19'd3; b = 19'd4;
        #10;
        // Test DIV
        opcode = 4'b0011; a = 19'd20; b = 19'd4;
        #10;
        // Test INC
        opcode = 4'b0100; a = 19'd5;
        #10;
        // Test DEC
        opcode = 4'b0101; a = 19'd5;
        #10;
        // Test AND
        opcode = 4'b0110; a = 19'd5; b = 19'd3;
        #10;
        // Test OR
        opcode = 4'b0111; a = 19'd5; b = 19'd3;
        #10;
        // Test XOR
        opcode = 4'b1000; a = 19'd5; b = 19'd3;
        #10;
        // Test NOT
        opcode = 4'b1001; a = 19'd5;
        #10;
        
        $stop;
    end
endmodule
module RegisterFile_tb;
    reg clk;
    reg [3:0] read_reg1;
    reg [3:0] read_reg2;
    reg [3:0] write_reg;
    reg [18:0] write_data;
    reg reg_write;
    wire [18:0] read_data1;
    wire [18:0] read_data2;

    RegisterFile uut (
        .clk(clk),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reg_write = 1;
        write_reg = 4'd1;
        write_data = 19'd10;
        #10;
        write_reg = 4'd2;
        write_data = 19'd20;
        #10;
        reg_write = 0;
        read_reg1 = 4'd1;
        read_reg2 = 4'd2;
        #10;

        $stop;
    end
endmodule
module MemoryInterface_tb;
    reg clk;
    reg [18:0] address;
    reg [18:0] write_data;
    reg mem_write;
    reg mem_read;
    wire [18:0] read_data;

    MemoryInterface uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        address = 19'd0;
        write_data = 19'd42;
        mem_write = 1;
        mem_read = 0;
        #10;
        mem_write = 0;
        mem_read = 1;
        #10;

        $stop;
    end
endmodule
module ControlUnit_tb;
    reg [18:0] instruction;
    wire [3:0] opcode;
    wire [3:0] rd;
    wire [3:0] rs1;
    wire [3:0] rs2;
    wire [18:0] imm;

    ControlUnit uut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm)
    );

    initial begin
        instruction = 19'b0001000100010001000;
        #10;
        $stop;
    end
endmodule

