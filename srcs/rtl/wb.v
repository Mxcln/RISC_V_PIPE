`include "define.v"

module wb(
    input   wire                        arst_n      ,           //系统复位

    input   wire    [`INST]             inst_i     ,           //指令输入

    input   wire                        mem_r_ena_i  ,           //访存使能输入
    input   wire    [`MEM]              mem_r_data_i ,           //访存得到的数据输入               
    input   wire    [`MEM_ADDR]         mem_r_addr_i ,           //访存地址输入          
    
    input   wire                        reg_w_ena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG]              reg_w_data_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR]         reg_w_addr_i ,           //写入通用寄存器地址输入    
    
    input   wire                        mem_w_ena_i  ,           //写入使能输入              
    input   wire    [`MEM_ADDR]         mem_w_addr_i ,           //写入的地址输入            
    input   wire    [`MEM]              mem_w_data_i ,           //写入的数据输入 

    output  wire                        reg_w_ena_o  ,           //写入通用寄存器的使能输出
    output  reg     [`REG]              reg_w_data_o ,           //写入通用寄存器数据输出        
    output  reg     [`REG_ADDR]         reg_w_addr_o ,           //写入通用寄存器地址输出  

    output  wire                        mem_w_ena_o  ,           //写入使能输出              
    output  reg     [`MEM_ADDR]         mem_w_addr_o ,           //写入的地址输出            
    output  reg     [`MEM]              mem_w_data_o             //写入的数据输出        
);

    wire    [11:0]      l_imm   ;           //访存的12位立即数
    wire    [11:0]      s_imm   ;           //写回的12位立即数
    wire    [4:0]       rs1     ;           //rs1储存需要数据的地址（加上立即数）
    wire    [2:0]       funct3  ;           //决定访存指令类型
    wire    [4:0]       rd      ;           //读入访存数据
    wire    [6:0]       opcode  ;           //判断是否为I型指令

    assign {l_imm,rs1,funct3,rd,opcode} = inst_i;
    assign s_imm = {inst_i[31:25],inst_i[11:7]};

    //写通用寄存器

    assign reg_w_ena_o = reg_w_ena_i;

    //写通用寄存器的地址
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            reg_w_addr_o = `ZERO_WORD ;
        end
        else if(reg_w_ena_i | mem_r_ena_i) begin
            reg_w_addr_o = reg_w_addr_i ;
        end
        else begin
            reg_w_addr_o = `ZERO_WORD ;
        end
    end

    //写通用寄存器的数据
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            reg_w_data_o = `ZERO_WORD ;
        end

        //是L型指令：根据funct3决定写入的数据
        else if(reg_w_ena_i && mem_r_ena_i) begin
            case(funct3)
                `INST_LB : begin
                    case(mem_r_addr_i[1:0])
                        2'b00 : reg_w_data_o = {{24{mem_r_data_i[7]}}, mem_r_data_i[7:0]}      ;
                        2'b01 : reg_w_data_o = {{24{mem_r_data_i[15]}}, mem_r_data_i[15:8]}    ;
                        2'b10 : reg_w_data_o = {{24{mem_r_data_i[23]}}, mem_r_data_i[23:16]}   ;
                        2'b11 : reg_w_data_o = {{24{mem_r_data_i[31]}}, mem_r_data_i[31:24]}   ;
                    endcase
                end
                `INST_LH : begin
                    case(mem_r_addr_i[1])
                        1'b0 : reg_w_data_o = {{16{mem_r_data_i[15]}}, mem_r_data_i[15:0]}     ;
                        1'b1 : reg_w_data_o = {{16{mem_r_data_i[31]}}, mem_r_data_i[31:16]}    ;
                    endcase
                end
                `INST_LW : begin
                    reg_w_data_o = mem_r_data_i   ;
                end
                `INST_LBU : begin
                    case(mem_r_addr_i[1:0])
                        2'b00 : reg_w_data_o = {24'h0, mem_r_data_i[7:0]}     ;
                        2'b01 : reg_w_data_o = {24'h0, mem_r_data_i[15:8]}    ;
                        2'b10 : reg_w_data_o = {24'h0, mem_r_data_i[23:16]}   ;
                        2'b11 : reg_w_data_o = {24'h0, mem_r_data_i[31:24]}   ;
                    endcase
                end
                `INST_LHU : begin
                    case(mem_r_addr_i[1])
                        1'b0 : reg_w_data_o = {16'h0, mem_r_data_i[15:0]}     ;
                        1'b1 : reg_w_data_o = {16'h0, mem_r_data_i[31:16]}    ;
                    endcase
                end
                default : begin
                    reg_w_data_o = `ZERO_WORD;
                end
            endcase
        end
        
        //不是L型指令的情况，将ex输入的结果写入通用寄存器
        else if(reg_w_ena_i) begin
            reg_w_data_o = reg_w_data_i ;
        end

        else begin
            reg_w_data_o = `ZERO_WORD ;
        end
    end

    //写入RAM

    assign mem_w_ena_o = mem_w_ena_i;

    //写RAM的地址
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            mem_w_addr_o = `ZERO_WORD ;
        end
        else if(mem_w_ena_i) begin
            mem_w_addr_o = mem_w_addr_i ;
        end
        else begin
            mem_w_addr_o = `ZERO_WORD ;
        end
    end

    //写RAM的数据
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            mem_w_data_o = `ZERO_WORD ;
        end

        //根据funct3决定写入的数据
        else if(mem_w_ena_i) begin
            case(funct3)
                `INST_SB : begin
                    case(mem_r_addr_i[1:0])
                        2'b00 : mem_w_data_o = {mem_r_data_i[31:8], mem_w_data_i[7:0]}                     ;
                        2'b01 : mem_w_data_o = {mem_r_data_i[31:16], mem_w_data_i[7:0], mem_r_data_i[7:0]}  ;
                        2'b10 : mem_w_data_o = {mem_r_data_i[31:24], mem_w_data_i[7:0], mem_r_data_i[15:0]} ;
                        2'b11 : mem_w_data_o = {mem_w_data_i[7:0], mem_r_data_i[23:0]}                     ;
                    endcase
                end
                `INST_SH : begin
                    case(mem_r_addr_i[1:0])
                        2'b00   : mem_w_data_o = {mem_r_data_i[31:16], mem_w_data_i[15:0]}    ;
                        default : mem_w_data_o = {mem_w_data_i[15:0], mem_r_data_i[15:0]}     ;
                    endcase
                end
                `INST_SW : begin
                    mem_w_data_o = mem_w_data_i   ;
                end
                default : begin
                    mem_w_data_o = `ZERO_WORD;
                end
            endcase
        end

        else begin
            mem_w_data_o = `ZERO_WORD ;
        end
    end



endmodule

