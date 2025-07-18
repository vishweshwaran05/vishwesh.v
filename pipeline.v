`timescale 1ns/1ps

module pipeline_processor(input clk, input reset);

    // Instruction format: [15:12] opcode, [11:8] rs, [7:4] rt, [3:0] rd
    reg [15:0] instruction_memory [0:255];
    reg [7:0] data_memory [0:255];
    reg [7:0] registers [0:15];

    reg [7:0] pc;

    // Pipeline registers
    reg [15:0] IF_ID_instr;
    reg [15:0] ID_EX_instr;
    reg [7:0]  ID_EX_rs_val, ID_EX_rt_val;
    reg [3:0]  ID_EX_rd;

    reg [15:0] EX_MEM_instr;
    reg [7:0]  EX_MEM_alu_out, EX_MEM_rt_val;
    reg [3:0]  EX_MEM_rd;

    reg [15:0] MEM_WB_instr;
    reg [7:0]  MEM_WB_result;
    reg [3:0]  MEM_WB_rd;

    // Instruction decode wires
    wire [3:0] opcode = IF_ID_instr[15:12];
    wire [3:0] rs     = IF_ID_instr[11:8];
    wire [3:0] rt     = IF_ID_instr[7:4];
    wire [3:0] rd     = IF_ID_instr[3:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            IF_ID_instr <= 0;
            ID_EX_instr <= 0;
            EX_MEM_instr <= 0;
            MEM_WB_instr <= 0;
        end else begin
            // FETCH
            IF_ID_instr <= instruction_memory[pc];
            pc <= pc + 1;

            // DECODE
            ID_EX_instr <= IF_ID_instr;
            ID_EX_rs_val <= registers[rs];
            ID_EX_rt_val <= registers[rt];
            ID_EX_rd <= rd;

            // EXECUTE
            EX_MEM_instr <= ID_EX_instr;
            EX_MEM_rt_val <= ID_EX_rt_val;
            EX_MEM_rd <= ID_EX_rd;

            case (ID_EX_instr[15:12])
                4'b0001: EX_MEM_alu_out <= ID_EX_rs_val + ID_EX_rt_val; // ADD
                4'b0010: EX_MEM_alu_out <= ID_EX_rs_val - ID_EX_rt_val; // SUB
                4'b0011: EX_MEM_alu_out <= data_memory[ID_EX_rs_val];   // LOAD
                4'b0100: begin // STORE
                    data_memory[ID_EX_rt_val] <= ID_EX_rs_val;
                    EX_MEM_alu_out <= 0;
                end
                default: EX_MEM_alu_out <= 0;
            endcase

            // MEMORY (pass-through)
            MEM_WB_instr <= EX_MEM_instr;
            MEM_WB_rd <= EX_MEM_rd;
            MEM_WB_result <= EX_MEM_alu_out;

            // WRITEBACK
            if (MEM_WB_instr[15:12] != 4'b0100) // Not STORE
                registers[MEM_WB_rd] <= MEM_WB_result;
        end
    end
endmodule
