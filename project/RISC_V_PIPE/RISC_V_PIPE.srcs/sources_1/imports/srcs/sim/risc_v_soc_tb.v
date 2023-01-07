`timescale 1ns/1ns

module risc_v_soc_tb();
	reg clk_100MHz;
	reg arst_n;
    reg hold;
	wire [31:0]	ram_data_1;
	wire [31:0]	ram_data_2;

    initial begin
        $readmemb ("inst.data", u_risc_v_soc.u_rom._rom);
    end

	initial
	begin
		clk_100MHz = 1'b1;
		forever #5 clk_100MHz = ~clk_100MHz;
	end
	
	initial
	begin
        hold = 1'b0;
		arst_n = 1'b0;
		#25 arst_n = 1'b1;
		#4000 $stop;
	end

	risc_v_soc u_risc_v_soc
	(	
		.clk_100MHz(clk_100MHz),
		.arst_n(arst_n),
        .hold(hold),

		.ram_data_1(ram_data_1),
		.ram_data_2(ram_data_2)
	);
endmodule
