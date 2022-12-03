
`define     INSTC_WIDTH     31:0
`define     ADDR_WIDTH      31:0
`define     REG_ADDR_WIDTH  4:0
`define     DATA_WIDTH      31:0
`define     ZERO_WORD       32'd0

`define     INSTC_TYPE_I    7'b0000011
`define     INSTC_LB        3'b000
`define     INSTC_LH        3'b001
`define     INSTC_LW        3'b010
`define     INSTC_LBU       3'b100
`define     INSTC_LHU       3'B101

`define     ZERO_INSTC      32'd0
`define     ZERO_DATA       32'd0
`define     ZERO_ADDR       32'd0

`define     WRITE_DISABLE   1'b0
`define     READ_DISABLE    1'b0

module wb(
    input   wire                        arst_n      ,           //系统复位

    input   wire    [`INSTC_WIDTH]      instc_i     ,           //指令输入

    input   wire                        mem_rena_i  ,           //访存使能输入
    input   wire    [`DATA_WIDTH]       mem_rdata_i ,           //访存得到的数据输入             
    
    input   wire    [`REG_ADDR_WIDTH]   reg_addr_i  ,           //访存通用寄存器地址输入    
    
    input   wire                        mem_wena_i  ,           //写入使能输入              
    input   wire    [`ADDR_WIDTH]       mem_waddr_i ,           //写入的地址输入            
    input   wire    [`DATA_WIDTH]       mem_wdata_i             //写入的数据输入 
);



endmodule

