`include "define.v"
module div (
    input wire              arst_n,     //异步复位信号
    input wire              clk_100MHz, //时钟信号

    //from ex
    input wire [`REG]    dividend_i ,    //被除数
    input wire [`REG]    divisor_i  ,    //除数
    input wire          start_i    ,    //开始信号
    input wire [2:0]    div_func   ,    //除法的指令（有无符号数）

    //to ex
    output reg [`REG]    result_o  ,  //除法结果，只取了商的结果
    output reg           ready_o      //运算结束
    
);
    parameter STATE_IDLE = 2'b00  ;   //空闲状态
    parameter STATE_START = 2'b01 ;   //开始状态
    parameter STATE_ZERO  = 2'b10 ;   //错误输入状态,除数为0
    parameter STATE_END   = 2'b11 ;   //计算结束

    wire [32:0]  div_temp        ;      //用于判断试商过程中的结果是否大于等于0
    wire [`REG]  dividend_com    ;      //除数与被除数的补码
    wire [`REG]  divisor_com     ;
    reg  [5:0]   cnt             ;      //用于计数除法进行到第几个周期
    reg  [64:0]  dividend        ;      //扩展的被除数
    reg  [1:0]   state           ;
    reg  [`REG]  divisor        ;
    reg  [`REG]  dividend_temp       ;
    reg  [`REG]  divisor_temp       ;       //中间对除数进行过度的中间变量
    reg          sign               ;       //结果的符号
    
    assign dividend_com = ~dividend_i + 1 ;
    assign divisor_com = ~divisor_i + 1   ;

    assign div_temp = {1'b0,dividend[63:32]} - {1'b0,divisor} ;     //如果div_temp的最高位变成了1，说明当前的被减数的小于减数，即被除数需要向下借位
    
    always@(posedge clk_100MHz or negedge arst_n)begin
        if(!arst_n)
        begin
            state <= STATE_IDLE ;
            ready_o <= `DIV_DISABLE ;
            result_o <= `ZERO_REG ;
            sign    <= 1'b0     ;
        end
        else begin
            case(state)
            STATE_IDLE:begin
                if(start_i == `DIV_ENABLE)  //如果开始信号传来
                begin
                    if(divisor_i == `ZERO_WORD)         //如果除数为零，认为非法输入，进入STATE_ZERO
                    begin
                        state <= STATE_ZERO ;
                    end
                    else 
                    begin
                        state <= STATE_START ;
                        sign  <= dividend_i[31] ^ divisor_i[31] ;
                        cnt   <= 6'b0 ;                   //开始计数
                        if (div_func == `INST_DIV && dividend_i[31] == 1'b1 )
                            dividend_temp = dividend_com ;
                            else
                            dividend_temp = dividend_i ;

                        if (div_func == `INST_DIV && divisor_i[31] == 1'b1 )
                            divisor_temp = divisor_com ;
                        else
                            divisor_temp = divisor_i ;                          //将除数与被除数转化为绝对值
                        dividend <= {`ZERO_WORD,dividend_temp,1'b0};
                        divisor  <= divisor_temp ;
                    end
                end
                    else 
                    begin
                        ready_o <= `DIV_DISABLE ;
                        result_o <= `ZERO_WORD  ; 
                    end
                end
            STATE_START:begin
                if (cnt != 6'b100000)   //没有移够32位，试商法没有结束
                begin
                    if(div_temp[32] == 1 )   //说明借位了，该位商0
                        begin
                            dividend <= {dividend[63:0],1'b0};

                        end
                    else 
                        begin
                            dividend <= {div_temp[31:0],dividend[31:0],1'b1};
                        end
                    cnt <= cnt + 1 ;
                    end
                else begin
                    if ((div_func == `INST_DIV) && sign )        //带符号的除法并且两个数异号，需要取补码
                        dividend[31:0] = ~dividend[31:0] + 1 ;
                    else 
                        dividend[31:0] = dividend[31:0] ;
                    state <= STATE_END ;
                    cnt <= 6'b000000   ;
                end
            end
            STATE_ZERO:begin                    //如果除数为0 ，直接输出0 
                dividend <= `ZERO_WORD ;
                state <= STATE_END     ;
            end
            STATE_END:begin
                result_o <= dividend [31:0] ;
                ready_o  <= `DIV_ENABLE     ;
                if (start_i == `DIV_DISABLE )
                begin
                    state <= STATE_IDLE ;
                    ready_o <= `DIV_DISABLE ;
                    result_o <= `ZERO_WORD  ;
                end
                else
                    state <= STATE_END ;
            end
            endcase
    end
    end
endmodule 