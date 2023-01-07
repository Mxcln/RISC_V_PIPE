# RISCV 模块简介

这是一个支持 RV32I 指令的 riscv cpu, 采用五级流水线结构：取指 译码 执行 访存 回写

![流程图](pic/流程图.png)

系统采用流水线结构。通过流水线，cpu 与外设（rom，ram）连接并能够访问。

### 流水线模块

#### 指令计数 `pc.v`

| in/out | input/output | width | comments     |
| ------ | ------------ | ----- | ------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟 |
| in     | arst_n       | 1     | 系统复位     |
| in     | jump_addr_i  | 32    | 跳转地址     |
| in     | pc_div_hold  | 1     | 除法暂停     |
| in     | jump_ena_i   | 1     | 跳转使能     |
| in     | hold_ena_i   | 3     | 暂停使能     |
| out    | pc_addr_o    | 32    | 指令地址     |

#### 译码时序 `pc_id.v`

| in/out | input/output   | width | comments     |
| ------ | -------------- | ----- | ------------ |
| in     | clk_100MHz     | 1     | 系统输入时钟 |
| in     | arst_n         | 1     | 系统复位     |
| in     | inst_i         | 32    | 指令内容     |
| in     | inst_addr_i    | 32    | 指令地址     |
| in     | hold_ena_i     | 1     | 暂停使能     |
| in     | jump_ena_i     | 1     | 跳转使能     |
| in     | pc_id_div_hold | 1     | 除法暂停     |
| out    | inst_o         | 32    | 指令内容     |
| out    | inst_addr_o    | 32    | 指令地址     |

#### 译码 `id.v`

| in/out | input/output  | width | comments                  |
| ------ | ------------- | ----- | ------------------------- |
| in     | inst_i        | 32    | 指令内容                  |
| in     | inst_addr_i   | 32    | 指令地址                  |
| in     | reg1_r_data_i | 32    | 通用寄存器 1 要输入的数据 |
| in     | reg2_r_data_i | 32    | 通用寄存器 2 要输入的数据 |
| in     | ex_jump_ena_i | 1     | ex 跳转标志               |
| out    | inst_o        | 32    | 指令内容                  |
| out    | inst_addr_o   | 32    | 指令地址                  |
| out    | reg1_r_addr_o | 5     | 读通用寄存器 1 的地址     |
| out    | reg2_r_addr_o | 5     | 读通用寄存器 2 的地址     |
| out    | reg1_r_data_o | 32    | 通用寄存器 1 的数据       |
| out    | reg2_r_data_o | 32    | 通用寄存器 2 的数据       |
| out    | reg_w_ena_o   | 1     | 写通用寄存器的标志        |
| out    | mem_w_ena_o   | 1     | 向 mem 写回的使能信号     |
| out    | mem_r_ena_o   | 1     | 访存使能信号              |
| out    | reg_w_addr_o  | 5     | 写通用寄存器的地址        |

#### 执行时序 `id_ex`

| in/out | input/output   | width | comments              |
| ------ | -------------- | ----- | --------------------- |
| in     | clk_100MHz     | 1     | 系统输入时钟          |
| in     | arst_n         | 1     | 系统复位              |
| in     | inst_i         | 32    | 指令内容              |
| in     | inst_addr_i    | 32    | 指令地址              |
| in     | reg1_r_data_i  | 32    | 通用寄存器 1 的数据   |
| in     | reg2_r_data_i  | 32    | 通用寄存器 2 的数据   |
| in     | reg1_r_addr_i  | 5     | 读通用寄存器 1 的地址 |
| in     | reg2_r_addr_i  | 5     | 读通用寄存器 2 的地址 |
| in     | reg_w_ena_i    | 1     | 写通用寄存器的标志    |
| in     | reg_w_addr_i   | 5     | 写通用寄存器的地址    |
| in     | mem_r_ean_i    | 1     | 向 mem 写回的使能信号 |
| in     | mem_w_ena_i    | 1     | 访存使能信号          |
| in     | id_ex_div_hold | 1     | 除法暂停              |
| in     | hold_ena_i     | 1     | 暂停信号              |
| in     | jump_ena_i     | 1     | 跳转（冲刷）信号      |
| out    | inst_o         | 32    | 指令内容              |
| out    | inst_addr_o    | 32    | 指令地址              |
| out    | reg1_r_data_o  | 32    | 通用寄存器 1 的数据   |
| out    | reg2_r_data_o  | 32    | 通用寄存器 2 的数据   |
| out    | reg1_r_addr_o  | 5     | 读通用寄存器 1 的地址 |
| out    | reg2_r_addr_o  | 5     | 读通用寄存器 2 的地址 |
| out    | reg_w_ena_o    | 1     | 写通用寄存器的标志    |
| out    | mem_w_ena_o    | 1     | 向 mem 写回的使能信号 |
| out    | mem_r_ena_o    | 1     | 访存使能信号          |
| out    | reg_w_addr_o   | 5     | 写通用寄存器的地址    |

