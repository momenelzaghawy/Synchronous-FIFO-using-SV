package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;

class FIFO_coverage;
    FIFO_transaction F_cvg_txn ;
    covergroup cg ;
   wr_en_cp:coverpoint F_cvg_txn.wr_en;
   rd_en_cp:coverpoint F_cvg_txn.rd_en;
   wr_ack_cp:coverpoint F_cvg_txn.wr_ack;
   overflow_cp:coverpoint F_cvg_txn.overflow;
   underflow_cp:coverpoint F_cvg_txn.underflow;
   full_cp:coverpoint F_cvg_txn.full;
   almostempty_cp:coverpoint F_cvg_txn.almostempty;
   almostfull_cp:coverpoint F_cvg_txn.almostfull;
   empty_cp:coverpoint F_cvg_txn.empty; 

   cross_1: cross wr_en_cp,rd_en_cp,wr_ack_cp;
   cross_2: cross wr_en_cp,rd_en_cp,overflow_cp;
   cross_3: cross wr_en_cp,rd_en_cp,underflow_cp;
   cross_4: cross wr_en_cp,rd_en_cp,full_cp;
   cross_5: cross wr_en_cp,rd_en_cp,almostempty_cp;
   cross_6: cross wr_en_cp,rd_en_cp,almostfull_cp;
   cross_7: cross wr_en_cp,rd_en_cp,empty_cp;
    endgroup 
    function new();
        cg=new();    
    endfunction 
    function void sample_data(input FIFO_transaction F_txn);
      F_cvg_txn = F_txn ;
      cg.sample();  
    endfunction 
endclass     
endpackage