PROJ=Blinky
CONSTR=Blinky.lpf
TRELLIS=/home/craigjb/tools/prjtrellis
#Image read mode: qspi, dual-spi, fast-read
FLASH_MODE=qspi
#Image read freq, in MHz: 2.4, 4.8, 9.7, 19.4, 38.8, 62.0
FLASH_FREQ=38.8 #MHz
SPINAL_FILES=$(shell find ./src -name "*.scala")
RUST_FILES=$(shell find ./firmware/src -name "*.rs") firmware/Cargo.toml firmware/memory.x firmware/build.rs

all: $(PROJ).svf

firmware: $(RUST_FILES)
	cd firmware; cargo build --release; cargo make objcopy

spinal: firmware $(SPINAL_FILES)

%.v: spinal
	sbt run

%.json: %.v
	yosys -p "synth_ecp5 -json $@" $<

%_out.config: %.json
	nextpnr-ecp5 --json $< --lpf $(CONSTR) --textcfg $@ --45k --package CABGA381 --speed 8 --ignore-loops

%.bit: %_out.config
	ecppack --svf-rowsize 100000  --spimode $(FLASH_MODE) --freq $(FLASH_FREQ) \
		--svf $(PROJ).svf --input $< --bit $@

$(PROJ).svf: $(PROJ).bit

prog: $(PROJ).svf
	openocd -f openocd.cfg -c "init; svf  $<; exit"

clean:
	rm -f $(PROJ).json $(PROJ).svf $(PROJ).bit $(PROJ)_out.config Blinky.v Blinky.v*.bin

dfu_flash: $(PROJ).bit
	dfu-util$(EXE) -d 1d50:614a,1d50:614b -a 2 -R -D $(PROJ).bit

.PHONY: prog clean
.PRECIOUS: ${PROJ}.json ${PROJ}_out.config
.ALWAYS:
