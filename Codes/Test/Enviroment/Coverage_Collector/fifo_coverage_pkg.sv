////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Coverage_collector_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_coverage_pkg;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_coverage extends  uvm_component;
		`uvm_component_utils(fifo_coverage)

		uvm_analysis_export 	#(fifo_seq_item) cov_export;
		uvm_tlm_analysis_fifo 	#(fifo_seq_item) cov_fifo;
		fifo_seq_item seq_item;

		covergroup covcode;
			rst_n_p		 :coverpoint seq_item.rst_n {
				bins rst_n[] = {0,1};
			}
			wr_en_p		 :coverpoint seq_item.wr_en{
				bins wr_en[] = {0,1};
			}
			rd_en_p		 :coverpoint seq_item.rd_en{
				bins rd_en[] = {0,1}; 	
			}
			wr_ack_p 	 :coverpoint seq_item.wr_ack{
				bins wr_ack[] = {0,1}; 	
			}
			overflow_p 	 :coverpoint seq_item.overflow{
				bins overflow[] = {0,1}; 	
			}
			full_p 		 :coverpoint seq_item.full{
				bins full[] = {0,1}; 	
			}
			empty_p 	 :coverpoint seq_item.empty{
				bins empty[] = {0,1}; 	
			}
			almostfull_p :coverpoint seq_item.almostfull{
				bins almostfull[] = {0,1}; 	
			}
			almostempty_p:coverpoint seq_item.almostempty{
				bins almostempty[] = {0,1}; 	
			}
			underflow_p	 :coverpoint seq_item.underflow{
				bins underflow[] = {0,1}; 	
			}

			cross wr_en_p,rd_en_p,wr_ack_p{
				illegal_bins wr_dis_ack_en = binsof(wr_en_p) intersect{0} &&binsof(wr_ack_p) intersect{1};
			}
			cross wr_en_p,rd_en_p,overflow_p{
			  	illegal_bins wr_dis_over_en = binsof(wr_en_p) intersect{0} &&binsof(overflow_p) intersect{1};
			}
			cross wr_en_p,rd_en_p,full_p{
			  	illegal_bins wr_full_en=binsof(rd_en_p)intersect{1}&&binsof(full_p)intersect{1};
			}
			cross wr_en_p,rd_en_p,empty_p;
			cross wr_en_p,rd_en_p,almostfull_p;
			cross wr_en_p,rd_en_p,almostempty_p;
			cross wr_en_p,rd_en_p,underflow_p{
			  	illegal_bins rd_dis_uflo_en=binsof(rd_en_p)intersect{0}&&binsof(underflow_p)intersect{1};
			}
		endgroup : covcode


		function  new(string name = "fifo_coverage" , uvm_component parent = null);
			super.new(name,parent);
			covcode=new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export=new("cov_export",this);
			cov_fifo=new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item);
				covcode.sample();
			end
		endtask : run_phase

	endclass : fifo_coverage
endpackage : fifo_coverage_pkg