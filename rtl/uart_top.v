`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/22 21:53:38
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input   wire    clk,
    input   wire    rst_n,

    input   wire    rxd,
    output  wire    txd
    );

    wire    bclk;
    baud_gen    inst_baud_gen(
        .clk    (clk),
        .rst_n  (rst_n),
        .bclk   (bclk)
    );
    
    wire    tx_ready;
    reg    [7:0]    loop_dout;
    reg tx_cmd  =   0;
    uart_tx     inst_uart_tx(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .tx_cmd     (tx_cmd),
        .tx_din     (loop_dout),
        .tx_ready   (tx_ready),
        .txd        (txd)
    );

    wire    rx_ready;
    wire    rx_done;
    wire [7:0] dout_tmp;
    uart_rx     inst_uart_rx(
        .bclk       (bclk),
        .rst_n      (rst_n),
        .rxd        (rxd),

        .rx_done    (rx_done),
        .rx_ready   (rx_ready),
        .rx_dout    (dout_tmp)
    );

    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            tx_cmd <= 0;
            loop_dout <= 0;
        end else if(rx_done && tx_ready) begin
            loop_dout <= dout_tmp;
            tx_cmd <= 1;
        end else if (tx_ready) begin
            loop_dout <= 0;
            tx_cmd <= 0;
        end else begin
            tx_cmd <= 0;
        end
    end
endmodule
