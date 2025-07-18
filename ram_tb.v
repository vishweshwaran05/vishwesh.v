`timescale 1ns / 1ps

module ram_tb;
    reg clk;
    reg we;
    reg [3:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    // Instantiate the RAM
    ram uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("ram_wave.vcd");
        $dumpvars(0, ram_tb);

        clk = 0; we = 0; addr = 0; din = 0;

        // Write some data
        #10 we = 1; addr = 4'h1; din = 8'hA5;
        #10 addr = 4'h2; din = 8'h3C;
        #10 addr = 4'h3; din = 8'hFF;

        // Read back the data
        #10 we = 0; addr = 4'h1;
        #10 addr = 4'h2;
        #10 addr = 4'h3;

        #10 $finish;
    end
endmodule
