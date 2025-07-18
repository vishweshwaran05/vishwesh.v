module ram #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 8)(
    input clk,
    input we,                   // Write enable
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] din, // Data input
    output reg [DATA_WIDTH-1:0] dout // Data output
);

    // RAM storage
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;     // Write
        else
            dout <= mem[addr];    // Read
    end

endmodule