#### 执行前判断 `ex_stage.v`

| in/out | input/output        | width | comments                                  |
| ------ | ------------------- | ----- | ----------------------------------------- | --- |
| in     | id_ex_reg1_r_addr_i | 5     | 来自 id_ex 模块 reg1_r_addr 输出,以下同理 |
| in     | id_ex_reg2_r_addr_i | 5     |                                           |
| in     | ex_mem_reg_w_addr_i | 5     |                                           |
| in     | mem_wb_reg_w_addr_i | 5     |                                           |     |
| in     | ex_mem_reg_w_ena_i  | 1     |                                           |
| in     | mem_wb_reg_w_ena_i  | 1     |                                           |
| in     | id_ex_mem_w_ena_i   | 1     |                                           |
| in     | ex_mem_mem_r_ena_i  | 1     |                                           |
| in     | id_reg1_r_addr_i    | 5     |                                           |
| in     | id_reg2_r_addr_i    | 5     |                                           |
| in     | id_ex_reg_w_addr_i  | 5     |                                           |
| in     | id_ex_mem_r_ena_i   | 1     |                                           |
| in     | id_mem_w_ena_i      | 1     |                                           |
| in     | id_ex_reg_w_ena_i   | 1     |                                           |
| in     | ex_mem_reg_w_data_i | 32    |                                           |
| in     | mem_wb_reg_w_data_i |       |                                           |
| in     | id_ex_reg1_r_data_i |       |                                           |
| in     | id_ex_reg2_r_data_i |       |                                           |
| out    | forwardC_o          | 1     | 判断 lw-sw 型冒险，作用 mem_stage 模块    |
| out    | hazard_hold_o       | 1     | ex 前端输出冲刷信号，解决数据冒险         |     |
| out    | ex_in_reg1_r_data_o | 32    | 给 ex 模块实有效 reg1_r_data 数据         |
| out    | ex_in_reg2_r_data_o | 32    | 给 ex 模块实有效 reg2_r_data 数据         |

#### 除法模块 `div.v`

| in/out | input/output | width | comments       |
| ------ | ------------ | ----- | -------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟   |
| in     | arst_n       | 1     | 系统复位       |
| in     | dividend_i   | 32    | 被除数         |
| in     | divisor_i    | 32    | 除数           |
| in     | start_i      | 1     | 除法开始信号   |
| in     | div_func     | 3     | 除法指令的类型 |
| out    | result_o     | 32    | 除法结果       |
| out    | ready_o      | 1     | 除法结束信号   |

除法模块采用试商法实现除法，结构上是一个状态机，有 STATE_IDLE(闲置)，STATE_START(运作)，STATE_ZERO(除数为 0 的无效输入)，STATE_END(计算结束)四个状态。
在执行模块未收到除法指令时，停留在 STATE_IDLE 状态，输出均为 0。当 ex 收到除法信号后，start_i 信号为有效，判断除数是否为零，若为 0 则进入 STATE_ZERO 状态，若非 0 进入运作状态，并根据指令对输入的除数与被除数取补码原码。
在 STATE_START 状态下，通过试商法对被除数每一位取部分商，每取一位将被除数左移，这个过程需要 32 个周期，在此时间内除法模块对外界输出 ready_o=0,在执行模块中对收到的 ready_i 信号处理，转化为 div_hold(除法保持信号)，输出到 ctrl 控制模块。ctrl 模块对 pc,pc_id 以及 id_ex 模块输入保持信号，让新的指令不再输入到 ex，直到除法完成，将结果根据输入指令取原码与补码，赋值给 result_o。进入 STATE_END 状态。
在 STATE_ZERO 状态下，将除法结果 result_o 赋为 0，直接在下一个周期进入 STATE_END 状态。
在 STATE_END 状态下，输出 ready_o 变为有效，ex 模块在接受到 ready_i 有效之后，将 start_i 信号无效，使除法模块回到 STATE_IDLE 状态。同时 div_hold 信号无效，流水线继续流动。

