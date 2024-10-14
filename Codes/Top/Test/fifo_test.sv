////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Test_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_test_pkg;
	import fifo_env_pkg::*;
	import fifo_config_pkg::*;
	import fifo_sequence_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class fifo_test extends  uvm_test;
		`uvm_component_utils(fifo_test)

		fifo_env env;
		fifo_config fifo_cfg;

		reset_assert reset_seq;
		Write_only Write_seq;
		Read_only Read_seq;
		Write_Read Write_Read_seq;
		Write_Read_Always Write_Read_Always_Seq;

		function  new(string name = "fifo_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env 		 =fifo_env::type_id::create("env",this);
			fifo_cfg 	 =fifo_config::type_id::create("fifo_cfg",this);
			reset_seq=reset_assert::type_id::create("reset_seq",this);
			Write_seq=Write_only::type_id::create("Write_seq",this);
			Read_seq=Read_only::type_id::create("Read_seq",this);
			Write_Read_seq=Write_Read::type_id::create("Write_Read_seq",this);
			Write_Read_Always_Seq=Write_Read_Always::type_id::create("Write_Read_Always_Seq",this);

			if(!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_IF",fifo_cfg.fifo_vif))
				`uvm_fatal("build_phase","Test - unable to get the virtual interface of the shift_reg from the uvm_config_db");
			uvm_config_db#(fifo_config)::set(this, "*", "CFG",fifo_cfg);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			`uvm_info("run_phase","Reset asserted",UVM_LOW)
        	reset_seq.start(env.agt.sqr);

			`uvm_info("run_phase","Write only sequence Started",UVM_LOW)
        	Write_seq.start(env.agt.sqr);

        	`uvm_info("run_phase","Read only sequence Started",UVM_LOW)
        	Read_seq.start(env.agt.sqr);

			`uvm_info("run_phase","Write Read sequence Started",UVM_LOW)
        	Write_Read_seq.start(env.agt.sqr);

			`uvm_info("run_phase","Write Read Always sequence Started",UVM_LOW)
        	Write_Read_Always_Seq.start(env.agt.sqr);

			`uvm_info("run_phase","Test - End stimulus Generation",UVM_LOW);
			phase.drop_objection(this);
		endtask : run_phase

	endclass : fifo_test
	
endpackage : fifo_test_pkg