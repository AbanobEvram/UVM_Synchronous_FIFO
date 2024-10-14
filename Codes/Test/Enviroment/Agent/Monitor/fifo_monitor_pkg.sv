////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Monitor_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_monitor_pkg;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_monitor extends  uvm_monitor;
		`uvm_component_utils(fifo_monitor)

		virtual fifo_if fifo_vif;
		fifo_seq_item seq_item;
		uvm_analysis_port #(fifo_seq_item) mon_aport;

		function  new(string name = "fifo_monitor" , uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_aport=new("mon_aport",this);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item=fifo_seq_item::type_id::create("seq_item");
				@(negedge fifo_vif.clk);
				//Input
				seq_item.rd_en=fifo_vif.rd_en;
				seq_item.rst_n=fifo_vif.rst_n;
				seq_item.wr_en=fifo_vif.wr_en;
				seq_item.data_in=fifo_vif.data_in;
				//Output
				seq_item.full=fifo_vif.full;
				seq_item.empty=fifo_vif.empty;
				seq_item.wr_ack=fifo_vif.wr_ack;
				seq_item.overflow=fifo_vif.overflow;
				seq_item.underflow=fifo_vif.underflow;
				seq_item.almostfull=fifo_vif.almostfull;
				seq_item.almostempty=fifo_vif.almostempty;
				seq_item.data_out=fifo_vif.data_out;
				mon_aport.write(seq_item);
				`uvm_info("run_phase",seq_item.Print_flags(),UVM_HIGH);
			end
		endtask : run_phase

	endclass : fifo_monitor
endpackage : fifo_monitor_pkg