#### 执行 `ex.v`

| in/out | input/output  | width | comments                               |
| ------ | ------------- | ----- | -------------------------------------- | --- |
| in     | inst_i        | 32    | 输入指令                               |
| in     | inst_addr_i   | 32    | 输入指令地址                           |
| in     | reg_w_ena_i   | 1     | 写寄存器的使能信号                     |
| in     | reg_w_addr_i  | 5     | 写寄存器的地址                         |
| in     | reg1_r_data_i | 32    | 通用寄存器 1 的数据                    |
| in     | reg2_r_data_i | 32    | 通用寄存器 2 的数据                    |
| in     | reg_w_ena_i   | 1     | 写通用寄存器的标志                     |
| in     | mem_w_ena_i   | 1     | 向 mem 写回的使能信号                  |
| in     | mem_r_ena_i   | 1     | 访存使能信号                           |
| in     | forwardC_i    | 1     | 判断 lw-sw 型冒险，作用 mem_stage 模块 |     |
| in     | result_i      | 32    | 除法的结果                             |
| in     | ready_i       | 1     | 除法完成使能                           |
| out    | forwardC_o    | 1     | 判断 lw-sw 型冒险，作用 mem_stage 模块 |
| out    | mem_r_ena_o   | 1     | 访存使能信号                           |
| out    | mem_r_addr_o  | 32    | 访存地址                               |
| out    | reg_w_addr_o  | 5     | 写寄存器的地址                         |
| out    | inst_o        | 32    | 指令                                   |
| out    | reg_w_ena_o   | 1     | 写寄存器的使能信号                     |
| out    | reg_w_data_o  | 32    | 写寄存器的数据                         |
| out    | jump_flag_o   | 1     | 跳转使能信号                           |
| out    | jump_addr_o   | 32    | 跳转的位置                             |
| out    | div_hold_o    | 1     | 除法需要的暂停                         |
| out    | mem_w_addr_o  | 32    | 向 mem 写回的目标地址                  |
| out    | mem_w_data_o  | 32    | 向 mem 写回的数据                      |
| out    | mem_w_ena_o   | 1     | 向 mem 写回的使能信号                  |
| out    | start_o       | 1     | 除法开始信号                           |
| out    | dividend_o    | 32    | 被除数                                 |
| out    | divisor_o     | 32    | 除数                                   |
| out    | div_func_o    | 3     | 除法种类（Div 与 divu）                |

#### 执行-访存 `ex_mem.v`

| in/out | input/output | width | comments                               |
| ------ | ------------ | ----- | -------------------------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟                           |
| in     | arst_n       | 1     | 系统复位                               |
| in     | hold         | 1     | 暂停流水线                             |
| in     | mem_r_ena_i  | 1     | 访存使能信号                           |
| in     | mem_r_addr_i | 32    | 访存地址                               |
| in     | reg_w_addr_i | 5     | 写寄存器的地址                         |
| in     | inst_i       | 32    | 指令                                   |
| in     | reg_w_ena_i  | 1     | 写寄存器的使能信号                     |
| in     | reg_w_data_i | 32    | 写寄存器的数据                         |
| in     | forwardC_i   | 1     | 判断 lw-sw 型冒险，作用 mem_stage 模块 |
| in     | mem_w_addr_i | 32    | 向 mem 写回的目标地址                  |
| in     | mem_w_data_i | 32    | 向 mem 写回的数据                      |
| in     | mem_w_ena_i  | 1     | 向 mem 写回的使能信号                  |
| out    | mem_r_ena_o  | 1     | 访存使能信号                           |
| out    | mem_r_addr_o | 32    | 访存地址                               |
| out    | reg_w_addr_o | 5     | 写寄存器的地址                         |
| out    | inst_o       | 32    | 指令                                   |
| out    | reg_w_ena_o  | 1     | 写寄存器的使能信号                     |
| out    | reg_w_data_o | 32    | 写寄存器的数据                         |
| out    | forwardC_o   | 1     | 判断 lw-sw 型冒险，作用 mem_stage 模块 |
| out    | mem_w_addr_o | 32    | 向 mem 写回的目标地址                  |
| out    | mem_w_data_o | 32    | 向 mem 写回的数据                      |
| out    | mem_w_ena_o  | 1     | 向 mem 写回的使能信号                  |

