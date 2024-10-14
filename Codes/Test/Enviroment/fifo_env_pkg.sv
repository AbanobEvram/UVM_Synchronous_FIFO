////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Enviroment_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_env_pkg;
	import fifo_scoreboard_pkg::*;
	import fifo_coverage_pkg::*;
	import fifo_agent_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_env extends  uvm_env;
		`uvm_component_utils(fifo_env)

		fifo_scoreboard sb;
		fifo_coverage cov;
		fifo_agent agt;

		function  new(string name = "fifo_env" , uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt=fifo_agent::type_id::create("agt",this);
      		sb=fifo_scoreboard::type_id::create("sb",this);
      		cov=fifo_coverage::type_id::create("cov",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		agt.agt_aport.connect(sb.sb_export);
      		agt.agt_aport.connect(cov.cov_export);
    	endfunction : connect_phase
	endclass : fifo_env
endpackage : fifo_env_pkg