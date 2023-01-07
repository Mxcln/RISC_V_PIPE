`default_nettype none
`timescale 1ns/1ps

`define     BLACK           16'h0000        //黑色的rgb值
`define     WHITE           16'hffff        //白色的rgb值

//VGA parameter

// 640 * 480 60HZ
`define	    H_FRONT         16          // 行同步前沿信号周期长
`define	    H_SYNC          96          // 行同步信号周期长
`define	    H_BLACK         48          // 行同步后沿信号周期长
`define	    H_ACT           640         // 行显示周期长

`define	    V_FRONT         10          // 场同步前沿信号周期长
`define	    V_SYNC          2           // 场同步信号周期长
`define	    V_BLACK         29          // 场同步后沿信号周期长
`define	    V_ACT           480         // 场显示周期长

`define	    H_TOTAL         (`H_FRONT + `H_SYNC + `H_BLACK + `H_ACT)    // 行周期 800
`define	    V_TOTAL         (`V_FRONT + `V_SYNC + `V_BLACK + `V_ACT)    // 列周期 521


`define     CELL_WIDTH          32              //每个方格的像素宽
`define     CELL_HEIGHT         32              //每个方格的像素高
`define     CELL_PER_NUM        11               //数字数

`define     NUM_POS_WIDTH       ((`H_ACT - (`CELL_WIDTH * `CELL_PER_NUM ))/2)     //最左边距左边框长度(居中)
`define     NUM_POS_HEIGHT      ((`V_ACT)/2)                                 //距上边框长度      

