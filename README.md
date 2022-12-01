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
| in     | jump_ena_in  | 1     | 跳转使能         |
| in     | jump_addr_in | 32    | 跳转地址         |
| in     | hold_ena_in  | 3     | 暂停（清除）使能 |
| out    | pc_addr_out  | 32    | 指令地址         |

#### 译码 `dc.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

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
|        |              |       |              |
|        |              |       |              |
|        |              |       |              |

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

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟         |
| in     | arst_n       | 1     | 系统复位             |
| in     | rena_i       | 1     | 读取使能             |
| in     | raddr_i      | 32    | 需要读取的数据的地址 |
| in     | wena_i       | 1     | 写入使能             |
| in     | waddr_i      | 32    | 需要写入的地址       |
| in     | wdata_i      | 32    | 需要写入的数据       |
| out    | rdata_o      | 32    | 输出读取的数据       |

#### 数据储存 `ram.v`

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟         |
| in     | arst_n       | 1     | 系统复位             |
| in     | rena_i       | 1     | 读取使能             |
| in     | raddr_i      | 32    | 需要读取的数据的地址 |
| in     | wena_i       | 1     | 写入使能             |
| in     | waddr_i      | 32    | 需要写入的地址       |
| in     | wdata_i      | 32    | 需要写入的数据       |
| out    | rdata_o      | 32    | 输出读取的数据       |
