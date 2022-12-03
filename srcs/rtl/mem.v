
`define     RST_ENA         1'b0
`define     MEM_READ_ENABLE 1'b1

`define     INSTC_WIDTH     31:0
`define     ADDR_WIDTH      31:0
`define     REG_ADDR_WIDTH  4:0
`define     REG_DATA_WIDTH  31:0
`define     DATA_WIDTH      31:0
`define     ZERO_WORD       32'd0

`define     INSTC_TYPE_I    7'b0000011
`define     INSTC_LB        3'b000
`define     INSTC_LH        3'b001
`define     INSTC_LW        3'b010
`define     INSTC_LBU       3'b100
`define     INSTC_LHU       3'B101

module  mem(
    input   wire                        arst_n  ,               //系统复位                  
    
    input   wire    [`INSTC_WIDTH]      instc_i     ,           //指令输入                  
    
    input   wire                        mem_rena_i  ,           //访存使能输入
    input   wire    [`DATA_WIDTH]       mem_rdata_i ,           //访存得到的数据输入               
    input   wire    [`ADDR_WIDTH]       mem_raddr_i ,           //访存地址输入              
    
    input   wire                        reg_wena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG_DATA_WIDTH]   reg_wdata_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR_WIDTH]   reg_waddr_i ,           //写入通用寄存器地址输入    
    
    input   wire                        mem_wena_i  ,           //写入使能输入              
    input   wire    [`ADDR_WIDTH]       mem_waddr_i ,           //写入的地址输入            
    input   wire    [`DATA_WIDTH]       mem_wdata_i ,           //写入的数据输入            
    
    output  wire    [`INSTC_WIDTH]      instc_o     ,           //指令输出

    output  wire                        mem_rena_o  ,           //访存使能输出
    output  wire    [`DATA_WIDTH]       mem_rdata_o ,           //访存得到的数据输出

    output  wire                        reg_wena_o  ,           //写入通用寄存器的使能输出
    output  wire    [`REG_DATA_WIDTH]   reg_wdata_o ,           //写入通用寄存器数据输出        
    output  wire    [`REG_ADDR_WIDTH]   reg_waddr_o ,           //写入通用寄存器地址输出  

    output  wire                        mem_wena_o  ,           //写入使能输出              
    output  wire    [`ADDR_WIDTH]       mem_waddr_o ,           //写入的地址输出            
    output  wire    [`DATA_WIDTH]       mem_wdata_o             //写入的数据输出            
);               

    reg     [`ADDR_WIDTH]   mem_rdata;

    wire    [31:25]     imm;            //12位立即数
    wire    [24:20]     rs1;            //rs1储存需要数据的地址（加上立即数）
    wire    [14:12]     funct3;         //决定访存指令类型
    wire    [11:7]      rd;             //读入访存数据
    wire    [6:0]       opcode;         //判断是否为I型指令

    assign {imm,rs1,funct3,rd,opcode} = instc_i;

    always@(*) begin
        if(arst_n != `RST_ENA && mem_rena_i == `MEM_READ_ENABLE) begin
            mem_rdata <= mem_rdata_i;
        end
    end

    assign  instc_o     = instc_i       ;

    assign  mem_rena_o  = mem_rena_i    ;
    assign  mem_rdata_o = mem_rdata     ;

    assign  reg_wena_o  = reg_wena_i    ;
    assign  reg_wdata_o = reg_wdata_i   ;
    assign  reg_waddr_o = reg_waddr_i   ;

    assign  mem_wena_o  = mem_wena_i    ;
    assign  mem_waddr_o = mem_waddr_i   ;
    assign  mem_wdata_o = mem_wdata_i   ;

endmodule