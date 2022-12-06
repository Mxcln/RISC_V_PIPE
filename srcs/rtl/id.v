`include "define.v"



`define INST_TYPE_I_1 7'b0010011
`define INST_TYPE_I_2 7'b0000011
//译码电路，纯组合逻辑
module id (
    //from if_id
    input wire [`INST]          inst_i,             //指令内容
    input wire [`INST_ADDR]     inst_addr_i,        //指令地址
    //from regs
    input wire [`REG]           reg1_r_data_i,      //读寄存器1数据
    input wire [`REG]           reg2_r_data_i,      //读寄存器2数据
    //from ex
    input wire                  ex_jump_ena_i,      //ex跳转指令
    //to regs & ex
    output reg [`REG_ADDR]      reg1_r_addr_o,     // 读通用寄存器1地址
    output reg [`REG_ADDR]      reg2_r_addr_o,     // 读通用寄存器2地址
    //to ex
    output reg [`INST]          inst_o,            // 指令内容
    output reg [`INST_ADDR]     inst_addr_o,       // 指令地址
    
    output reg [`REG]           reg1_r_data_o,     // 通用寄存器1数据
    output reg [`REG]           reg2_r_data_o,     // 通用寄存器2数据
    output reg                  reg_w_ena_o,       // 写通用寄存器标志
    output reg [`REG_ADDR]      reg_w_addr_o,      // 写通用寄存器地址
    output  reg                 mem_w_ena_o,       //需要写回的使能信号
    output  reg                 mem_r_ena_o        //需要访问Ram读取数据的信号

);
    wire [6:0] opcode = inst_i[6:0];
    wire [2:0] funct3 = inst_i[14:12];
    wire [6:0] funct7 = inst_i[31:25];
    wire [4:0] rd = inst_i[11:7];
    wire [4:0] rs1 = inst_i[19:15];
    wire [4:0] rs2 = inst_i[24:20];
    always @(*) begin
        inst_o = inst_i;            //
        inst_addr_o = inst_addr_i;

        reg1_r_data_o = reg1_r_data_i;
        reg2_r_data_o = reg2_r_data_i;

        reg_w_ena_o = `WRITE_DISABLE;
        mem_w_ena_o = `WRITE_DISABLE;
        mem_r_ena_o = `WRITE_DISABLE;

        case (opcode)
             `INST_TYPE_R: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3)
                        `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                            reg_w_ena_o = `WRITE_ENABLE;
                            mem_w_ena_o = `WRITE_DISABLE;
                            mem_r_ena_o = `READ_DISABLE ;
                            reg_w_addr_o = rd;
                            reg1_r_addr_o = rs1;
                            reg2_r_addr_o = rs2;
                        end
                        //如果 不属于这些 则指令出错，执行空指令
                        // reg_addr =32'b0 的位置应该是不存数据的？
                        default: begin
                            reg_w_addr_o = `ZERO_REG;
                            reg1_r_addr_o = `ZERO_REG;
                            reg2_r_addr_o = `ZERO_REG;
                        end
                    endcase
                end 
                else begin
                    reg_w_addr_o = `ZERO_REG;
                    reg1_r_addr_o = `ZERO_REG;
                    reg2_r_addr_o = `ZERO_REG;
                end
             end
             `INST_TYPE_I_1:begin
                 case (funct3)
                    `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI, `INST_SLLI, `INST_SRI: begin
                        reg_w_ena_o = `WRITE_ENABLE;
                        mem_r_ena_o = `READ_DISABLE ;
                        mem_w_ena_o = `WRITE_DISABLE;
                        reg_w_addr_o = rd;
                        reg1_r_addr_o = rs1;
                        reg2_r_addr_o = `ZERO_REG;
                        //op2_o 将立即数扩展为32位指令
                    end
                    default: begin
                        reg_w_addr_o = `ZERO_REG;
                        reg1_r_addr_o = `ZERO_REG;
                        reg2_r_addr_o = `ZERO_REG;
                    end
                endcase
             end
             `INST_TYPE_I_2:begin
                case (funct3)
                    `INST_LB,`INST_LH,`INST_LW,`INST_LBU,`INST_LHU:begin
                        reg_w_ena_o = `WRITE_ENABLE;
                        mem_w_ena_o = `WRITE_DISABLE;
                        mem_r_ena_o = `READ_ENABLE;
                        reg_w_addr_o = rd;
                        reg1_r_addr_o = rs1;
                        reg2_r_addr_o = `ZERO_REG;
                    end
                    default: begin
                        reg_w_addr_o = `ZERO_REG;
                        reg1_r_addr_o = `ZERO_REG;
                        reg2_r_addr_o = `ZERO_REG;
                    end
                endcase
             end
             `INST_TYPE_S:begin
                case (funct3)
                    `INST_SB, `INST_SW, `INST_SH:begin
                        reg_w_ena_o = `WRITE_DISABLE;
                        mem_w_ena_o = `WRITE_ENABLE;
                        mem_r_ena_o = `READ_ENABLE;
                        reg_w_addr_o=`ZERO_REG;
                        reg1_r_addr_o = rs1;
                        reg2_r_addr_o = rs2;    //可以写reg2_r_addr_o = `ZERO_REG ;
                    end
                    default: begin
                        reg_w_addr_o = `ZERO_REG;
                        reg1_r_addr_o = `ZERO_REG;
                        reg2_r_addr_o = `ZERO_REG;
                    end
                endcase
             end
            `INST_TYPE_B:begin
                case (funct3)
                    `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
                        reg1_r_addr_o = rs1;
                        reg2_r_addr_o = rs2;
                        reg_w_ena_o = `WRITE_DISABLE;
                        mem_w_ena_o = `WRITE_DISABLE;
                        mem_r_ena_o = `READ_DISABLE;
                        reg_w_addr_o = `ZERO_REG;
                        //认为立即数imm最高位位0？
                    end
                    default: begin
                        reg1_r_addr_o = `ZERO_REG;
                        reg2_r_addr_o = `ZERO_REG;
                        reg_w_addr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_JAL: begin
                reg_w_ena_o = `WRITE_ENABLE;
                mem_w_ena_o = `WRITE_DISABLE;
                mem_r_ena_o = `READ_DISABLE;
                reg_w_addr_o = rd;
                reg1_r_addr_o = `ZERO_REG;
                reg2_r_addr_o = `ZERO_REG;
                //认为imm立即数的最高位为0，J型指令
            end
            `INST_JALR: begin
                reg_w_ena_o = `WRITE_ENABLE;
                mem_w_ena_o = `WRITE_DISABLE;
                mem_r_ena_o = `READ_DISABLE;
                reg_w_addr_o = rd;
                reg1_r_addr_o = rs1;
                reg2_r_addr_o = `ZERO_REG;
            end
            `INST_LUI: begin
                reg_w_ena_o = `WRITE_ENABLE;
                mem_w_ena_o = `WRITE_DISABLE;
                mem_r_ena_o = `READ_DISABLE;
                reg_w_addr_o = rd;
                reg1_r_addr_o = `ZERO_REG;
                reg2_r_addr_o = `ZERO_REG;
            end
            `INST_AUIPC: begin
                reg_w_ena_o = `WRITE_ENABLE;
                mem_w_ena_o = `WRITE_DISABLE;
                mem_r_ena_o = `READ_DISABLE;
                reg_w_addr_o = rd;
                reg1_r_addr_o = `ZERO_REG;
                reg2_r_addr_o = `ZERO_REG;
            end
            default: begin
                        reg1_r_addr_o = `ZERO_REG;
                        reg2_r_addr_o = `ZERO_REG;
                        reg_w_addr_o = `ZERO_REG;
            end
        endcase


    end
  
endmodule