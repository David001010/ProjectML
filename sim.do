set name network_tb
set path projectML

vlib work 
 
 vlog "../$path/manager.sv"    
 vlog "../$path/layer.sv"    
 vlog "../$path/ff_network.sv"
 vlog "../$path/network_tb.sv"  
 
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
add wave -noupdate -divider {manager}
add wave -noupdate -decimal sim:/$name/dut/manager_inst/*
add wave -noupdate -divider {layer_in}
add wave -noupdate -decimal sim:/$name/dut/layer_inst_in/*
add wave -noupdate -divider {layer_out}
add wave -noupdate -decimal sim:/$name/dut/layer_inst_out/*
#add wave -noupdate -divider {loop_l[0]}
#add wave -position insertpoint {sim:/layer_tb/dut/loop_l[0]/sigm_inst_o/*} 
#add wave -noupdate -divider {sgimoid}
add wave -position insertpoint {sim:/network_tb/dut/layer_inst_in/loop_l[1]/sigm_inst_o/*} 
add wave -position insertpoint {sim:/network_tb/dut/layer_inst_in/loop_l[0]/sigm_inst_o/*}
add wave -position insertpoint {sim:/network_tb/dut/layer_inst_out/loop_l[1]/sigm_inst_o/*}
add wave -position insertpoint {sim:/network_tb/dut/layer_inst_out/loop_l[0]/sigm_inst_o/*}
run -all
 