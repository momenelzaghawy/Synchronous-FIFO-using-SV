vlib work
vlog -f src_files_FIFO.list   +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave /FIFO_top/fifoif/*
coverage save FIFO_tb.ucdb -onexit -du FIFO
run 0


