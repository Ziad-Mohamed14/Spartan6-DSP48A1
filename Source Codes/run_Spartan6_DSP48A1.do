vlib work
vlog ff_mux.v DSP48A1.v four_one_mux.v DSP48A1_tb.v
vsim -voptargs=+acc work.Spartan6_DSP48A1_tb
add wave *
run -all
#quit -sim