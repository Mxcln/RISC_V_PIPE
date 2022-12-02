`define         INST     31:0
`define         INSTADDR 31:0
`define         REG      31:0   
`define         REGADDR  4:0
`define         MEMADDR  31:0

module ex(
    input   wire                    arst_n,         //异步复位信号

    //from  id                                      //来自译码信号
    input   wire    [`INST]      inst_i,         //接受信号的内容         
    input   wire    [`INSTADDR]  inst_addr_i,    //接受信号的地址
    input   wire                 reg_w_ena_i,    //写寄存器使能信号
    input   wire    [`REGADDR]   reg_w_addr_i,   //写通用寄存器的地址
    input   wire    [`REG]       reg1_data_i,   //通用寄存器1的输入数据     
    input   wire    [`REG]       reg2_data_i,   //通用寄存器2的输入数据
    input   wire    [`REG]       op1_i,          //数据操作数1
    input   wire    [`REG]       op2_i,          //数据操作数2
    input   wire    [`MEMADDR]   op1_jump_i,     //跳转操作的地址操作数1        
    input   wire    [`MEMADDR]   op2_jump_i,     //跳转操作的地址操作数2

    //to    mem                                     //向访存模块发出指令
    output  wire                 ram_r_ena_o   ,   //需要访问Ram读取数据的信号
    output  reg     [`MEMADDR]   ram_r_addr_o,    //需要读取的信号地址
    output  wire    [`REGADDR]   reg_w_addr_o,    //需要写回的寄存器地址
    output  wire    [`INST]      inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  wire                 reg_w_ena_o,    //将写寄存器的使能信号
    output  wire    [`INST]      reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    //to    ctrl
 
    output  wire                 jump_flag_o,    //是否跳转
    output  wire    [`INSTADDR]  jump_addr_o,     //跳转的位置;  
    
    //to    wb
    output  reg     [`MEMADDR]   ram_w_addr_o,    //需要写的地址                                  
    output  wire    [`REG]       ram_w_data_o,    //需要写回的寄存器数据
    output  wire                 ram_w_ena_o       //需要写回的使能信号
);
endmodule