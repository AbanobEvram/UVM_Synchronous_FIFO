////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Assertions_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module fifo_sva(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out,  wr_ptr, rd_ptr, count);

input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
input [FIFO_WIDTH-1:0] data_out;
input wr_ack, overflow, underflow;
input full, empty, almostfull, almostempty;
input [MAX_FIFO_ADDR-1:0] wr_ptr, rd_ptr;
input [MAX_FIFO_ADDR:0] count;


/*******************************************************************************************************/
//property for the sequential flags to check when it active
property overflow_p; 
	@(posedge clk) disable iff (!rst_n) (count==FIFO_DEPTH&&wr_en) |=> overflow==1;
endproperty	 	
property underflow_p;
	@(posedge clk) disable iff (!rst_n) (count==0&&rd_en) |=> underflow==1;
endproperty	
property wr_ack_p;
	@(posedge clk) disable iff (!rst_n)  (count!=FIFO_DEPTH&&wr_en) |=> wr_ack==1;
endproperty	
/*******************************************************************************************************/
//property for the sequential flags to check when it Inactive
property overflow_inac_p; 
	@(posedge clk) disable iff (!rst_n) !(count==FIFO_DEPTH&&wr_en) |=> overflow==0;
endproperty	 	
property underflow_inac_p;
	@(posedge clk) disable iff (!rst_n) !(count==0&&rd_en) |=> underflow==0;
endproperty	
property wr_ack_inac_p;
	@(posedge clk) disable iff (!rst_n)  !(count!=FIFO_DEPTH&&wr_en) |=> wr_ack==0;
endproperty	
/*******************************************************************************************************/
//property for the combinational flags to check when it active
property full_p;
	@(posedge clk)  count==FIFO_DEPTH |-> full==1;
endproperty	
property almostfull_p;
	@(posedge clk)  count==FIFO_DEPTH-1 |-> almostfull==1;
endproperty	
property empty_p;
	@(posedge clk)  count==0 |-> empty==1;
endproperty	
property almostempty_p;
	@(posedge clk)  count==1 |-> almostempty==1;
endproperty
/*******************************************************************************************************/
//property for the combinational flags to check when it Inactive
property full_inac_p;
	@(posedge clk)  count!=FIFO_DEPTH |-> full==0;
endproperty	
property almostfull_inac_p;
	@(posedge clk)  count!=FIFO_DEPTH-1 |-> almostfull==0;
endproperty	
property empty_inac_p;
	@(posedge clk)  count!=0 |-> empty==0;
endproperty	
property almostempty_inac_p;
	@(posedge clk)  count!=1 |-> almostempty==0;
endproperty		
/*******************************************************************************************************/
//property for the pointers
property wr_ptr_p;
	@(posedge clk) disable iff (!rst_n) (count!=FIFO_DEPTH&&wr_en) |=> wr_ptr==$past(wr_ptr)+1'b1;
endproperty	
property rd_ptr_p;
	@(posedge clk) disable iff (!rst_n) (count!=0&&rd_en) |=> rd_ptr==$past(rd_ptr)+1'b1;
endproperty	
/*******************************************************************************************************/
//property for the counter signal
property count_wr_p;
	@(posedge clk) disable iff (!rst_n) (count!=FIFO_DEPTH&&wr_en&&!rd_en) |=> count==$past(count)+1'b1;
endproperty	
property count_rd_p;
	@(posedge clk) disable iff (!rst_n) (count!=0&&!wr_en&&rd_en) |=> count==$past(count)-1'b1;
endproperty	
property count_wr_rd_p;//this property for check if we read and write at the same clk cycle
	@(posedge clk) disable iff (!rst_n) (count!=FIFO_DEPTH&&count!=0&&wr_en&&rd_en) |=> count==$past(count);	
endproperty	
property countfull_wr_rd_p;//this property for check if we read and write is high but the FIFO is full
	@(posedge clk) disable iff (!rst_n) (count==FIFO_DEPTH&&wr_en&&rd_en) |=> count==$past(count)-1'b1;
