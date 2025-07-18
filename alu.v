// alu.v
module alu (
    input [2:0] opcode,
    input [7:0] operandA,
    input [7:0] operandB,
    output reg [7:0] result
);

always @(*) begin
    case (opcode)
        3'b000: result = operandA + operandB;       // ADD
        3'b001: result = operandA - operandB;       // SUB
        3'b010: result = operandA & operandB;       // AND
        3'b011: result = operandA | operandB;       // OR
        3'b100: result = operandA ^ operandB;       // XOR
        3'b101: result = ~operandA;                 // NOT (operandA only)
        3'b110: result = operandA << 1;             // Shift Left
        3'b111: result = operandA >> 1;             // Shift Right
        default: result = 8'd0;
    endcase
end

endmodule