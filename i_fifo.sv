module fifo#(
  parameter DEPTH = 32,
  parameter DATA_WIDTH  = 8
  )(
    input clk,
    input rst_n,
    input [DEPTH -1:0] din,
    input wr_en, rd_en,
    output logic [DEPTH -1:0] dout,
    output logic empty,
    output logic full
    );
    
    logic [DATA_WIDTH -1:0] fifo_mem [0: DEPTH-1];
    logic [$clog2(DEPTH) -1:0] rd_ptr, wr_ptr;
    logic [$clog2(DEPTH) -1:0] cntr;

    always_ff @(posedge clk) begin  
      if(!rst_n) begin
        rd_ptr <= 'b0;
        wr_ptr <= 'b0;
        cntr   <= 'b0;
        empty  <= 'b0;
        full   <= 'b0;
        dout   <= 'b0;
      end else begin
        if(wr_en && !full) begin
          fifo_mem[wr_ptr] <= din;
          wr_ptr <= (wr_ptr +1) % DEPTH;
          cntr <= cntr +1;
        end else if (rd_en && !empty) begin
          dout <= fifo_mem[rd_ptr];
          rd_ptr <= (rd_ptr +1)% DEPTH;
          cntr <= cntr -1;
        end
      end
    end
endmodule
