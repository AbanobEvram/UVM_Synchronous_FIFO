vlib work
vlog -f list.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/f_if/*
coverage save FIFO_TOP.ucdb -onexit 
run -all
quit -sim
vcover report FIFO_TOP.ucdb -details -all -output fifo_report.txt
