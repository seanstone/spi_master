# TOP := spi_master
# HDLSRC += $(filter-out $(wildcard *.tb.v), $(wildcard *.v))

.PHONY: sim
sim: sim/spi.tb
	$<

sim/spi.tb: spi.tb.v spi_master.v spi_slave.v
	mkdir -p sim/
	iverilog $^ -o $@

.PHONY: wav
wav: sim
	gtkwave sim/spi.vcd

.PHONY: blif
blif: build/spi.blif

build/spi.blif: spi_master.v
	mkdir -p build/
	yosys -q -S $^ -o $@

.PHONY: clean
clean:
	rm -rf build/ sim/
