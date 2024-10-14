////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Driver_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_driver_pkg;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_driver extends uvm_driver #(fifo_seq_item);
		`uvm_component_utils(fifo_driver)

		virtual fifo_if fifo_vif;
		fifo_seq_item stim_seq_item;

   		function  new(string name = "fifo_driver" , uvm_component parent = null);
     		super.new(name,parent);
    	endfunction : new

    	task run_phase(uvm_phase phase);
    		super.run_phase(phase);
    		forever begin
    			stim_seq_item=fifo_seq_item::type_id::create("stim_seq_item",this);
    			seq_item_port.get_next_item(stim_seq_item);
    			fifo_vif.rd_en=stim_seq_item.rd_en;
    			fifo_vif.wr_en=stim_seq_item.wr_en;
    			fifo_vif.data_in=stim_seq_item.data_in;
    			fifo_vif.rst_n=stim_seq_item.rst_n;
    			@(negedge fifo_vif.clk);
    			seq_item_port.item_done();
    		end
    	endtask : run_phase

	endclass : fifo_driver
endpackage : fifo_driver_pkg