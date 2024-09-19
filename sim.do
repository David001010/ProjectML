set name layer_tb
#set pathQuartus "K:/intelfpga_lite/18.1/quartus/"
set path projectML

vlib work 
 
# vlog "../$path/manager.v"
 vlog "../$path/sigmoid.sv"    
 vlog "../$path/layer.sv"    
 vlog "../$path/layer_tb.sv"  
 
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
add wave -noupdate -divider {loop_l[0]}
add wave -position insertpoint {sim:/layer_tb/dut/loop_l[0]/sigm_inst_o/*}   
run -all
 