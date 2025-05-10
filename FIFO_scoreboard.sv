package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import internal_pkg::*;
class FIFO_scoreboard;
 FIFO_transaction tra = new();
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

logic wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
logic [FIFO_WIDTH-1:0] data_out_ref;

logic [FIFO_WIDTH-1:0] fifo_queue [$];
int count_fifo =0;
    
task check_data (input FIFO_transaction t_obj) ;
   reference_model(t_obj) ;
    if ( ( data_out_ref===t_obj.data_out) )
  correct_count++;   
  else begin
    error_count++;
    $display("%t,Error!,data_out=%0h,data_out_ref=%0h",$time,t_obj.data_out,data_out_ref);
  end 
endtask   
function void reference_model(input FIFO_transaction t_obj);
if(!t_obj.rst_n) begin
    fifo_queue <= {};
    count_fifo <= 0 ;
end
else begin
    if (t_obj.wr_en && count_fifo < FIFO_DEPTH) begin
        fifo_queue.push_back(t_obj.data_in);
        count_fifo <= fifo_queue.size();
    end
    if (t_obj.rd_en && count_fifo!=0) begin
        data_out_ref <= fifo_queue.pop_front();
        count_fifo <= fifo_queue.size();
    end
end
    
endfunction
endclass 
endpackage