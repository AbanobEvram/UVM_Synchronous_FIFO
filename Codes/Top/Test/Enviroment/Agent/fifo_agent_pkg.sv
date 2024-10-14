////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Agent_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_agent_pkg;
	import fifo_monitor_pkg::*;
	import fifo_driver_pkg::*;
	import fifo_sequencer_pkg::*;
	import fifo_config_pkg::*;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class fifo_agent extends  uvm_agent;
		`uvm_component_utils(fifo_agent)

		fifo_monitor monitor;
		fifo_driver driver;
		fifo_sequencer sqr;
		fifo_config fifo_cfg;
		uvm_analysis_port #(fifo_seq_item) agt_aport;

		function  new(string name = "fifo_agent" , uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);

			if(!uvm_config_db#(fifo_config)::get(this, "", "CFG", fifo_cfg))
				`uvm_fatal("build_phase","Agent - unable to get configuration object");

			monitor=fifo_monitor::type_id::create("monitor",this);
			driver=fifo_driver::type_id::create("driver",this);
			sqr=fifo_sequencer::type_id::create("sqr",this);

			agt_aport=new("agt_aport",this);	   
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			driver.fifo_vif=fifo_cfg.fifo_vif;
			monitor.fifo_vif=fifo_cfg.fifo_vif;
			driver.seq_item_port.connect(sqr.seq_item_export);
			monitor.mon_aport.connect(agt_aport);
		endfunction : connect_phase

	endclass : fifo_agent
endpackage : fifo_agent_pkg