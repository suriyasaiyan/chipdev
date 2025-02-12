module i_afifo#(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH =  8
  )(
  input wr_clk, rd_clk,
  input rst_n,
  input wr_en, rd_en,

  input [DATA_WIDTH -1:0] wr_data,

  output reg full, empty,
  output reg [DATA_WIDTH -1:0] rd_data
);

  logic [DATA_WIDTH -1:0] mem [0: ADDR_WIDTH-1];

  logic [$clog2(DATA_WIDTH) :0] wr_ptr, rd_ptr, wr_ctr, rd_ctr, 
                                wr_ptr_gray, wr_ptr_gray_sync,
                                rd_ptr_gray, rd_ptr_gray_sync;

  function automatic logic [$clog2(DATA_WIDTH) :0] binary_to_gary (input logic [$clog2(ADDR_WIDTH) :0] binary);
    return ((binary) ^ (binary >>1)); 
  endfunction

  // read side 
  always_ff @(posedge wr_clk or negedge rst_n) begin
    if(!rst_n) begin
      wr_ptr           <= 'b0;
      wr_ctr           <= 'b0;
      wr_ptr_gray      <= 'b0;
    end else begin
      if(wr_en && !full) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr      <= wr_ptr +1;
        wr_ptr_gray <= binary_to_gary(wr_ptr +1);
        wr_ctr      <= wr_ctr +1;
      end
    end
  end
    
  // write side 
  always_ff @(posedge rd_clk or negedge rst_n) begin
    if(!rst_n)begin
      rd_ptr           <= 'b0;
      rd_ctr           <= 'b0;
      rd_ptr_gray      <= 'b0;
    end else begin
      if(rd_en && !empty)begin
        rd_data <= mem[rd_ptr];
        rd_ptr  <= rd_ptr +1;
        rd_ptr_gray <= binary_to_gary(rd_ptr +1);
        rd_ctr <= rd_ctr +1;
      end
    end
  end

  // synchronizing read and write pointers using 2ff
  always_ff @(posedge wr_clk or negedge rst_n) begin
    if(!rst_n)
      wr_ptr_gray_sync <= 'b0;
    else
      wr_ptr_gray_sync <= rd_ptr_gray_sync;
  end

  always_ff @(posedge rd_clk or negedge rst_n) begin
    if(!rst_n)
      rd_ptr_gray_sync <= 'b0;
    else 
      rd_ptr_gray_sync <= wr_ptr_gray_sync;
  end

endmodule
