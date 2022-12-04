

//inst
`define INST 31:0
`define INST_ADDR 31:0
`define ZERO_INST 32'b0
`define ZERO_INST_ADDR 32'b0
//cpureset 
`define CPU_RESET_ADDR 32'b0

// ENA
`define RST_ENABLE 1'b0
`define HOLD_ENABLE 1'b1
`define JUMP_ENABLE 1'b1
`define WRITE_ENABLE 1'b1
`define WRITE_DISABLE 1'b1
`define READ_ENABLE 1'b1
`define READ_DISABLE 1'b0
//reg
`define REG_NUM 0:31
`define REG 31:0
`define REG_ADDR 4:0
`define ZERO_REG 5'h0
//op op_jump
`define MEM_ADDR 31:0   //操作数的位数
`define ZERO_WORD 32'b0 //操作数的值
// R  type inst
`define INST_TYPE_R 7'b0110011

`define INST_ADD_SUB 3'b000
`define INST_SLL    3'b001
`define INST_SLT    3'b010
`define INST_SLTU   3'b011
`define INST_XOR    3'b100
`define INST_SR     3'b101
`define INST_OR     3'b110
`define INST_AND    3'b111
// I type inst
`define INST_TYPE_I_1 7'b0010011

`define INST_ADDI   3'b000
`define INST_SLTI   3'b010
`define INST_SLTIU  3'b011
`define INST_XORI   3'b100
`define INST_ORI    3'b110
`define INST_ANDI   3'b111
`define INST_SLLI   3'b001
`define INST_SRI    3'b101

`define INST_TYPE_I_2 7'b0000011

`define INST_LB     3'b000
`define INST_LH     3'b001
`define INST_LW     3'b010
`define INST_LBU    3'b100
`define INST_LHU    3'b101
// S type inst
`define INST_TYPE_S 7'b0100011

`define INST_SB     3'b000
`define INST_SH     3'b001
`define INST_SW     3'b010
// B type inst
`define INST_TYPE_B 7'b1100011

`define INST_BEQ    3'b000
`define INST_BNE    3'b001
`define INST_BLT    3'b100
`define INST_BGE    3'b101
`define INST_BLTU   3'b110
`define INST_BGEU   3'b111
// JAL JALR LUI AUIPC
`define INST_JAL    7'b1101111
`define INST_JALR   7'b1100111

`define INST_LUI    7'b0110111
`define INST_AUIPC  7'b0010111
