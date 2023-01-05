//I_1指令
0000_0000_1001_00001_000_00001_0010011      //ADDI:将reg[1]加9（1001） 
0000_0000_0101_00001_100_00010_0010011      //XORI:将reg[1]（1001）与0101做异或运算存入reg[2]，结果应为1100（c)
0000_0000_0011_00001_110_00011_0010011      //ORI:将reg[1](1001)与(0011)做或运算存入reg[3]，结果应为1011（b）
0000_0000_0011_00001_111_00100_0010011      //ANDI:将reg[1](1001)与（0011）做与运算存入reg[4]，结果为0001（1）     //
0000_0000_0011_00001_001_00001_0010011      //SLLI:将reg[1](1001)逻辑左移3位存入reg[1]，结果为100_1000(8'h48)      
0000_0000_0011_00001_101_00001_0010011      //SRLI:将reg[1](100_1000)逻辑右移3位存入reg[1],结果为1001（9）
1111_1110_1110_00001_000_00001_0010011      //ADDI:将reg[1]加上-11001,即得到-reg[1],存入reg[1](-1001)
0100_0000_0011_00001_101_00110_0010011      //SRAI:将reg[1]数字右移3位，带符号位存入reg[6]
0000_0000_1101_00010_010_00111_0010011      //SLTI:将reg[2]（1100）与立即数1101比较，小于则返回1存入reg[7]（返回1）。
0000_0000_1101_00010_011_01000_0010011      //SLTI:将reg[2]（1100）与立即数1101比较，大于则返回1存入reg[8]（返回0）。

//R指令
0000001_00011_00010_000_10000_0110011       //MUL将reg[2](c)乘以reg[3](b)结果存入reg[16](8‘h84)
0000001_00001_00010_001_10001_0110011       //将reg[1](-9)乘以reg[2](c)结果存入reg[17](-8'h94,即32'hffff_ff94)
1111_1110_1000_00010_000_00010_0010011      //将reg[2](c)减去2倍的c，得到-reg[2],并存入reg[2]
0000001_00001_00010_001_10001_0110011       //将reg[2](-c)与reg[1](-9)有符号相乘，得到结果(8'h6c)

//S指令
0000000_00001_00010_000_00001_0100011       //SB：将reg[1]（fffff848）的值后8位写入ram[11+00]的后15-8位，即0000_4800
0000000_00001_00010_001_00110_0100011       //SH：将reg[1]（fffff848）的值后16位写入ram[11+01]的前16位，即f848_0000
0000000_00001_00010_010_01010_0100011       //SW：将reg[1]（fffff848）的值写入ram[11+10]

//I_2指令
0000_0000_0001_00010_000_01001_0000011      //LB:将ram[11+0]的值的15-8位读入到reg[9]（左扩展1）（ffff_fff8）
0000_0000_0110_00010_001_01010_0000011      //LH:将ram[11+01]的值的前十六位读入到reg[10]（左扩展1）(ffff_ff48)
0000_0000_1010_00010_010_01011_0000011      //LW:将ram[11+10]的值的读入到reg[11]（左扩展1）(ffff_f848)
0000_0000_0001_00010_100_01100_0000011      //LBU:将ram[11+00]的值的15-8八位读入到reg[12]（左扩展0）(0000_0008)
0000_0000_1010_00010_101_01101_0000011      //LHU:将ram[11+10]的值的前十六位读入到reg[13]（左扩展0）(0000_0048)

//B指令
0000_0000_0001_00011_000_00011_0010011      //将reg[3]+1==reg[2]
0000000_00011_00010_000_01000_1100011       //BEQ:reg[3]==reg[2] ,PC+8,跳过下一条指令
0000_0000_0001_00011_000_00011_0010011      //reg[3]+1，验证是否跳过
0000_0000_0001_00011_000_00011_0010011      //reg[3]+1!=reg[2]
0000000_00011_00010_001_01000_1100011       //BNE:reg[3]!=reg[2]，跳过下一条
0000_0000_0001_00011_000_00011_0010011      //验证
0000000_00010_00100_100_01000_1100011       //BLT:比较reg[4]<reg[2],跳过下一条
0000_0000_0001_00011_000_00011_0010011      //验证
0000000_00100_00010_101_01000_1100011       //BGE:比较reg[2]>reg[4],跳过下一条
0000_0000_0001_00011_000_00011_0010011      //验证

//J指令
0_0000000100_0_00000000_01110_1100111       //JAR:跳转PC+8，将下一条指令的地址存到reg[14]
0000_0000_0001_00011_000_00011_0010011      //验证
0000_0000_0000_00010_000_01111_1100111      //JALR：跳转PC+reg[2](12)+0，跳过三条指令，下一条指令存到reg[15]
0000_0000_0001_00011_000_00011_0010011      //验证
0000_0000_0001_00011_000_00011_0010011  
0000_0000_0001_00011_000_00011_0010011  

//LUI
0000_0000_0000_0000_0001_01110_0110111      //LUI:1左移12位存入reg[14]
0000_0000_0000_0000_0001_01111_0010111      //AUIPC:1左移12位加上pc存入reg[15]