`timescale 1ns / 1ps

module uart_tx(
    input   wire            bclk,
    input   wire            rst_n,
    input   wire            tx_cmd,
    input   wire    [7:0]   tx_din,
    output  reg             tx_ready,
    output  reg             txd
);
    parameter [3:0] Lframe  = 8;
    parameter [2:0] s_idle  = 3'b000;
    parameter [2:0] s_start = 3'b001;
    parameter [2:0] s_wait  = 3'b010;
    parameter [2:0] s_shift = 3'b011;
    parameter [2:0] s_stop  = 3'b100;

    reg [2:0]   cur_state   =   s_idle;
    reg [3:0]   cnt         =   0;
    reg [3:0]   dcnt        =   0;
    
    always @(posedge bclk or negedge rst_n) begin
        if(!rst_n) begin
            cur_state   <=  s_idle;
            cnt         <=  0;
            tx_ready    <=  0;
            txd         <=  1;
        end else begin
            case (cur_state)
                s_idle: begin
                    tx_ready    <=  1;
                    cnt         <=  0;
                    txd         <=  1;
                    if(tx_cmd == 1'b1) begin
                        cur_state <= s_start;
                    end else begin
                        cur_state <= s_idle;
                    end
                end

                s_start: begin
                    tx_ready    <=  0;
                    txd         <=  1'b0;
                    cur_state   <=  s_wait;
                end

                s_wait: begin
                    tx_ready    <=  0;
                    if(cnt >= 4'b1110) begin
                        cnt         <=  0;
                        if(dcnt == Lframe) begin
                            cur_state   <=  s_stop;
                            dcnt        <=  0;
                            txd         <=  1'b1;
                        end else begin
                            cur_state   <=  s_shift;
                            txd         <=  txd;
                        end
                    end else begin
                        cur_state   <=  s_wait;
                        cnt         <=  cnt + 1;
                    end
                end

                s_shift: begin
                    tx_ready        <=  0;
                    txd             <=  tx_din[dcnt];
                    dcnt            <=  dcnt + 1;
                    cur_state       <=  s_wait;
                end

                s_stop: begin
                    txd             <=  1'b1;
                    if(cnt >= 4'b1110) begin
                        cur_state   <=  s_idle;
                        cnt         <=  0;
                        tx_ready    <=  1;
                    end else begin
                        cur_state   <=  s_stop;
                        cnt         <=  cnt + 1;    
                    end
                end

                default: begin
                    cur_state       <=  s_idle;
                end
            endcase

        end
    end
endmodule