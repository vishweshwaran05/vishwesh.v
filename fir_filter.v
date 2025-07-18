`timescale 1ns/1ps

module fir_filter #(parameter N = 4)(
    input clk,
    input reset,
    input signed [7:0] x_in,
    output reg signed [15:0] y_out
);
    reg signed [7:0] h [0:N-1];
    reg signed [7:0] x_reg [0:N-1];
    reg signed [15:0] acc;
    integer i;

    initial begin
        h[0] = 8'd1;
        h[1] = 8'd2;
        h[2] = 8'd3;
        h[3] = 8'd4;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_out <= 0;
            for (i = 0; i < N; i = i + 1)
                x_reg[i] <= 0;
        end else begin
            for (i = N-1; i > 0; i = i - 1)
                x_reg[i] <= x_reg[i-1];
            x_reg[0] <= x_in;

            acc = 0;
            for (i = 0; i < N; i = i + 1)
                acc = acc + x_reg[i] * h[i];
            y_out <= acc;
        end
    end
endmodule
