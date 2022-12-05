
module mem_stage(
	input       [31:0]      rd2_data_mem_i_i,           //要写进ram的rs2地址对应的数据从ex_mem模块先经过mem_stage
	input       [31:0]      load_mem_wb_o_i,            //
	input                   forwardC_mem_i_i,           //forwardC_ex_mem_o
	output  reg [31:0]      mem_data_o

    );
    always @(*) begin
        case (forwardC_mem_i_i)
            1: begin
                mem_data_o = load_mem_wb_o_i;
            end
            default:begin
                mem_data_o = rd2_data_mem_i_i;
            end 
        endcase
    end
endmodule

