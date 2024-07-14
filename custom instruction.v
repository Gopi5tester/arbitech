module FFT (
    input [18:0] data_in,
    output [18:0] data_out
);
    assign data_out = data_in + 19'h1; 
endmodule

module ENC (
    input [18:0] data_in,
    output [18:0] data_out
);
    assign data_out = data_in ^ 19'hAAAAA; 
endmodule

module DEC (
    input [18:0] data_in,
    output [18:0] data_out
);
    assign data_out = data_in ^ 19'hAAAAA; 
endmodule

module ALU (
    input [18:0] a,
    input [18:0] b,
    input [4:0] opcode,
    output reg [18:0] result
);
       wire [18:0] fft_out;
    wire [18:0] enc_out;
    wire [18:0] dec_out;

       FFT fft_inst (.data_in(b), .data_out(fft_out));
    ENC enc_inst (.data_in(b), .data_out(enc_out));
    DEC dec_inst (.data_in(b), .data_out(dec_out));

    always @(*) begin
        case (opcode) 
            5'b10000: result = fft_out; 
            5'b10001: result = enc_out; 
            5'b10010: result = dec_out; 
            default: result = 19'b0;
        endcase
    end
endmodule

module CPU (
    input clk,
    input rst,
    input [18:0] instr,
    output [18:0] ALU_out
);
        wire [4:0] opcode = instr[18:14];     wire [4:0] r1 = instr[13:9];
    wire [4:0] r2 = instr[8:4];
    wire [4:0] r3 = instr[3:0];

        wire [18:0] reg_r1;
    wire [18:0] reg_r2;
    wire [18:0] alu_result;

       ALU alu_inst (
        .a(reg_r1),
        .b(reg_r2),
        .opcode(opcode),
        .result(alu_result)
    );

       reg [18:0] registers [31:0]; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
                       integer i;
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 19'b0;
        end
        else begin
                       if (opcode == 5'b10000 || opcode == 5'b10001 || opcode == 5'b10010) begin
                registers[r1] <= alu_result;
            end
        end
    end

    assign reg_r1 = registers[r2];
    assign reg_r2 = registers[r3];

        assign ALU_out = alu_result;
endmodule
module CPU_tb;
        reg clk;
    reg rst;
    reg [18:0] instr;
    wire [18:0] ALU_out;

       CPU cpu_inst (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .ALU_out(ALU_out)
    );

       initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

       initial begin
        // Reset the CPU
        rst = 1;
        #10;
        rst = 0;

        cpu_inst.registers[1] = 19'h00001;
        cpu_inst.registers[2] = 19'h00002;
        cpu_inst.registers[3] = 19'h00003;
        cpu_inst.registers[4] = 19'h00004;

     
        instr = {5'b10000, 5'b00001, 5'b00010, 5'b00011}; // FFT r1, r2
        #10;

        instr = {5'b10001, 5'b00001, 5'b00010, 5'b00011}; // ENC r1, r2
        #10;


        instr = {5'b10010, 5'b00001, 5'b00010, 5'b00011}; // DEC r1, r2
        #10;

        instr = {5'b00000, 5'b00001, 5'b00010, 5'b00011}; // ADD r1, r2
        #10;

      
        $finish;
    end
    initial begin
        $monitor("Time = %0d, instr = %b, ALU_out = %h", $time, instr, ALU_out);
    end
endmodule
