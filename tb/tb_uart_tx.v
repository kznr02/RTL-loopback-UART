`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/24 23:44:52
// Design Name: 
// Module Name: tb_uart_tx
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


module tb_uart_tx(

    );
    reg         bclk;
    reg         rst_n;
    reg [7:0]   tx_din;
    reg         tx_cmd;

    wire    tx_ready;
    wire    txd;

    uart_tx uut(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .tx_din     (tx_din),
        .tx_cmd     (tx_cmd),
        .tx_ready   (tx_ready),
        .txd        (txd)
    );

    initial begin
        bclk = 0;
        rst_n = 0;
        tx_din = 0;
        tx_cmd = 0;

        #100 rst_n = 1;
        #20 begin
            tx_din = 10;
            tx_cmd = 1;
        end
        #20 tx_cmd = 0;
    end

    always #10 bclk = !bclk;
endmodule
