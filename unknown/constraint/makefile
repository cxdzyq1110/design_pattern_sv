cmp:
	vcs -full64 -sverilog ./constraint.sv -top tb_top -LDFLAGS -Wl,--no-as-needed

run:
	./simv

clean:
	rm -rf AN.DB simv* ucli* csrc*
