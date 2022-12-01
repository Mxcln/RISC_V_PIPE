`define         INSTBUS     31:0
`define         INSTADDRBUS 31:0
`define         REGBUS      31:0   
`define         REGADDRBUS  31:0
`define         MEMADDRBUS  31:0

module ex_mem (
    input   wire                    arst_n,         //异步复位信号
    input   wire                    clk_100M,            //时钟信号100M
    input   wire                    clear,          //复位信号
    input   wire                    hold,           //暂停
//输入信号
    //to    mem                                     //向访存模块发出指令
    input  wire    [`MEMADDRBUS]   rom_raddr_i,    //需要写回的信号地址
    input  wire    [`REGADDRBUS]   reg_waddr_i,    //需要写回的寄存器地址
    input  wire    [`INSTBUS]      inst_i,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    input  wire                    reg_w_ena_i,    //将写寄存器的使能信号
    input  wire    [`INSTBUS]      reg_w_data_i,   //输出写回寄存器的数据，即不需要访存的数据    

    //to    ctrl
    input  wire                    hold_flag_i,    //是否暂停
    input  wire                    jump_flag_i,    //是否跳转
    input  wire    [`INSTADDRBUS]  jump_addr_i,    //跳转的位置;  
    
    //to    wb
    input  wire    [`MEMADDRBUS]   ram_waddr_i,    //需要写的地址                                  
    input  wire    [`REGBUS]       ram_wdata_i,    //需要写回的寄存器数据

//输出信号   
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
    always@(posedge clk_100MHZ or negedge arst_n)
        if(arst_n)
            begin
                rom_raddr_i <= "0"    ;
                reg_waddr_i
            end
endmodule
