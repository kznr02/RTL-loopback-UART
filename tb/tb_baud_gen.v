`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/24 23:06:51
// Design Name: 
// Module Name: tb_baud_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_baud_gen();
    reg clk_50Mhz;
    reg rst_n;

    wire    bclk;

    baud_gen uut(
        .clk    (clk_50Mhz),
        .rst_n  (rst_n),
        .bclk   (bclk)
    );

    initial begin
        clk_50Mhz = 0;
        rst_n = 0;
        #100    rst_n = 1;
    end

    always #10 clk_50Mhz = ~clk_50Mhz;
endmodule
