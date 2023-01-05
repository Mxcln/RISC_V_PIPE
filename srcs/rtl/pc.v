
`include "define.v"
module pc(
    input wire                  clk_100MHz,
    input wire                  arst_n,
    input wire                  jump_ena_i,     // 跳转标志
    input wire                  pc_div_hold,    //除法要求的暂停
    input wire  [`INST_ADDR]    jump_addr_i,    // 跳转地址
    input wire                  hold_ena_i,     //冲刷流水线或者暂停信号输入时实现暂停
    output reg  [`INST_ADDR]    pc_addr_o       // 指令计数器地址
);
    always @(posedge clk_100MHz or negedge arst_n ) begin
        if (arst_n == `RST_ENABLE) begin
            pc_addr_o <= `CPU_RESET_ADDR;
        end
        else if (hold_ena_i == `HOLD_ENABLE || pc_div_hold == `HOLD_ENABLE ) begin
            pc_addr_o <= pc_addr_o;
        end
        else if (jump_ena_i == `JUMP_ENABLE) begin
            pc_addr_o <= jump_addr_i;
        end
        else begin
            pc_addr_o <= pc_addr_o +4;
        end
    end
endmodule


