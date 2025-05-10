import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import internal_pkg::*;

module FIFO_MONITOR (FIFO_if.MON fifoif);
    FIFO_transaction tra = new();
    FIFO_scoreboard sco = new();
    FIFO_coverage cov= new() ;

    initial begin

        forever begin
            @(negedge fifoif.clk);
            assert(tra.randomize());
            tra.rst_n= fifoif.rst_n; 
            tra.data_in = fifoif.data_in; 
            tra.wr_en = fifoif.wr_en; 
            tra.rd_en = fifoif.rd_en;
            tra.full = fifoif.full ;
            tra.empty = fifoif.empty ;
            tra.wr_ack  = fifoif.wr_ack ;
            tra.almostempty  = fifoif.almostempty ;
            tra.almostfull  = fifoif.almostfull ;
            tra.data_out  = fifoif.data_out ;
            tra.overflow  = fifoif.overflow ;
            tra.underflow  = fifoif.underflow ; 
         
           fork
                begin
                    cov.sample_data(tra);
                end
                begin
                    sco.check_data(tra);
                end
            join
             if (test_finished) begin
            $display("correct_count= %0d,error_count=%0d",correct_count,error_count);
            $stop;
        end
    end
    end

endmodule