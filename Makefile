TOP := spi_master
HDLSRC += $(filter-out $(wildcard *.tb.v), $(wildcard *.v))

.PHONY: sim
sim: sim/$(TOP).tb
	$<

sim/%.tb: %.v %.tb.v
	mkdir -p sim/
	iverilog $^ -o $@

.PHONY: wav
wav: sim
	gtkwave sim/$(TOP).vcd

.PHONY: blif
blif: $(patsubst %.v, build/%.blif, $(HDLSRC))

build/%.blif: %.v
	mkdir -p build/
	yosys -q -S $^ -o $@

.PHONY: clean
clean:
	rm -rf build/ sim/
