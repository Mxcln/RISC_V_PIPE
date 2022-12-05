`include "define.v"

module ex(
    input   wire                    arst_n,         //异步复位信号

    //from  id                                      //来自译码信号
    input   wire    [`INST]         inst_i,         //接受信号的内容         
    input   wire    [`INST_ADDR]    inst_addr_i,    //接受信号的地址
    input   wire                    reg_w_ena_i,    //写寄存器使能信号
    input   wire    [`REG_ADDR]     reg_w_addr_i,   //写通用寄存器的地址
    input   wire    [`REG]          reg1_r_data_i,   //通用寄存器1的输入数据     
    input   wire    [`REG]          reg2_r_data_i,   //通用寄存器2的输入数据
    input   wire    [`REG]          op1_i,          //数据操作数1
    input   wire    [`REG]          op2_i,          //数据操作数2
    input   wire    [`MEM_ADDR]     op1_jump_i,     //跳转操作的地址操作数1        
    input   wire    [`MEM_ADDR]     op2_jump_i,     //跳转操作的地址操作数2

    input   wire                    mem_r_ena_i ,
    input   wire                    mem_w_ena_i ,

    input   wire                    forwardC_i,

    //to    mem                                     //向访存模块发出指令
    output  wire                    mem_r_ena_o   ,   //需要访问mem读取数据的信号
    output  reg     [`MEM_ADDR]     mem_r_addr_o,    //需要读取的信号地址
    output  reg     [`REG_ADDR]     reg_w_addr_o,    //需要写回的寄存器地址
    output  reg     [`INST]         inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  reg                     reg_w_ena_o,    //将写寄存器的使能信号
    output  reg     [`INST]         reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    output  wire                     forwardC_o,
    //to    ctrl
 
    output  reg                     jump_flag_o,    //是否跳转
    output  reg     [`INST_ADDR]    jump_addr_o,     //跳转的位置;  
    
    //to    wb
    output  reg     [`MEM_ADDR]     mem_w_addr_o,    //需要写的地址                                  
    output  reg     [`REG]          mem_w_data_o,    //需要写回的寄存器数据
    output  wire                    mem_w_ena_o       //需要写回的使能信号
);

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

assign opcode = inst_i[6:0];
assign funct3 = inst_i[14:12];
assign funct7 = inst_i[31:25];
assign rd     = inst_i[11:7];
assign op1_add_op2_res = op1_i + op2_i ;
assign op1_ge_op2_signed = $signed(op1_i) < $signed(op2_i) ;
assign op1_ge_op2_unsigned = op1_i < op2_i ;
assign sri_shift_mask = 32'hffffffff >> inst_i[24:20];
assign sri_shift = reg1_r_data_i >> inst_i[24:20];
assign sr_shift_mask = 32'hffffffff >> reg2_r_data_i[4:0];
assign sr_shift = reg1_r_data_i >> reg2_r_data_i[4:0];
assign op1_jump_add_op2_jump_res = op1_jump_i + op2_jump_i ;


assign  mem_r_ena_o = mem_r_ena_i;
assign  mem_w_ena_o = mem_w_ena_i;

assign  forwardC_o = forwardC_i;

always@(*)begin
    reg_w_ena_o = reg_w_ena_i ;
    reg_w_addr_o = reg_w_addr_i ;
    case(opcode)
    `INST_TYPE_I_1:begin
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
            `INST_SLTI: begin
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
                    reg_w_data_o = op1_i ^ op2_i;
            end
            `INST_ORI: begin
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = op1_i | op2_i;
            end
            `INST_ANDI: begin
                    jump_flag_o = `JUMP_DISABLE;
                    jump_addr_o = `ZERO_WORD;
                    mem_w_data_o = `ZERO_WORD;
                    mem_r_addr_o = `ZERO_WORD;
                    mem_w_addr_o = `ZERO_WORD;
                    reg_w_data_o = op1_i & op2_i;
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
                reg_w_data_o = op1_i - op2_i;
                end
        end
        `INST_SLL: begin
            jump_flag_o = `JUMP_DISABLE;
            jump_addr_o = `ZERO_WORD;
            mem_w_data_o = `ZERO_WORD;
            mem_r_addr_o = `ZERO_WORD;
            mem_w_addr_o = `ZERO_WORD;
            reg_w_data_o = op1_i << op2_i[4:0];
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
                reg_w_data_o = op1_i ^ op2_i;
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
                reg_w_data_o = op1_i | op2_i;
                end
        `INST_AND: begin
                jump_flag_o = `JUMP_DISABLE;
                jump_addr_o = `ZERO_WORD;
                mem_w_data_o = `ZERO_WORD;
                mem_r_addr_o = `ZERO_WORD;
                mem_w_addr_o = `ZERO_WORD;
                reg_w_data_o = op1_i & op2_i;
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
    `INST_TYPE_I_2 :begin               //访存指令
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
                reg_w_data_o = reg2_r_data_i;
                mem_w_addr_o = op1_add_op2_res;
                mem_r_addr_o = op1_add_op2_res;           
    end
    `INST_TYPE_B:begin                  //条件跳转指令
        case(funct3)
             `INST_BEQ: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1_i == op2_i ;
                        jump_addr_o = op1_jump_add_op2_jump_res;
                    end
            `INST_BEQ: begin
                        mem_w_data_o = `ZERO_WORD;
                        mem_r_addr_o = `ZERO_WORD;
                        mem_w_addr_o = `ZERO_WORD;
                        reg_w_data_o = `ZERO_WORD;
                        jump_flag_o = op1_i != op2_i ;
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
            `INST_BGEU: begin
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
    `INST_JAL,  `INST_JALR:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_ENABLE;
        jump_addr_o = op1_jump_add_op2_jump_res;
        reg_w_data_o = op1_add_op2_res;
    end
    `INST_LUI,`INST_AUIPC:begin
        mem_w_data_o = `ZERO_WORD;
        mem_r_addr_o = `ZERO_WORD;
        mem_w_addr_o = `ZERO_WORD;
        jump_addr_o = `ZERO_WORD;
        jump_flag_o = `JUMP_DISABLE;
        reg_w_data_o = op1_add_op2_res;
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