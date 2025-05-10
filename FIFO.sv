////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifoif);

 
localparam max_fifo_addr = $clog2(fifoif.FIFO_DEPTH);

reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;
        fifoif.overflow <=0;  // bug1
        fifoif.wr_ack <=0;
	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifoif.overflow <=0;
       
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full && fifoif.wr_en)  // bug2
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
        fifoif.underflow <=0;
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifoif.underflow <=0;
	end
    else begin
        if (fifoif.empty &&fifoif.rd_en)
        fifoif.underflow <=1;
        else
        fifoif.underflow <=0;
    end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
			count <= count - 1;
          else if ({fifoif.wr_en , fifoif.rd_en} == 2'b11) begin   //bug3
            if (fifoif.full) 
            count<=count-1;
            if (fifoif.empty)
            count<=count+1;
          end  
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0; //bug4
assign fifoif.almostempty = (count == 1)? 1 : 0;

property no_1;
@(posedge fifoif.clk) !fifoif.rst_n |=> $past(!wr_ptr) && $past(!rd_ptr) && count == 0;
endproperty
property no_2;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && !fifoif.full |=> fifoif.wr_ack; 
endproperty
property no_3;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && fifoif.full |=> fifoif.overflow;  
endproperty
property no_4;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.rd_en && fifoif.empty |=> fifoif.underflow;
endproperty
property no_5;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) count==0 |=> $past(fifoif.empty); 
endproperty
property no_6;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) count==fifoif.FIFO_DEPTH |=> $past(fifoif.full);  
endproperty
property no_7;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) count==fifoif.FIFO_DEPTH-1 |=> $past(fifoif.almostfull); 
endproperty
property no_8;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) count==1 |=> $past(fifoif.almostempty); 
endproperty
property no_9;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) fifoif.wr_en && !fifoif.full && wr_ptr==fifoif.FIFO_DEPTH-1 |=> wr_ptr==0 ;
endproperty
property no_10;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n)  fifoif.rd_en && !fifoif.empty && rd_ptr==fifoif.FIFO_DEPTH-1 |=>  rd_ptr==0 ;
endproperty
property no_11;
@(posedge fifoif.clk) disable iff (!fifoif.rst_n) wr_ptr<=fifoif.FIFO_DEPTH-1 && rd_ptr<=fifoif.FIFO_DEPTH-1 && count<=fifoif.FIFO_DEPTH ;
endproperty


reset_assert:assert property (no_1);
reset_cover:cover property (no_1);
wr_ack_assert:assert property (no_2);
wr_ack_cover:cover property (no_2);
overflow_assert:assert property (no_3);
overflow_cover:cover property (no_3);
underflow_assert:assert property (no_4);
underflow_cover:cover property (no_4);
empty_assert:assert property (no_5);
empty_cover:cover property (no_5);
full_assert:assert property (no_6);
full_cover:cover property (no_6);
almostfull_assert:assert property (no_7);
almostfull_cover:cover property (no_7);
almostempty_assert:assert property (no_8);
almostempty_cover:cover property (no_8);
wraparound_wr_assert:assert property (no_9);
wraparound_wr_cover:cover property (no_9);
wraparound_rd_assert:assert property (no_10);
wraparound_rd_cover:cover property (no_10);
threshold_assert:assert property (no_11);
threshold_cover:cover property (no_11);
endmodule
