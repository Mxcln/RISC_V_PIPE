module mux3_1(
	input [31:0]ex_mem_i,
	input [31:0]mem_wb_i,
	input [31:0]id_ex_i,
	input [1:0]sel_i,
	output [31:0]dout
    );
	//sel[1]=1则选择din1,即ex_mem的值；sel[0]=1,选择din2，即mem_wb的值;否则，选择id_ex的值
	assign dout=sel_i[1] ? ex_mem_i : sel_i[0] ? mem_wb_i : id_ex_i ;


endmodule

