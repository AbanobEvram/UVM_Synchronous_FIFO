////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Sequences_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package fifo_sequence_pkg;
	import shared_pkg::*;
	import fifo_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
/**********************************************************************************************************/	
	class reset_assert extends  uvm_sequence #(fifo_seq_item);
		`uvm_object_utils(reset_assert)

		fifo_seq_item seq_item;

		function  new(string name = "reset_assert");
			super.new(name);
		endfunction : new

		task body();
			seq_item=fifo_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rd_en=0;
			seq_item.wr_en=0;
			seq_item.data_in=0;
			seq_item.rst_n=0;
			finish_item(seq_item);
		endtask : body
	endclass : reset_assert
/**********************************************************************************************************/	
	class Write_only extends  uvm_sequence #(fifo_seq_item);
		`uvm_object_utils(Write_only)

		fifo_seq_item seq_item;

		function  new(string name = "Write_only");
			super.new(name);
		endfunction : new

		task body();
			repeat(10) begin
				seq_item=fifo_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode(0);
				seq_item.Write_only.constraint_mode(1);//ON the Write_only constraint
				seq_item.data_in_prob.constraint_mode(1);//ON the data_in_prob constraint
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : Write_only
/**********************************************************************************************************/	
	class Read_only extends  uvm_sequence #(fifo_seq_item);
		`uvm_object_utils(Read_only)

		fifo_seq_item seq_item;

		function  new(string name = "Read_only");
			super.new(name);
		endfunction : new

		task body();
			repeat(10) begin
				seq_item=fifo_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode(0);
				seq_item.Read_only.constraint_mode(1);//ON the Read_only constraint
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : Read_only
/**********************************************************************************************************/	
	class Write_Read extends  uvm_sequence #(fifo_seq_item);
		`uvm_object_utils(Write_Read)

		fifo_seq_item seq_item;

		function  new(string name = "Write_Read");
			super.new(name);
		endfunction : new

		task body();
			repeat(1000) begin
				seq_item=fifo_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode(0);
				seq_item.Write_Read.constraint_mode(1);//ON the Write_Read constraint
				seq_item.data_in_prob.constraint_mode(1);//ON the data_in_prob constraint
				seq_item.Reset_prob.constraint_mode(1);//ON the Reset_prob constraint
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : Write_Read	
/**********************************************************************************************************/
	class Write_Read_Always extends  uvm_sequence #(fifo_seq_item);
		`uvm_object_utils(Write_Read_Always)

		fifo_seq_item seq_item;

		function  new(string name = "Write_Read_Always");
			super.new(name);
		endfunction : new

		task body();
			repeat(10) begin
				seq_item=fifo_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode(0);
				seq_item.Write_Read_always.constraint_mode(1);//ON the Write_Read_always constraint
				seq_item.data_in_prob.constraint_mode(1);//ON the data_in_prob constraint
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : Write_Read_Always
/**********************************************************************************************************/		
endpackage : fifo_sequence_pkg