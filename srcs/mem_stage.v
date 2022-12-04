module mem_stage(
	input [31:0]rd_data_mem_i,     //要写进ram的rs2地址对应的数据从ex_mem模块先经过mem_stage
	input [31:0]mem_wb_o,
	input forwardC_mem_i,           //=forwardC_ex_mem_o????
	output reg [31:0]mem_w_data_o
	
    );
    always @(*) begin
        case (forwardC_mem_i)
            1: begin
                mem_w_data_o = mem_wb_o;
            end
            default:begin
                mem_w_data_o = rd_data_mem_i;
            end 
        endcase
    end
endmodule

