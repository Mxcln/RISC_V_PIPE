
`include "define.v"
`define INSTADDR 31:0
`define HOLD_ENA 3:0    //hold标志要几位?
`define INST 31:0
`define REG 31:0
`define REGADDR 4:0
`define MEMADDR 31:0
module id_ex (
    input wire  clk_100MHz,
    input wire  arst_n,

    input wire [`INST] inst_i,           //指令内容
    input wire [`INSTADDR] inst_addr_i,  //指令地址
    input wire[`REG] reg1_rdata_i,        // 通用寄存器1数据
    input wire[`REG] reg2_rdata_i,        // 通用寄存器2数据
    input wire reg_we_i,                  // 写通用寄存器标志
    input wire[`REGADDR] reg_waddr_i,     // 写通用寄存器地址
    input wire[`MEMADDR] op1_i,          //操作数1
    input wire[`MEMADDR] op2_i,          //操作数2
    input wire[`MEMADDR] op1_jump_i,     //跳转操作数1
    input wire[`MEMADDR] op2_jump_i,      //跳转操作数2
    
    output reg[`INST] inst_o,             // 指令内容
    output reg[`INSTADDR] inst_addr_o,    // 指令地址
    output reg[`REG] reg1_rdata_o,        // 通用寄存器1数据
    output reg[`REG] reg2_rdata_o,        // 通用寄存器2数据
    output reg reg_we_o,                  // 写通用寄存器标志
    output reg[`REGADDR] reg_waddr_o,     // 写通用寄存器地址
    output reg[`MEMADDR] op1_o,          //操作数1
    output reg[`MEMADDR] op2_o,          //操作数2
    output reg[`MEMADDR] op1_jump_o,     //跳转操作数1
    output reg[`MEMADDR] op2_jump_o      //跳转操作数2
);
    
endmodule