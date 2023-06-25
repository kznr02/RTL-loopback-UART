`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/24 22:50:31
// Design Name: 
// Module Name: baud_gen
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


module baud_gen(
    input   wire    clk,
    input   wire    rst_n,
    output  reg     bclk
    );
    reg [8:0]   cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt     <=  0;
            bclk    <=  0;
        end else if(cnt > 26) begin
            // 115200 * 16 = 1843.2kbps
            // 50M / 1843200 = 27.126
            cnt     <=  0;
            bclk    <=  1;
        end else begin
            cnt     <=  cnt + 1;
            bclk    <=  0;
        end
    end
endmodule
