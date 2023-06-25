`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 21:06:35
// Design Name: 
// Module Name: tb_uart_top
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


module tb_uart_top(

    );

    reg clk_50M;
    reg rst_n;
    reg rxd;
    wire txd;

    

    uart_top uut(
        .clk    (clk_50M),
        .rst_n  (rst_n),
        .txd    (txd),
        .rxd    (rxd)
    );

    initial begin
        clk_50M = 0;
        rst_n = 0;
        rxd = 0;

        #100 rst_n = 1;

        // #5000 rxd =  1;
    end

    
    always #10 begin
        clk_50M = ~clk_50M;
    end

    always #200 begin
        rxd = ~rxd;
    end


endmodule
