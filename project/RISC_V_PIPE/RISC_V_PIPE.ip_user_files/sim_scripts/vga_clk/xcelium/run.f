-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/vivado/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/vivado/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/vivado/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../RISC_V_PIPE.srcs/sources_1/ip/vga_clk/vga_clk_clk_wiz.v" \
  "../../../../RISC_V_PIPE.srcs/sources_1/ip/vga_clk/vga_clk.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

