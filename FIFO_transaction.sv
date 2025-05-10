package FIFO_transaction_pkg;
 class FIFO_transaction ;
 parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

rand logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

integer RD_EN_ON_DIST,WR_EN_ON_DIST;

function new(input integer RD_EN_ON_DIST=30,WR_EN_ON_DIST=70);
    this.RD_EN_ON_DIST=RD_EN_ON_DIST;
    this.WR_EN_ON_DIST=WR_EN_ON_DIST;    
endfunction
constraint rst_n_const {rst_n dist {0:=2,1:=98};}
constraint wr_en_const {
    wr_en dist{1:=WR_EN_ON_DIST,0:=(100-WR_EN_ON_DIST)};
}
constraint rd_en_const {
    rd_en dist{1:=RD_EN_ON_DIST,0:=(100-RD_EN_ON_DIST)};
}
 endclass 
endpackage