
`include "define.v"

module  mem(
    input   wire                        arst_n  ,               //系统复位                  
    
    input   wire    [`INST]             inst_i      ,           //指令输入                  
    
    input   wire                        mem_r_ena_i  ,           //访存使能输入
    input   wire    [`MEM]              mem_r_data_i ,           //访存得到的数据输入               
    input   wire    [`MEM_ADDR]         mem_r_addr_i ,           //访存地址输入              
    
    input   wire                        reg_w_ena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG]              reg_w_data_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR]         reg_w_addr_i ,           //写入通用寄存器地址输入    
    
    input   wire                        mem_w_ena_i  ,           //写入使能输入              
    input   wire    [`MEM_ADDR]         mem_w_addr_i ,           //写入的地址输入            
    input   wire    [`MEM]              mem_w_data_i ,           //写入的数据输入            
    
    output  wire    [`INST]             inst_o      ,           //指令输出

    output  wire                        mem_r_ena_o  ,           //访存使能输出
    output  wire    [`MEM]              mem_r_data_o ,           //访存得到的数据输出
    output  wire    [`MEM_ADDR]         mem_r_addr_o ,           //访存地址输出

    output  wire                        reg_w_ena_o  ,           //写入通用寄存器的使能输出
    output  wire    [`REG]              reg_w_data_o ,           //写入通用寄存器数据输出        
    output  wire    [`REG_ADDR]         reg_w_addr_o ,           //写入通用寄存器地址输出  

    output  wire                        mem_w_ena_o  ,           //写入使能输出              
    output  wire    [`MEM_ADDR]         mem_w_addr_o ,           //写入的地址输出            
    output  wire    [`MEM]              mem_w_data_o             //写入的数据输出            
);               

    reg     [`MEM_ADDR]   mem_r_data;

    wire    [31:25]     imm;            //12位立即数
    wire    [24:20]     rs1;            //rs1储存需要数据的地址（加上立即数）
    wire    [14:12]     funct3;         //决定访存指令类型
    wire    [11:7]      rd;             //读入访存数据
    wire    [6:0]       opcode;         //判断是否为I型指令

    assign {imm,rs1,funct3,rd,opcode} = inst_i;

    always@(*) begin
        if(arst_n != 1 && mem_r_ena_i == `READ_ENABLE) begin
            mem_r_data = mem_r_data_i;
        end
        else begin
            mem_r_data = `ZERO_WORD;
        end
    end

    assign  inst_o      = inst_i       ;

    assign  mem_r_ena_o  = mem_r_ena_i    ;
    assign  mem_r_data_o = mem_r_data     ;
    assign  mem_r_addr_o = mem_r_addr_i   ;

    assign  reg_w_ena_o  = reg_w_ena_i    ;
    assign  reg_w_data_o = reg_w_data_i   ;
    assign  reg_w_addr_o = reg_w_addr_i   ;

    assign  mem_w_ena_o  = mem_w_ena_i    ;
    assign  mem_w_addr_o = mem_w_addr_i   ;
    assign  mem_w_data_o = mem_w_data_i   ;

endmodule