`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 17:55:13
// Design Name: 
// Module Name: tb_uart_rx
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


module tb_uart_rx(

    );
    reg bclk;
    reg rst_n;
    reg rxd;

    wire rx_ready;
    wire [7:0] rx_dout;

    uart_rx uut(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .rxd        (rxd),
        .rx_ready   (rx_ready),
        .rx_dout    (rx_dout)
    );

    initial begin
        bclk = 0;
        rst_n = 0;
        rxd = 1;

        #100 begin
            rst_n = 1;
            rxd = 0;
        end

        #640 rxd = 1;
    end
    always #10 bclk = ~bclk;
endmodule