#### 访存 `mem.v`

| in/out | input/output | width | comments                             |
| ------ | ------------ | ----- | ------------------------------------ |
| in     | arst_n       | 1     | 系统复位                             |
| in     | inst_i       | 32    | 指令输入                             |
| in     | mem_r_ena_i  | 1     | 访存使能输入                         |
| in     | mem_r_data_i | 32    | 访存得到的数据输入                   |
| in     | mem_r_addr_i | 32    | 访存地址输入                         |
| in     | reg_w_ena_i  | 1     | 写入通用寄存器使能输入               |
| in     | reg_w_data_i | 32    | 写入通用寄存器的数据（访存或者执行） |
| in     | reg_w_addr_i | 5     | 访存通用寄存器地址输入               |
| in     | mem_w_ena_i  | 1     | 写入使能输入                         |
| in     | mem_w_addr_i | 32    | 写入的地址输入                       |
| in     | mem_w_data_i | 32    | 写入的数据输入                       |
| out    | inst_o       | 32    | 指令输出                             |
| out    | mem_r_ena_o  | 1     | 访存使能输出                         |
| out    | mem_r_data_o | 32    | 访存得到的数据输出                   |
| out    | mem_r_addr_o | 32    | 访存地址输出                         |
| out    | reg_w_ena_o  | 1     | 写入通用寄存器使能输出               |
| out    | reg_w_data_o | 32    | 写入通用寄存器数据输出               |
| out    | reg_w_addr_o | 5     | 写入通用寄存器地址输出               |
| out    | mem_w_ena_o  | 1     | 写入使能输出                         |
| out    | mem_w_addr_o | 32    | 写入的地址输出                       |
| out    | mem_w_data_o | 32    | 写入的数据输出                       |

#### 访存-回写 `mem_wb`

| in/out | input/output | width | comments                 |
| ------ | ------------ | ----- | ------------------------ |
| in     | clk_100MHz   | 1     | 系统输入时钟             |
| in     | arst_n       | 1     | 系统复位                 |
| in     | hold_ena_i   | 1     | 流水线暂停信号           |
| in     | inst_i       | 32    | 指令输入                 |
| in     | mem_r_ena_i  | 1     | 访存使能输入             |
| in     | mem_r_data_i | 32    | 访存得到的数据输入       |
| in     | mem_r_addr_i | 32    | 访存地址输入             |
| in     | reg_w_ena_i  | 1     | 写入通用寄存器使能输入   |
| in     | reg_w_data_i | 32    | 写入通用寄存器的数据输入 |
| in     | reg_w_addr_i | 5     | 访存通用寄存器地址输入   |
| in     | mem_w_ena_i  | 1     | 写入使能输入             |
| in     | mem_w_addr_i | 32    | 写入的地址输入           |
| in     | mem_w_data_i | 32    | 写入的数据输入           |
| out    | inst_o       | 32    | 指令输出                 |
| out    | mem_r_ena_o  | 1     | 访存使能输出             |
| out    | mem_r_data_o | 32    | 访存得到的数据输出       |
| out    | mem_r_addr_o | 32    | 访存地址输出             |
| out    | reg_w_ena_o  | 1     | 写入通用寄存器使能输出   |
| out    | reg_w_data_o | 32    | 写入通用寄存器数据输出   |
| out    | reg_w_addr_o | 5     | 写入通用寄存器地址输出   |
| out    | mem_w_ena_o  | 1     | 写入使能输出             |
| out    | mem_w_addr_o | 32    | 写入的地址输出           |
| out    | mem_w_data_o | 32    | 写入的数据输出           |

#### 回写 `wb.v`

