// alu_tb.v
`timescale 1ns/1ps

module alu_tb;

reg [2:0] opcode;
reg [7:0] operandA, operandB;
wire [7:0] result;

// Instantiate the ALU
alu uut (
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(result)
);

initial begin
    $dumpfile("alu_wave.vcd");  
    $dumpvars(0, alu_tb);       

    $monitor("Time=%0t | opcode=%b | A=%d | B=%d | result=%d", $time, opcode, operandA, operandB, result);

    operandA = 8'd15;
    operandB = 8'd5;

    opcode = 3'b000; #10;  // ADD
    opcode = 3'b001; #10;  // SUB
    opcode = 3'b010; #10;  // AND
    opcode = 3'b011; #10;  // OR
    opcode = 3'b100; #10;  // XOR
    opcode = 3'b101; #10;  // NOT (A)
    opcode = 3'b110; #10;  // Shift Left
    opcode = 3'b111; #10;  // Shift Right

    $finish;
end

endmodule