////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Scoeboard_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_scoreboard_pkg;
	import shared_pkg::*;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(fifo_scoreboard)

    	logic [FIFO_WIDTH-1:0] data_out_ref;
    	logic full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref,wr_ack_ref;

    	logic [FIFO_WIDTH]mem_ref[FIFO_DEPTH];
    	logic [MAX_FIFO_ADDR-1:0] rd_ptr = 0,wr_ptr = 0;
    	logic [MAX_FIFO_ADDR:0] count =0;
 		
        uvm_analysis_export 	#(fifo_seq_item) sb_export;
		uvm_tlm_analysis_fifo 	#(fifo_seq_item) sb_fifo;
		fifo_seq_item 	seq_item_sb;

 		int error_dataout_count 	=0;
		int error_flags_count 		=0;
		int correct_dataout_count 	=0;	
		int correct_flags_count 	=0;
		
		function  new(string name="fifo_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_fifo=new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				reference_model(seq_item_sb);
				if(seq_item_sb.data_out!==data_out_ref) begin
					`uvm_error("run_phase",$sformatf("Compair dataout faild:%s ,data_out_ref=%0d",seq_item_sb.Print_data_out(),data_out_ref));
					error_dataout_count++;
				end
				else begin
					`uvm_info("run_phase",$sformatf("Compair dataout correct:%s",seq_item_sb.Print_data_out()),UVM_HIGH);
					correct_dataout_count++;
				end
				if({seq_item_sb.wr_ack, seq_item_sb.overflow, seq_item_sb.underflow, seq_item_sb.full, seq_item_sb.empty ,seq_item_sb.almostfull, seq_item_sb.almostempty}!=
			  	 	{wr_ack_ref,overflow_ref,underflow_ref,full_ref,empty_ref,almostfull_ref,almostempty_ref}) begin
					`uvm_error("run_phase",$sformatf("Compair dataout faild:%s",seq_item_sb.Print_flags()));
					error_flags_count++;
				end
				else begin
					`uvm_info("run_phase",$sformatf("Compair dataout correct:%s",seq_item_sb.Print_flags()),UVM_HIGH);
					correct_flags_count++;
				end				
			end
		endtask : run_phase

		function void reference_model(fifo_seq_item seq_chk);
		if(!seq_chk.rst_n) begin
			rd_ptr=0;wr_ptr=0;count=0;wr_ack_ref=0;overflow_ref=0;underflow_ref=0;
		end
		else begin
			//Condition for Write seq and  wr_ack flag
			if(seq_chk.wr_en&&count!=FIFO_DEPTH)begin
				mem_ref[wr_ptr]=seq_chk.data_in;
				wr_ack_ref=1;
				wr_ptr++;
			end
			else begin
				wr_ack_ref=0;
			end
			//Condition for overflow flag
			if (seq_chk.wr_en&&count==FIFO_DEPTH) begin
				overflow_ref=1;
			end
			else begin
				overflow_ref=0;
			end
			//Condition for underflow flag
			if (seq_chk.rd_en&&count==0) begin
				underflow_ref=1;
			end
			else begin
				underflow_ref=0;
			end
			//Condition for read seq
			if (seq_chk.rd_en&&count!=0) begin
				data_out_ref=mem_ref[rd_ptr];
				rd_ptr++;
			end
			//for counter
			if (seq_chk.wr_en&&!seq_chk.rd_en&&count!=FIFO_DEPTH) begin
				count++;
			end
			else if (!seq_chk.wr_en&&seq_chk.rd_en&&count!=0) begin
				count--;
			end
			else if(seq_chk.wr_en&&seq_chk.rd_en&&count==FIFO_DEPTH)
				count--;
			else if(seq_chk.wr_en&&seq_chk.rd_en&&count==0)
				count++;
			
		end
		//assigns for flags
			full_ref = (count == FIFO_DEPTH)? 1 : 0;
			empty_ref = (count == 0)? 1 : 0;
			almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0;
			almostempty_ref = (count == 1)? 1 : 0;
	endfunction

	function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("Total successful output: %0d",correct_dataout_count),UVM_LOW);
			`uvm_info("report_phase",$sformatf("Total faild output: %0d",error_dataout_count),UVM_LOW);
			`uvm_info("report_phase",$sformatf("Total successful flags: %0d",correct_flags_count),UVM_LOW);
			`uvm_info("report_phase",$sformatf("Total faild flags: %0d",error_flags_count),UVM_LOW);		
		endfunction : report_phase 

	endclass : fifo_scoreboard
endpackage : fifo_scoreboard_pkg			