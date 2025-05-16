set name twos_compleme_tb
set path projectML

vlib work 
 
 vlog "../$path/twos_compleme.sv"    
 vlog "../$path/twos_compleme_tb.sv"  
 
#mem load -i D:/intelFPGA/18.1/VerilogHDL/projectML/projectML/mema.mem {/layer_tb/dut/loop_l[0]/sigm_inst_o/sigm}  
 
vsim -voptargs=+acc work.$name

# Set the window types 
view wave do s
view structure
view signals

#add wave 
add wave -noupdate -divider {all}
add wave -noupdate -decimal sim:/$name/* 
add wave -noupdate -divider {dut}
add wave -noupdate -decimal sim:/$name/dut/*

run -all
 