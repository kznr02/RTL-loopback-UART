`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 11:38:00
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input   wire        bclk,
    input   wire        rst_n,
    input   wire        rxd,

    output  reg         rx_done,
    output  reg         rx_ready,
    output  reg [7:0]   rx_dout
    );

    parameter [3:0] Lframe      = 8;
    parameter [1:0] s_idle      = 2'b00;
    parameter [1:0] s_sample    = 2'b01;
    parameter [1:0] s_stop      = 2'b10;

    reg       [1:0] cur_state   = s_idle;
    reg       [3:0] cnt         = 0;
    reg       [3:0] num         = 0;
    reg       [3:0] dcnt        = 0;

    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            cur_state <= s_idle;
            cnt <= 0;
            dcnt <= 0;
            num <= 0;
            rx_dout <= 0;
            rx_ready <= 0;
            rx_done <=  0;
        end else begin
            case (cur_state)
            // Idle State
                s_idle: begin
                    rx_dout <= 0;
                    dcnt <=0;
                    rx_ready <= 1;
                    rx_done <=  0;
                    if(cnt == 4'b1111) begin
                        cnt <= 0;
                        if(num > 7) begin
                            cur_state <= s_sample;
                            num <= 0;
                        end else begin
                            cnt <= 0;
                            cur_state <= s_idle;
                            num <= 0;
                        end 
                    end else begin
                        cnt <= cnt + 1;
                        if(rxd == 1'b0) begin
                            num <= num + 1;
                        end else begin
                            num <= num;
                        end
                    end
                end
            // Sampling State
                s_sample: begin
                    rx_ready <= 1'b0;
                    rx_done <=  0;
                    if(dcnt == Lframe) begin
                        cur_state <= s_stop;
                    end else begin
                        cur_state <= s_sample;
                        if(cnt == 4'b1111) begin
                            dcnt <= dcnt + 1;
                            cnt <= 0;
                            if(num > 7) begin
                                num <= 0;
                                rx_dout[dcnt] <= 1;
                            end else begin
                                rx_dout[dcnt] <= 0;
                                num <= 0;
                            end
                        end else begin
                            cnt <= cnt + 1;
                            if(rxd == 1'b1) begin
                                num <= num + 1;
                            end else begin
                                num <= num;
                            end
                        end
                    end
                end
            // Stop State
                s_stop: begin
                    rx_ready <= 1'b1;
                    rx_done <=  1'b1;
                    if(cnt == 4'b1111) begin
                        cnt <= 0;
                        cur_state <= s_idle;
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
                default: begin
                    cur_state <= s_idle;
                end
            endcase
        end
    end
endmodule
