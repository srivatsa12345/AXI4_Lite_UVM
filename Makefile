# Variables for easy modification
TOP_FILE = top.sv
TESTNAME ?=wr_rd_simul_rand
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

# List of tests to run in a regression
TEST_LIST = wr_rd_simul_rand rd_after_wr_with_simul_rand rd_after_wr_with_awaddr_first_rand rd_after_wr_with_wdata_first_rand back_rand wr_rd_simul_v rd_after_wr_with_simul_v rd_after_wr_with_awaddr_first_v rd_after_wr_with_wdata_first_v back_v wr_rd_simul_in rd_after_wr_with_simul_in rd_after_wr_with_awaddr_first_in rd_after_wr_with_wdata_first_in back_in wr_rd_simul_out rd_after_wr_with_simul_out rd_after_wr_with_awaddr_first_out rd_after_wr_with_wdata_first_out back_out

.PHONY: all start compile sim cov regression wave clean git

.DEFAULT_GOAL := all

# 1. Run the entire flow for a single test (Compile, Sim, Coverage)
all: compile sim cov

start:
	/bin/csh -c "source /fetools/synopsys/source/source.sh && exec /bin/csh"

# 2. Compile the design
# Note: Added -kdb for Verdi integration and FSDB dumping support
compile:
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2 \
	-debug_access+all -kdb $(COV_FLAGS) -l compile.log $(TOP_FILE)

# 3. Run the Simulation
# Note: Added -cm_name to keep coverage distinct for regressions
sim:
	./simv -l $(TESTNAME)_simulate.log $(COV_FLAGS) -cm_name $(TESTNAME) +UVM_TESTNAME=$(TESTNAME)

# 4. Generate the HTML Coverage Report
cov:
	urg -full64 -dir simv.vdb -report covReport

# 5. Run Regression (Compiles once, runs all tests in TEST_LIST, generates merged coverage)
regression: compile
	@for t in $(TEST_LIST); do \
		echo "=========================================================="; \
		echo " RUNNING TEST: $$t"; \
		echo "=========================================================="; \
		$(MAKE) sim TESTNAME=$$t; \
	done
	$(MAKE) cov

# 6. Open the Waveform in Verdi
wave:
	verdi -ssf wave.fsdb &

# 7. Clean up generated files to start fresh
clean:
	rm -rf simv* csrc* *.log *.vpd *.fsdb *.vdb ucli.key verdiLog novas*

# 8. Git automation
git:
	@echo "Enter your git commit message:"; \
	read msg; \
	git add *.sv Makefile; \
	git commit -m "$$msg"; \
	git push
