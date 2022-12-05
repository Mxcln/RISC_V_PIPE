
`include "define.v"

module id_ex (
    input   wire  clk_100MHz,
    input   wire  arst_n,

    input   wire  [`INST]           inst_i,         //指令内容
    input   wire  [`INST_ADDR]      inst_addr_i,    //指令地址
    input   wire  [`REG]            reg1_r_data_i,  // 通用寄存器1数据
    input   wire  [`REG]            reg2_r_data_i,  // 通用寄存器2数据
    input   wire                    reg_w_ena_i,    // 写通用寄存器标志
    input   wire  [`REG_ADDR]       reg_w_addr_i,   // 写通用寄存器地址

    input   wire                    mem_r_ena_i ,
    input   wire                    mem_w_ena_i ,

    input   wire    [`MEM_ADDR]     op1_i,          //操作数1
    input   wire    [`MEM_ADDR]     op2_i,          //操作数2
    input   wire    [`MEM_ADDR]     op1_jump_i,     //跳转操作数1
    input   wire    [`MEM_ADDR]     op2_jump_i,     //跳转操作数2
    
    input wire                      hold_ena_i,      //系统暂停
    input wire                      jump_ena_i,      //表示冲刷流水线或者跳转信号

    output  reg     [`INST]         inst_o,             // 指令内容
    output  reg     [`INST_ADDR]    inst_addr_o,        // 指令地址
    output  reg     [`REG]          reg1_r_data_o,      // 通用寄存器1数据
    output  reg     [`REG]          reg2_r_data_o,      // 通用寄存器2数据
    output  reg                     reg_w_ena_o,          // 写通用寄存器标志
    output  reg     [`REG_ADDR]     reg_w_addr_o,       // 写通用寄存器地址

    output  reg                     mem_r_ena_o ,
    output  reg                     mem_w_ena_o ,

    output  reg [`MEM_ADDR]         op1_o,          //操作数1
    output  reg [`MEM_ADDR]         op2_o,          //操作数2
    output  reg [`MEM_ADDR]         op1_jump_o,     //跳转操作数1
    output  reg [`MEM_ADDR]         op2_jump_o      //跳转操作数2
);
    always @(posedge clk_100MHz or negedge arst_n) begin
        if (arst_n == `RST_ENABLE) begin
            inst_o <= `ZERO_INST;
            inst_addr_o <= `CPU_RESET_ADDR;
            reg1_r_data_o <= `ZERO_WORD;
            reg2_r_data_o <= `ZERO_WORD;
            reg_w_ena_o <= `WRITE_DISABLE;
            reg_w_addr_o <= `ZERO_REG;
            mem_r_ena_o  <= `READ_DISABLE;
            mem_w_ena_o <= `WRITE_DISABLE;
            op1_o <= `ZERO_WORD;
            op2_o <= `ZERO_WORD;
            op1_jump_o <= `ZERO_WORD;
            op2_jump_o <= `ZERO_WORD;
        end
        else if (hold_ena_i == `HOLD_ENABLE) begin
            inst_o <= inst_o ;
            inst_addr_o <= inst_addr_o ;
            reg1_r_data_o <= reg1_r_data_o;
            reg2_r_data_o <= reg2_r_data_o;
            reg_w_ena_o <= reg_w_ena_o;
            reg_w_addr_o <= reg_w_addr_o;
            mem_r_ena_o  <= mem_r_ena_o;
            mem_w_ena_o <= mem_w_ena_o;
            op1_o <= op1_o;
            op2_o <= op2_o;
            op1_jump_o <= op1_jump_o;
            op2_jump_o <= op2_jump_o;

        end
        else if (jump_ena_i == `JUMP_ENABLE) begin
            inst_o <= `ZERO_INST;
            inst_addr_o <= `CPU_RESET_ADDR;
            reg1_r_data_o <= `ZERO_WORD;
            reg2_r_data_o <= `ZERO_WORD;
            reg_w_ena_o <= `WRITE_DISABLE;
            reg_w_addr_o <= `ZERO_REG;
            mem_r_ena_o  <= `READ_DISABLE;
            mem_w_ena_o <= `WRITE_DISABLE;
            op1_o <= `ZERO_WORD;
            op2_o <= `ZERO_WORD;
            op1_jump_o <= `ZERO_WORD;
            op2_jump_o <= `ZERO_WORD;
        end 
        else begin
            inst_o <= inst_i ;
            inst_addr_o <= inst_addr_i ;
            reg1_r_data_o <= reg1_r_data_i;
            reg2_r_data_o <= reg2_r_data_i;
            reg_w_ena_o <= reg_w_ena_i;
            reg_w_addr_o <= reg_w_addr_i;
            mem_r_ena_o <= mem_r_ena_i;
            mem_w_ena_o <= mem_w_ena_i;
            op1_o <= op1_i;
            op2_o <= op2_i;
            op1_jump_o <= op1_jump_i;
            op2_jump_o <= op2_jump_i;
        end
    end
    
endmodule