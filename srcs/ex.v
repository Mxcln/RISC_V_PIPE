`define         INSTBUS     31:0
`define         INSTADDRBUS 31:0
`define         REGBUS      31:0   
`define         REGADDRBUS  31:0
`define         MEMADDRBUS  31:0

module ex(
    input   wire                    arst_n,         //异步复位信号
    =
    //from  id                                      //来自译码信号
    input   wire    [`INSTBUS]      inst_i,         //接受信号的内容         
    input   wire    [`INSTADDRBUS]  inst_addr_i,    //接受信号的地址
    input   wire                    reg_w_ena_i,       //写寄存器使能信号
    input   wire    [`REGADDRBUS]   reg_w_addr_i,    //写通用寄存器的地址
    input   wire    [`REGBUS]       reg1_rdata_i,   //通用寄存器1的输入数据     
    input   wire    [`REGBUS]       reg2_rdata_i,   //通用寄存器2的输入数据
    input   wire    [`REGBUS]       op1_i,          //数据操作数1
    input   wire    [`REGBUS]       op2_i,          //数据操作数1
    input   wire    [`MEMADDRBUS]   op1_jump_i,     //跳转操作的地址操作数1        
    input   wire    [`MEMADDRBUS]   op2_jump_i,     //跳转操作的地址操作数2

    //to    mem                                     //向访存模块发出指令
    output  reg     [`MEMADDRBUS]   rom_raddr_o,    //需要写回的信号地址
    output  wire    [`REGADDRBUS]   reg_waddr_o,    //需要写回的寄存器地址
    output  wire    [`INSTBUS]      inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  wire                    reg_w_ena_o,    //将写寄存器的使能信号
    output  wire    [`INSTBUS]      reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    //to    ctrl
    output  wire                    hold_flag_o,    //是否暂停
    output  wire                    jump_flag_o,    //是否跳转
    output  wire    [`INSTADDRBUS]  jump_addr_o,     //跳转的位置;  
    
    //to    wb
    output  reg     [`MEMADDRBUS]   ram_waddr_o,    //需要写的地址                                  
    output  wire    [`REGBUS]       ram_wdata_o     //需要写回的寄存器数据
);
endmodule