endproperty	
property countempty_wr_rd_p;//this property for check if we read and write is high but the FIFO is empty
	@(posedge clk) disable iff (!rst_n) (count==0&&wr_en&&rd_en) |=> count==$past(count)+1'b1;
endproperty	
/*******************************************************************************************************/	
//assert for all properties
overflow_assertion	 		 :assert property(overflow_p);
underflow_assertion  		 :assert property(underflow_p);	
wr_ack_assertion	 	 	 :assert property(wr_ack_p);	

overflow_inac_assertion	  	 :assert property(overflow_inac_p);
underflow_inac_assertion  	 :assert property(underflow_inac_p);	
wr_ack_inac_assertion	  	 :assert property(wr_ack_inac_p);

full_assertion		 		 :assert property(full_p);
almostfull_assertion 		 :assert property(almostfull_p);
empty_assertion		 		 :assert property(empty_p);
almostempty_assertion 		 :assert property(almostempty_p);

full_inac_assertion		 	 :assert property(full_inac_p);
almostfull_inac_assertion 	 :assert property(almostfull_inac_p);
empty_inac_assertion		 :assert property(empty_inac_p);
almostempty_inac_assertion	 :assert property(almostempty_inac_p);

wr_ptr_assertion	 		 :assert property(wr_ptr_p);	
rd_ptr_assertion	 		 :assert property(rd_ptr_p);	

count_wr_assertion 	 		 :assert property(count_wr_p);	
count_rd_assertion 	 		 :assert property(count_rd_p);	
count_wr_rd_assertion		 :assert property(count_wr_rd_p);
countfull_wr_rd_assertion	 :assert property(countfull_wr_rd_p);
countempty_wr_rd_assertion	 :assert property(countempty_wr_rd_p);
/*******************************************************************************************************/
//Cover for all properties
overflow_coverage	 		 :cover property(overflow_p);
underflow_coverage	 		 :cover property(underflow_p);	
wr_ack_coverage	 	 		 :cover property(wr_ack_p);	

overflow_inac_coverage	  	 :cover property(overflow_inac_p);
underflow_inac_coverage  	 :cover property(underflow_inac_p);	
wr_ack_inac_coverage	  	 :cover property(wr_ack_inac_p);

full_coverage		 		 :cover property(full_p);
almostfull_coverage  		 :cover property(almostfull_p);
empty_coverage		 		 :cover property(empty_p);
almostempty_coverage 		 :cover property(almostempty_p);

full_inac_coverage		 	 :cover property(full_inac_p);
almostfull_inac_coverage 	 :cover property(almostfull_inac_p);
empty_inac_coverage		 	 :cover property(empty_inac_p);
almostempty_inac_coverage	 :cover property(almostempty_inac_p);

wr_ptr_coverage	 	 		 :cover property(wr_ptr_p);	
rd_ptr_coverage	 	 		 :cover property(rd_ptr_p);	

count_wr_coverage 	 		 :cover property(count_wr_p);	
count_rd_coverage 	 		 :cover property(count_rd_p);	
count_wr_rd_coverage 		 :cover property(count_wr_rd_p);	
countfull_wr_rd_coverage	 :cover property(countfull_wr_rd_p);
countempty_wr_rd_coverage	 :cover property(countempty_wr_rd_p);
always_comb begin
	if (!rst_n) begin
		rst_overflow_assert	  :assert final (overflow==0);
		rst_underflow_assert  :assert final (underflow==0);
		rst_wr_ack_assert	  :assert final (wr_ack==0);
		rst_wr_ptr_assert	  :assert final (wr_ptr==0);
		rst_rd_ptr_assert	  :assert final (rd_ptr==0);
		rst_count_assert	  :assert final (count==0);

		rst_overflow_coverage :cover final (overflow==0);
		rst_underflow_coverage:cover final (underflow==0);
		rst_wr_ack_coverage	  :cover final (wr_ack==0);
		rst_wr_ptr_coverage	  :cover final (wr_ptr==0);
		rst_rd_ptr_coverage	  :cover final (rd_ptr==0);
		rst_count_coverage	  :cover final (count==0);
	end	
end

endmodule	