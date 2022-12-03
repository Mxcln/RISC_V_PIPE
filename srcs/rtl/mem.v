
`include "../define.v"

module  mem(
    input   wire                        arst_n  ,               //系统复位                  
    
    input   wire    [`INST]             INST_i     ,           //指令输入                  
    
    input   wire                        mem_rena_i  ,           //访存使能输入
    input   wire    [`MEM]              mem_rdata_i ,           //访存得到的数据输入               
    input   wire    [`MEM_ADDR]         mem_raddr_i ,           //访存地址输入              
    
    input   wire                        reg_wena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG]              reg_wdata_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR]         reg_waddr_i ,           //写入通用寄存器地址输入    
    
    input   wire                        mem_wena_i  ,           //写入使能输入              
    input   wire    [`MEM_ADDR]         mem_waddr_i ,           //写入的地址输入            
    input   wire    [`MEM]              mem_wdata_i ,           //写入的数据输入            
    
    output  wire    [`INST]             INST_o     ,           //指令输出

    output  wire                        mem_rena_o  ,           //访存使能输出
    output  wire    [`MEM]              mem_rdata_o ,           //访存得到的数据输出
    output  wire    [`MEM_ADDR]         mem_raddr_o ,           //访存地址输出

    output  wire                        reg_wena_o  ,           //写入通用寄存器的使能输出
    output  wire    [`REG]              reg_wdata_o ,           //写入通用寄存器数据输出        
    output  wire    [`REG_ADDR]         reg_waddr_o ,           //写入通用寄存器地址输出  

    output  wire                        mem_wena_o  ,           //写入使能输出              
    output  wire    [`MEM_ADDR]         mem_waddr_o ,           //写入的地址输出            
    output  wire    [`MEM]              mem_wdata_o             //写入的数据输出            
);               

    reg     [`MEM_ADDR]   mem_rdata;

    wire    [31:25]     imm;            //12位立即数
    wire    [24:20]     rs1;            //rs1储存需要数据的地址（加上立即数）
    wire    [14:12]     funct3;         //决定访存指令类型
    wire    [11:7]      rd;             //读入访存数据
    wire    [6:0]       opcode;         //判断是否为I型指令

    assign {imm,rs1,funct3,rd,opcode} = INST_i;

    always@(*) begin
        if(arst_n != `RST_ENABLE && mem_rena_i == `READ_ENABLE) begin
            mem_rdata <= mem_rdata_i;
        end
    end

    assign  INST_o      = INST_i       ;

    assign  mem_rena_o  = mem_rena_i    ;
    assign  mem_rdata_o = mem_rdata     ;
    assign  mem_raddr_o = mem_raddr_i   ;

    assign  reg_wena_o  = reg_wena_i    ;
    assign  reg_wdata_o = reg_wdata_i   ;
    assign  reg_waddr_o = reg_waddr_i   ;

    assign  mem_wena_o  = mem_wena_i    ;
    assign  mem_waddr_o = mem_waddr_i   ;
    assign  mem_wdata_o = mem_wdata_i   ;

endmodule