| in/out | input/output | width | comments                 |
| ------ | ------------ | ----- | ------------------------ |
| in     | arst_n       | 1     | 系统复位                 |
| in     | inst_i       | 32    | 指令输入                 |
| in     | mem_r_ena_i  | 1     | 访存使能输入             |
| in     | mem_r_data_i | 32    | 访存得到的数据输入       |
| in     | mem_r_addr_i | 32    | 访存地址输入             |
| in     | reg_w_ena_i  | 1     | 写入通用寄存器使能输入   |
| in     | reg_w_data_i | 32    | 写入通用寄存器的数据输入 |
| in     | reg_w_addr_i | 5     | 访存通用寄存器地址输入   |
| in     | mem_w_ena_i  | 1     | 写入使能输入             |
| in     | mem_w_addr_i | 32    | 写入的地址输入           |
| in     | mem_w_data_i | 32    | 写入的数据输入           |
| out    | reg_w_ena_o  | 1     | 写入通用寄存器使能输出   |
| out    | reg_w_data_o | 32    | 写入通用寄存器数据输出   |
| out    | reg_w_addr_o | 5     | 写入通用寄存器地址输出   |
| out    | mem_w_ena_o  | 1     | 写入使能输出             |
| out    | mem_w_addr_o | 32    | 写入的地址输出           |
| out    | mem_w_data_o | 32    | 写入的数据输出           |

#### 通用寄存器 `regs.v`

| in/out | input/output  | width | comments              |
| ------ | ------------- | ----- | --------------------- |
| in     | clk_100MHz    | 1     | 系统输入时钟          |
| in     | arst_n        | 1     | 系统复位              |
| in     | w_ena_i       | 1     | 写寄存器使能          |
| in     | w_addr_i      | 5     | 写寄存器地址          |
| in     | w_data_i      | 32    | 写寄存器数据          |
| in     | reg1_r_addr_i | 5     | 读通用寄存器 1 的地址 |
| in     | reg2_r_addr_i | 5     | 读通用寄存器 2 的地址 |
| out    | reg1_r_data_o | 32    | 通用寄存器 1 的数据   |
| out    | reg2_r_data_o | 32    | 通用寄存器 2 的数据   |

#### 控制 `ctrl.v`

| in/out | input/output   | width | comments                          |
| ------ | -------------- | ----- | --------------------------------- |
| in     | clk_100MHz     | 1     | 系统输入时钟                      |
| in     | arst_n         | 1     | 系统复位                          |
| in     | hold           | 1     | 系统暂停                          |
| in     | ex_div_hold_i  | 1     | 除法暂停信号                      |
| in     | hazard_hold_i  | 1     | ex 前端输出冲刷信号，解决数据冒险 |
| in     | ex_jump_i      | 1     | 执行时的跳转信号                  |
| in     | ex_jump_addr_i | 32    | 执行模块输入的跳转地址            |
| out    | hold_ena_o     | 1     | 系统暂停（除了 pc 与 pc_id）      |
| out    | jump_ena_o     | 1     | 跳转使能（注意后续模块的清零）    |
| out    | jump_addr_o    | 1     | 跳转地址                          |
| out    | pc_hold_o      | 1     | pc 与 pc_id 的暂停                |
| out    | pc_id_clr_o    | 1     | pc_id 的冲刷信号（跳转时）        |
| out    | id_ex_clr_o    | 1     | id_ex 的冲刷信号（数据冒险时）    |
| out    | div_hold_o     | 1     | 除法暂停使能                      |

### 外设模块

#### 指令储存 `rom.v`

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | arst_n       | 1     | 系统复位             |
| in     | r_ena_i      | 1     | 读取使能             |
| in     | r_addr_i     | 32    | 需要读取的数据的地址 |
| out    | r_data_o     | 32    | 输出读取的数据       |

#### 数据储存 `ram.v`

| in/out | input/output | width | comments             |
| ------ | ------------ | ----- | -------------------- |
| in     | clk_100MHz   | 1     | 系统输入时钟         |
| in     | arst_n       | 1     | 系统复位             |
| in     | r_ena_i      | 1     | 读取使能             |
| in     | r_addr_i     | 32    | 需要读取的数据的地址 |
| in     | w_ena_i      | 1     | 写入使能             |
| in     | w_addr_i     | 32    | 需要写入的地址       |
| in     | w_data_i     | 32    | 需要写入的数据       |
| out    | r_data_o     | 32    | 输出读取的数据       |
