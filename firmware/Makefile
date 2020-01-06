all: blink.bin

blink.out: blink.s
	riscv64-unknown-linux-gnu-as -o blink.out blink.s

blink.bin: blink.out
	riscv64-unknown-linux-gnu-objcopy -O binary blink.out blink.bin

clean:
	rm -f blink.bin blink.out