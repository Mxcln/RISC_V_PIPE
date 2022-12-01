`include "define.v"
`define INSTADDR 31:0
`define HOLD_ENA 3:0    //hold标志要几位?
`define INST 31:0
`define REG 31:0
`define REGADDR 4:0
`define MEMADDR 31:0
//译码电路，纯组合逻辑
module id (
    input wire arst_n,
    //from if_id
    input wire [`INST] inst_i,           //指令内容
    input wire [`INSTADDR] inst_addr_i,  //指令地址
    //from regs
    input wire [`REG] reg1_rdata_i,      //读寄存器1数据
    input wire [`REG] reg2_rdata_i,      //读寄存器2数据
    //from ex
    input wire  ex_jump_ena_i,           //ex跳转指令
    //to regs
    output reg[`REGADDR] reg1_raddr_o,    // 读通用寄存器1地址
    output reg[`REGADDR] reg2_raddr_o,    // 读通用寄存器2地址
    //to ex
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