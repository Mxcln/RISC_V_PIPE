`include "define.v"
module ex(
    input   wire                    arst_n,         //异步复位信号

    //from  id                                      //来自译码信号
    input   wire    [`INST]         inst_b,          //前一个信号，用于判断冒险
    input   wire    [`REG_ADDR]     reg_b,            //前一个信号的地址
    input   wire    [`INST]         inst_i,         //接受信号的内容         
    input   wire    [`INST_ADDR]    inst_addr_i,    //接受信号的地址
    input   wire                    reg_w_ena_i,    //写寄存器使能信号
    input   wire    [`REG_ADDR]     reg_w_addr_i,   //写通用寄存器的地址
    input   wire    [`REG]          reg1_r_data_i,   //通用寄存器1的输入数据     
    input   wire    [`REG]          reg2_r_data_i,   //通用寄存器2的输入数据
    input   wire    [`REG_ADDR]     reg1_r_addr_i,   //通用寄存器1的输入数据     
    input   wire    [`REG_ADDR]     reg2_r_addr_i,   //通用寄存器2的输入数据     
    input   wire                    mem_r_ena_i ,
    input   wire                    mem_w_ena_i ,

    input   wire                    forwardC_i,

    //from  div
    input   wire    [`REG]          result_i,       //除法的结果
    input   wire                    ready_i,        //除法是否完成

    //to    mem                                     //向访存模块发出指令
    output  wire                    mem_r_ena_o   ,   //需要访问mem读取数据的信号
    output  reg     [`MEM_ADDR]     mem_r_addr_o,    //需要读取的信号地址
    output  reg      [`REG_ADDR]     reg_w_addr_o,    //需要写回的寄存器地址
    output  wire    [`INST]         inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  wire                     reg_w_ena_o,    //将写寄存器的使能信号
    output  reg      [`INST]         reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    output  wire                     forwardC_o,
    //to    ctrl
 
    output  reg                      jump_flag_o,    //是否跳转
    output  reg      [`INST_ADDR]    jump_addr_o,     //跳转的位置;  
    output  reg                      div_hold_o   ,     //除法需要的暂停

    //to    wb
    output  reg     [`MEM_ADDR]     mem_w_addr_o,    //需要写的地址                                  
    output  reg      [`REG]          mem_w_data_o,    //需要写回的寄存器数据
    output  wire                    mem_w_ena_o,       //需要写回的使能信号


    //to div 
    output  reg                 start_o,
    output  reg     [`REG]      dividend_o,
    output  reg     [`REG]      divisor_o,
    output  reg     [2:0]       div_func_o
    
);

reg    [`REG]          op1;          //数据操作数1
reg    [`REG]          op2;          //数据操作数2
reg    [`MEM_ADDR]     op1_jump;     //跳转操作的地址操作数1        
reg    [`MEM_ADDR]     op2_jump;     //跳转操作的地址操作数2

