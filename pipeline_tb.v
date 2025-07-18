`timescale 1ns/1ps

module pipeline_tb;
    reg clk = 0;
    reg reset = 1;

    pipeline_processor uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, pipeline_tb);

        // Wait a bit and release reset
        #10 reset = 0;

        // Initialize register file
        uut.registers[1] = 8'd10;
        uut.registers[2] = 8'd5;
        uut.data_memory[20] = 8'd100;

        // Load Instructions:
        // ADD R1 + R2 -> R3
        uut.instruction_memory[0] = 16'b0001_0001_0010_0011;

        // SUB R1 - R2 -> R4
        uut.instruction_memory[1] = 16'b0010_0001_0010_0100;

        // LOAD [R1] -> R5
        uut.instruction_memory[2] = 16'b0011_0001_0000_0101;

        // STORE R1 -> [R2]
        uut.instruction_memory[3] = 16'b0100_0001_0010_0000;

        // NOP
        uut.instruction_memory[4] = 16'b0000_0000_0000_0000;

        #100;

        // Display Results
        $display("R3 (ADD)  = %d", uut.registers[3]);  // Expect 15
        $display("R4 (SUB)  = %d", uut.registers[4]);  // Expect 5
        $display("R5 (LOAD) = %d", uut.registers[5]);  // Expect 100
        $display("Mem[5]    = %d", uut.data_memory[5]); // Should be unchanged
        $display("Mem[5]    = %d", uut.data_memory[2]); // Should contain 10 (store)

        $finish;
    end
endmodule
