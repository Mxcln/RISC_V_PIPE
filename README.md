# RISCV

这是一个支持RV32I指令的riscv cpu, 采用五级流水线结构：

取指 译码 执行 访存 回写

![alt 属性文本](/pic/structure.png "riscv cpu流水线结构")

系统采用流水线结构。通过流水线，cpu与外设（rom，ram）连接并能够访问。

指令集目前采用RV32I (除去ecall与ebreak指令)

![alt 属性文本](/pic/Instruction_Formats.png "RV32I指令结构")

![alt 属性文本](/pic/RV32I.png "RV32I指令集")

### 流水线模块

#### 指令计数 `pc.v`

| in/out | input/output | width | comments         |
| ------ | ------------ | ----- | ---------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟     |
| in     | arst_n       | 1     | 系统复位         |
| in     | jump_ena_i   | 1     | 跳转使能         |
| in     | jump_addr_i  | 32    | 跳转地址         |
| in     | hold_ena_i   | 3     | 暂停（清除）使能 |
| out    | pc_addr_ou   | 32    | 指令地址         |

#### 译码时序 `pc_id.v`

| in/out | input/output | width | comments       |
| ------ | ------------ | ----- | -------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟   |
| in     | arst_n       | 1     | 系统复位       |
| in     | inst_i       | 32    | 指令内容       |
| in     | inst_addr_i  | 32    | 指令地址       |
| in     | hold_flag_i  | 1     | 流水线暂停标志 |
| out    | inst_o       | 32    | 指令内容       |
| out    | inst_addr_o  | 32    | 指令地址       |


#### 译码 `id.v`

| in/out | input/output  | width | comments                |
| ------ | ------------- | ----- | ----------------------- |
| in     | inst_i        | 32    | 指令内容                |
| in     | inst_addr_i   | 32    | 指令地址                |
| in     | reg1_rdata_i  | 32    | 通用寄存器1要输入的数据 |
| in     | reg2_rdata_i  | 32    | 通用寄存器2要输入的数据 |
| in     | ex_jump_ena_i | 1     | ex跳转标志              |
| out    | inst_o        | 32    | 指令内容                |
| out    | inst_addr_o   | 32    | 指令地址                |
| out    | reg1_raddr_o  | 5     | 读通用寄存器1的地址     |
| out    | reg2_raddr_o  | 5     | 读通用寄存器2的地址     |
| out    | reg1_rdata_o  | 32    | 通用寄存器1的数据       |
| out    | reg2_rdata_o  | 32    | 通用寄存器2的数据       |
| out    | reg_we_o      | 1     | 写通用寄存器的标志      |
| out    | reg_waddr_o   | 5     | 写通用寄存器的地址      |
| out    | op1_o         | 32    | 操作数1                 |
| out    | op1_o         | 32    | 操作数2                 |
| out    | op1_jump_o    | 32    | 跳转操作数1             |
| out    | op1_jump_o    | 32    | 跳转操作数2             |


#### 执行时序 `id_ex`
| in/out | input/output | width | comments            |
| ------ | ------------ | ----- | ------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟        |
| in     | arst_n       | 1     | 系统复位            |
| in     | inst_i       | 32    | 指令内容            |
| in     | inst_addr_i  | 32    | 指令地址            |
| in     | inst_i       | 32    | 指令内容            |
| in     | inst_addr_i  | 32    | 指令地址            |
| in     | reg1_rdata_i | 32    | 通用寄存器1的数据   |
| in     | reg2_rdata_i | 32    | 通用寄存器2的数据   |
| in     | reg1_raddr_i | 5     | 读通用寄存器1的地址 |
| in     | reg2_raddr_i | 5     | 读通用寄存器2的地址 |
| in     | reg_we_i     | 1     | 写通用寄存器的标志  |
| in     | reg_waddr_i  | 5     | 写通用寄存器的地址  |
| in     | 0p1_i        | 32    | 操作数1             |
| in     | 0p1_i        | 32    | 操作数2             |
| in     | 0p1_jump_i   | 32    | 跳转操作数1         |
| in     | 0p1_jump_i   | 32    | 跳转操作数2         |
| out    | inst_o       | 32    | 指令内容            |
| out    | inst_addr_o  | 32    | 指令地址            |
| out    | reg1_rdata_o | 32    | 通用寄存器1的数据   |
| out    | reg2_rdata_o | 32    | 通用寄存器2的数据   |
| out    | reg1_raddr_o | 5     | 读通用寄存器1的地址 |
| out    | reg2_raddr_o | 5     | 读通用寄存器2的地址 |
| out    | reg_we_o     | 1     | 写通用寄存器的标志  |
| out    | reg_waddr_o  | 5     | 写通用寄存器的地址  |
| out    | op1_o        | 32    | 操作数1             |
| out    | op1_o        | 32    | 操作数2             |
| out    | op1_jump_o   | 32    | 跳转操作数1         |
| out    | op1_jump_o   | 32    | 跳转操作数2         |


#### 执行 `ex.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

#### 访存 `rd.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

#### 回写 `wr.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

#### 通用寄存器 `regs.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
| in     | inst_i       | 32    | 指令内容     |
| in     | inst_addr_i  | 32    | 指令地址     |
| in     |              |       |              |

#### 控制 `ctrl.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

#### 总线 `bus.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

### 外设模块

#### 指令储存 `rom.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

#### 数据储存 `ram.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |
