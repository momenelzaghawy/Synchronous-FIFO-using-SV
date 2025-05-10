import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import internal_pkg::*;
module FIFO_tb (FIFO_if.TEST fifoif);
    FIFO_transaction tra = new();

    initial begin
      fifoif.rst_n=0;
      fifoif.rd_en=0;
      fifoif.wr_en=0;
      fifoif.data_in=0;
      @(negedge fifoif.clk);
      fifoif.rst_n=1;
      @(negedge fifoif.clk);
      @(negedge fifoif.clk);
     repeat (1000)begin
        assert(tra.randomize());
        fifoif.rst_n=tra.rst_n;
        fifoif.data_in=tra.data_in;
        fifoif.wr_en=tra.wr_en;
        fifoif.rd_en=tra.rd_en;
        @(negedge fifoif.clk);
        @(negedge fifoif.clk);
      end


      test_finished = 1;
      
     
    end
endmodule