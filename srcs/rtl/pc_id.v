`include "define.v"

module pc_id (
    input wire clk_100MHz,
    input wire arst_n,

    input wire[`INST]       inst_i,
    input wire[`INST_ADDR]  inst_addr_i,
    
    input wire              hold_ena_i,      //系统暂停或者冲刷流水线时暂停
    input wire              jump_ena_i,      //跳转信号
                            
    output reg[`INST]       inst_o,
    output reg[`INST_ADDR]  inst_addr_o

);
    always @(posedge clk_100MHz or negedge arst_n) begin
        if (arst_n == `RST_ENABLE) begin
            inst_o <= `CPU_RESET_ADDR ;
            inst_addr_o <= `CPU_RESET_ADDR ;
        end
        else if (hold_ena_i == `HOLD_ENABLE) begin         
            inst_o <= inst_o ;
            inst_addr_o <= inst_addr_o ;
        end
        else if (jump_ena_i == `JUMP_ENABLE) begin
            inst_o <= `CPU_RESET_ADDR ;
            inst_addr_o <= `CPU_RESET_ADDR ;
        end 
        else begin
            inst_o <= inst_i ;
            inst_addr_o <= inst_addr_i ;
        end

    end

    
endmodule