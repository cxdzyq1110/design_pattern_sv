cmp:
	vcs -full64 -sverilog ./builder.sv -top tb_top -LDFLAGS -Wl,--no-as-needed

run:
	./simv

verdi:
	verdi -sv ./builder.sv -top tb_top &

clean:
	rm -rf AN.DB simv* ucli* csrc*
