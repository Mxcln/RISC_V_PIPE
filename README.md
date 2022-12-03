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

#### 访存 `mem.v`

| in/out | input/output | width | comments                             |
| ------ | ------------ | ----- | ------------------------------------ |
| in     | arst_n       | 1     | 系统复位                             |
| in     | instc_i      | 32    | 指令输入                             |
| in     | mem_rena_i   | 1     | 访存使能输入                         |
| in     | mem_raddr_i  | 32    | 访存地址输入                         |
| in     | reg_wdata_i  | 32    | 写入通用寄存器的数据（访存或者执行） |
| in     | reg_waddr_i  | 5     | 访存通用寄存器地址输入               |
| in     | mem_wena_i   | 1     | 写入使能输入                         |
| in     | mem_waddr_i  | 32    | 写入的地址输入                       |
| in     | mem_wdata_i  | 32    | 写入的数据输入                       |
| out    | instc_o      | 32    | 指令输出                             |
| out    | mem_rdata_o  | 32    | 访存得到的数据输出                   |
| out    | reg_wdata_o  | 32    | 写入通用寄存器数据输出               |
| out    | reg_waddr_o  | 5     | 写入通用寄存器地址输出               |
| out    | mem_wena_o   | 1     | 写入使能输出                         |
| out    | mem_waddr_o  | 32    | 写入的地址输出                       |
| out    | mem_wdata_o  | 32    | 写入的数据输出                       |

#### 访存-回写 `mem_wb`
| in/out | input/output | width | comments               |
| ------ | ------------ | ----- | ---------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟           |
| in     | arst_n       | 1     | 系统复位               |
| in     | hold_ena_i   | 1     | 流水线暂停信号         |
| in     | instc_i      | 32    | 指令输入               |
| in     | mem_rena_i   | 1     | 访存使能输入           |
| in     | mem_rdata_i  | 32    | 访存得到的数据输入     |
| in     | reg_waddr_i  | 5     | 访存通用寄存器地址输入 |
| in     | mem_wena_i   | 1     | 写入使能输入           |
| in     | mem_waddr_i  | 32    | 写入的地址输入         |
| in     | mem_wdata_i  | 32    | 写入的数据输入         |
| out    | instc_o      | 32    | 指令输出               |
| out    | mem_rena_o   | 1     | 访存使能输出           |
| out    | mem_rdata_o  | 32    | 访存得到的数据输出     |
| out    | reg_waddr_o  | 5     | 访存通用寄存器地址输出 |
| out    | mem_wena_o   | 1     | 写入使能输出           |
| out    | mem_waddr_o  | 32    | 写入的地址输出         |
| out    | mem_wdata_o  | 32    | 写入的数据输出         |

#### 回写 `wb.v`

| in/out | input/output | width | comments               |
| ------ | ------------ | ----- | ---------------------- |
| in     | arst_n       | 1     | 系统复位               |
| in     | instc_i      | 32    | 指令输入               |
| in     | mem_rena_i   | 1     | 访存使能输入           |
| in     | mem_rdata_o  | 32    | 访存得到的数据输入     |
| in     | reg_waddr_i  | 5     | 访存通用寄存器地址输入 |
| in     | mem_wena_i   | 1     | 写入使能输入           |
| in     | mem_waddr_i  | 32    | 写入的地址输入         |
| in     | mem_wdata_i  | 32    | 写入的数据输入         |

#### 通用寄存器 `regs.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
| in     | inst_i       | 32    | 指令内容     |
| in     | inst_addr_i  | 32    | 指令地址     |
| in     |              |       |              |

#### 控制 `ctrl.v`

| in/out | input/output   | width | comments                       |
| ------ | -------------- | ----- | ------------------------------ |
| in     | clk_100MHz     | 1     | 系统输入时钟                   |
| in     | arst_n         | 1     | 系统复位                       |
| in     | hold           | 1     | 系统暂停                       |
| in     | ex_jump_i      | 1     | 执行时的跳转信号               |
| in     | ex_jump_addr_i | 32    | 执行模块输入的跳转地址         |
| out    | hold_ena_o     | 1     | 系统暂停                       |
| out    | jump_ena_o     | 1     | 跳转使能（注意后续模块的清零） |
| out    | jump_addr_o    | 1     | 跳转地址                       |


#### 数据总线 `bus.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

### 外设模块

#### 指令储存 `rom.v`

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | arst_n       | 1     | 系统复位             |
| in     | rena_i       | 1     | 读取使能             |
| in     | raddr_i      | 32    | 需要读取的数据的地址 |
| out    | rdata_o      | 32    | 输出读取的数据       |

#### 数据储存 `ram.v`

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | arst_n       | 1     | 系统复位             |
| in     | rena_i       | 1     | 读取使能             |
| in     | raddr_i      | 32    | 需要读取的数据的地址 |
| in     | wena_i       | 1     | 写入使能             |
| in     | waddr_i      | 32    | 需要写入的地址       |
| in     | wdata_i      | 32    | 需要写入的数据       |
| out    | rdata_o      | 32    | 输出读取的数据       |