wire    [6:0]   opcode ;                          //指令段
wire    [2:0]   funct3 ;                          //三位函数段，确定哪一种大的函数
wire    [6:0]   funct7 ;                          //七位函数段，确定哪一种确定函数
wire    [4:0]   rd     ;                          //目的寄存器的地址
wire    [`REG]  op1_add_op2_res;                  //操作数相加的结果
wire    [`REG]  op1_ge_op2_signed;                //操作数带符号的比大小
wire    [`REG]  op1_ge_op2_unsigned;              //操作数不带符号的比大小
wire    [`REG]  sri_shift_mask;                   //将32‘hfffffff右移imm[24:20]
wire    [`REG]  sri_shift;                        //将rs1右移imm[24:20]                               
wire    [`REG]  sr_shift_mask;                   //将32‘hfffffff右移reg2[4:0]位
wire    [`REG]  sr_shift;                        //将rs1右移reg2[4:0]位                               
wire    [`INST_ADDR]  op1_jump_add_op2_jump_res; //跳转的地址之和   
wire    [`REG]  reg1_r_data_com;                 //reg1的补码
wire    [`REG]  reg2_r_data_com;                 //reg2的补码   
reg    [`DOUBLE_REG]   mul_temp;                //乘法的结果，由于两个32位相乘结果为64位，所以用DOUBLE_REG

reg                    div_w_ena;               //表明除法结束，可以进行写操作      

assign opcode = inst_i[6:0];
assign funct3 = inst_i[14:12];
assign funct7 = inst_i[31:25];
assign rd     = inst_i[11:7];
assign op1_add_op2_res = op1 + op2 ;
//有符号数的比较
assign op1_ge_op2_signed = $signed(op1) < $signed(op2) ;
//无符号数的比较
assign op1_ge_op2_unsigned = op1 < op2 ;

assign sri_shift_mask = 32'hffffffff >> inst_i[24:20];
assign sri_shift = reg1_r_data_i >> inst_i[24:20];
assign sr_shift_mask = 32'hffffffff >> reg2_r_data_i[4:0];
assign sr_shift = reg1_r_data_i >> reg2_r_data_i[4:0];
assign op1_jump_add_op2_jump_res = op1_jump + op2_jump ;    //跳转的目的地址
//将reg1与reg2取补码
assign reg1_r_data_com = ~reg1_r_data_i + 1 ;
assign reg2_r_data_com = ~reg2_r_data_i + 1 ;

assign  mem_r_ena_o = mem_r_ena_i;
assign  mem_w_ena_o = mem_w_ena_i;

assign  forwardC_o = forwardC_i;
assign  inst_o = inst_i;
assign  reg_w_ena_o = reg_w_ena_i || div_w_ena ;

always@(*)begin
   
    reg_w_addr_o = reg_w_addr_i ;
    op1 = `ZERO_WORD;
    op2 = `ZERO_WORD;
    op1_jump = `ZERO_WORD;
    op2_jump = `ZERO_WORD;
    div_w_ena = `DIV_DISABLE ;

    case(opcode)
    `INST_TYPE_I_1:begin
        op1 = reg1_r_data_i;
        op2 = {{20{inst_i[31]}}, inst_i[31:20]};
        case(funct3)
            `INST_ADDI:begin 
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = op1_add_op2_res;
            end
            `INST_SLTI: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = {32{(op1_ge_op2_signed)}} & 32'h1;
            end
            `INST_SLTIU: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = {32{(op1_ge_op2_unsigned)}} & 32'h1;
            end    
            `INST_XORI: begin
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = op1 ^ op2;
            end
            `INST_ORI: begin
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = op1 | op2;
            end
            `INST_ANDI: begin
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = op1 & op2;
            end
            `INST_SLLI: begin   //低位补零左移
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = reg1_r_data_i << inst_i[24:20] ;
            end
            `INST_SRI: begin    
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    if(inst_i[30] == 1'b1 )begin //高位补符号位右移
                    reg_w_data_o = sri_shift | ( {32{reg1_r_data_i[31]}} & ~sri_shift_mask ) ;
                end
                    else                         //高位补0右移   
                    reg_w_data_o = sri_shift ;
            end
            default: begin
                        jump_flag_o = `JUMP_DISABLE;
                        jump_addr_o = `ZERO_WORD;
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                    end
            
        endcase
    end

    `INST_TYPE_R:begin
        if( funct7 == 7'b0000001)           //对于乘法运算有误符号位操作数取得不一样，需要单独处理 
        begin
            case (funct3)
                `INST_MULU:begin
                    op1 = reg1_r_data_i ;
                    op2 = reg2_r_data_i ;
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    mul_temp = op1 * op2;
                    reg_w_data_o = mul_temp[31:0];     //只取最低32位                      
                end
                `INST_MUL:begin
                    op1 = (reg1_r_data_i[31] == 1'b1)?reg1_r_data_com:reg1_r_data_i;
                    op2 = (reg2_r_data_i[31] == 1'b1)?reg2_r_data_com:reg2_r_data_i;    //有符号数的乘法对操作数进行判断正负，如果是负的就取补码即绝对值
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    if (reg1_r_data_i[31] ^ reg2_r_data_i[31])
                    begin                                                              //异号相乘为负数，所以将得到的结果取补码，并且将符号位置为1 
                        mul_temp = ~ (op1 * op2) + 1 ; 
                        reg_w_data_o = {1'b1,mul_temp[ 30:0 ]};
                    end 
                    else
                    begin             
                        mul_temp = op1 * op2 ;    
                        reg_w_data_o = mul_temp[ 31:0 ] ;
                    end     
                end
                `INST_DIV , `INST_DIVU:
                    begin
                    dividend_o = reg1_r_data_i ;
                    divisor_o =  reg2_r_data_i ;
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    div_func_o  = funct3        ;
                    reg_w_data_o = result_i   ;
                    if( ready_i == `DIV_DISABLE )begin
                        div_hold_o  = `DIV_ENABLE   ;
                        start_o   = `DIV_ENABLE   ;
                    end
                    else begin
                        div_hold_o  = `DIV_DISABLE   ;
                        start_o   = `DIV_DISABLE   ;
                        div_w_ena = `DIV_ENABLE    ;
                    end
                    end 
            endcase
        end
        else begin
        op1 = reg1_r_data_i;
        op2 = reg2_r_data_i;
        case(funct3)
        `INST_ADD_SUB:begin
            jump_flag_o = `JUMP_DISABLE;
            jump_addr_o = `ZERO_WORD;
            mem_w_data_o = `ZERO_WORD;
            mem_r_addr_o = `ZERO_WORD;
            mem_w_addr_o = `ZERO_WORD;
            if (inst_i[30] == 1'b0) begin
                reg_w_data_o = op1_add_op2_res;
            end else begin
                reg_w_data_o = op1 - op2;
                end
        end
        `INST_SLL: begin
            jump_flag_o = `JUMP_DISABLE;
            jump_addr_o = `ZERO_WORD;
            mem_w_data_o = `ZERO_WORD;
            mem_r_addr_o = `ZERO_WORD;
            mem_w_addr_o = `ZERO_WORD;
            reg_w_data_o = op1 << op2[4:0];
        end
        `INST_SLT: begin
            jump_flag_o = `JUMP_DISABLE;
            jump_addr_o = `ZERO_WORD;
            mem_w_data_o = `ZERO_WORD;
            mem_r_addr_o = `ZERO_WORD;
            mem_w_addr_o = `ZERO_WORD;
            reg_w_data_o = {32{(op1_ge_op2_signed)}} & 32'h1;
        end
        `INST_SLTU: begin
            jump_flag_o = `JUMP_DISABLE;
            jump_addr_o = `ZERO_WORD;
            mem_w_data_o = `ZERO_WORD;
            mem_r_addr_o = `ZERO_WORD;
            mem_w_addr_o = `ZERO_WORD;
            reg_w_data_o = {32{(op1_ge_op2_unsigned)}} & 32'h1;
        end
        `INST_XOR: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = op1 ^ op2;
            end
        `INST_SR: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                if (inst_i[30] == 1'b1) begin
                        reg_w_data_o = sr_shift | ({32{reg1_r_data_i[31]}} & (~sr_shift_mask));
                end else begin
                        reg_w_data_o = sr_shift ;
                        end
                end
        `INST_OR: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = op1 | op2;
                end
        `INST_AND: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = op1 & op2;
                end
        default: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = `ZERO_WORD;
                end                   
        endcase
    end
    end
    `INST_TYPE_I_2 :begin               //访存指令
                op1 = reg1_r_data_i;
                op2 = {{20{inst_i[31]}}, inst_i[31:20]};
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                mem_r_addr_o = op1_add_op2_res;
                reg_w_data_o = `ZERO_WORD;
    end                             
    `INST_TYPE_S:begin                  //写回指令
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                reg_w_data_o = `ZERO_WORD;
                //mem_w_data_o =`ZERO_WORD;
                mem_w_addr_o = op1_add_op2_res;
                mem_r_addr_o = op1_add_op2_res;    
                mem_w_data_o = reg2_r_data_i; 
                op1 = reg1_r_data_i;
                op2 = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};      
    end
    `INST_TYPE_B:begin                  //条件跳转指令
        op1 = reg1_r_data_i;
        op2 = reg2_r_data_i;
        op1_jump = inst_addr_i;
        op2_jump = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
        case(funct3)
             `INST_BEQ: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1 == op2 ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BNE: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1 != op2 ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BGE: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = !op1_ge_op2_signed ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BLT: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1_ge_op2_signed ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BGEU: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = !op1_ge_op2_unsigned ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BLTU: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1_ge_op2_unsigned ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            default: begin
                        jump_flag_o = `JUMP_DISABLE;
                        jump_addr_o = `ZERO_WORD;
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                    end                        
        endcase
        
    end  
    `INST_JAL:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_ENABLE;
        jump_addr_o = op1_jump_add_op2_jump_res;
        reg_w_data_o = op1_add_op2_res;
        op1 = inst_addr_i;
        op2 = 32'h4;
        op1_jump = inst_addr_i;
        op2_jump = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
    end
    `INST_JALR:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_ENABLE;
        jump_addr_o = op1_jump_add_op2_jump_res;
        reg_w_data_o = op1_add_op2_res;
        op1 = inst_addr_i;
        op2 = 32'h4;
        op1_jump = reg1_r_data_i;
        op2_jump = {{20{inst_i[31]}}, inst_i[31:20]};    
    end
    `INST_LUI:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_DISABLE;
        reg_w_data_o = op1_add_op2_res;
        op1 = {inst_i[31:12], 12'b0};
        op2 = `ZERO_WORD;
    end
    `INST_AUIPC:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_DISABLE;
        reg_w_data_o = op1_add_op2_res;
        op1 = inst_addr_i;
        op2 = {inst_i[31:12], 12'b0};
    end
    default:
    begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = `ZERO_WORD;
    end
    endcase
end


endmodule