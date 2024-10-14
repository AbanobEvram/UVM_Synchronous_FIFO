////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Sequence_item_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_seq_item_pkg;
	import shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class fifo_seq_item extends  uvm_sequence_item;
		`uvm_object_utils(fifo_seq_item)

	rand logic [FIFO_WIDTH-1:0] data_in;
	rand logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow, underflow;
	logic full, empty, almostfull, almostempty;

	function  new(string name = "fifo_seq_item");
		super.new(name);
	endfunction : new

	function string Print_data_out();
		return $sformatf("data_in=%d,rst_n=%d,wr_en=%d,rd_en=%d,data_out=%d",
    					  data_in,rst_n,wr_en,rd_en,data_out);
	endfunction : Print_data_out

	function string Print_flags();
		return $sformatf("%s,wr_ack=%d,overflow=%d,underflow=%d,full=%d,empty=%d,almostfull=%d,almostempty=%d",
						  Print_data_out(),wr_ack,overflow,underflow,full,empty,almostfull,almostempty);
	endfunction : Print_flags

/****************************************************************************************************************/
/********************************************Constraints*********************************************************/

	constraint Reset_prob {
		rst_n dist {ACTIVE_RESET:/RESET_ON_DIST,INACRIVE_RESET:/100-RESET_ON_DIST};
	}

	constraint Write_only {
		wr_en==ACTIVE;
		rd_en==INACTIVE;
		rst_n==INACRIVE_RESET;
	}

	constraint Read_only {
		wr_en==INACTIVE;
		rd_en==ACTIVE;
		rst_n==INACRIVE_RESET;
	}

	constraint Write_Read {
		wr_en dist {ACTIVE:/WR_EN_ON_DIST,INACTIVE:/100-WR_EN_ON_DIST};
		rd_en dist {ACTIVE:/RD_EN_ON_DIST,INACTIVE:/100-RD_EN_ON_DIST};
	}

	constraint Write_Read_always {
		wr_en==ACTIVE;
		rd_en==ACTIVE;
		rst_n==INACRIVE_RESET;
	}

	constraint data_in_prob {
		data_in dist {MAX:/10,ZERO:/10,[ZERO:MAX]:/80};
	}

	endclass : fifo_seq_item
endpackage : fifo_seq_item_pkg