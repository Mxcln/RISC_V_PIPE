onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib code_opt

do {wave.do}

view wave
view structure
view signals

do {code.udo}

run -all

quit -force
