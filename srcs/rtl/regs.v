
`include "define.v"

module regs (
    input wire  clk_100MHz,
    input wire  arst_n,
    //from wb
    input wire w_ena_i,                      // 写寄存器标志
    input wire[`REG_ADDR] w_addr_i,      // 写寄存器地址
    input wire[`REG] w_data_i,          // 写寄存器数据
    //from id
    input wire[`REG_ADDR] reg1_r_addr_i,
    input wire[`REG_ADDR] reg2_r_addr_i,
    // to id
    output reg[`REG] reg1_r_data_o,
    output reg[`REG] reg2_r_data_o
);
    reg[`REG] regs[`REG_NUM];
    //写寄存器
    integer i;
    always @(posedge clk_100MHz or negedge arst_n) begin
        if (arst_n == `RST_ENABLE) begin
        for (i = 0; i < 32 ;i = i + 1) begin
            regs[i] = `ZERO_WORD;
        end
        end
        else if ((w_ena_i == `WRITE_ENABLE) && (w_addr_i != `ZERO_REG)) begin
            regs[w_addr_i] <= w_data_i;
        end
    end
    //读寄存器1
    always @(*) begin
        if (reg1_r_addr_i == `ZERO_REG) begin
            reg1_r_data_o = `ZERO_WORD;
        end 
        else if (reg1_r_addr_i == w_addr_i && w_ena_i == `WRITE_ENABLE) begin
            reg1_r_data_o = w_data_i;
        end else begin
            reg1_r_data_o = regs[reg1_r_addr_i];//把读寄存器的地址所对应的data取出来
        end
    end
    //读寄存器2
    always @(*) begin
        if (reg2_r_addr_i == `ZERO_REG) begin
            reg2_r_data_o = `ZERO_WORD;
        end 
        else if (reg2_r_addr_i == w_addr_i && w_ena_i == `WRITE_ENABLE) begin
            reg2_r_data_o = w_data_i;
        end else begin
            reg2_r_data_o = regs[reg2_r_addr_i];//把读寄存器的地址所对应的data取出来
        end
    end
endmodule