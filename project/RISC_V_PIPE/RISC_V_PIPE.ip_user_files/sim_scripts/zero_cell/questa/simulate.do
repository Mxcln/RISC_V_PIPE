onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib zero_cell_opt

do {wave.do}

view wave
view structure
view signals

do {zero_cell.udo}

run -all

quit -force
