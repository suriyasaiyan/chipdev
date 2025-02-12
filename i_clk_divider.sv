//===========================================
// File: CLK DIVIDER WITH N
//===========================================

module clk_divider #(
  parameter DIVISOR = 4  // Clock division factor (must be >= 1)
)(
  input  wire clk_in,  
  input  wire rst_n,  
  output reg  clk_out
);

  generate

    //--------------------------------------------------------------------------
    // Bypass: When DIVISOR is 1, simply pass through the input clock.
    //--------------------------------------------------------------------------  
    if (DIVISOR == 1) begin : bypass_divider
      assign clk_out = clk_in;
    end

    //--------------------------------------------------------------------------
    // Even Division: For even DIVISOR values, toggle the output after a fixed
    // number of input cycles. The output clock period will be DIVISOR * T.
    //--------------------------------------------------------------------------
    else if (DIVISOR % 2 == 0) begin : even_divider
      // Number of input cycles required for one toggle of clk_out.
      localparam HALF_DIV = DIVISOR / 2;  
      localparam COUNTER_WIDTH = $clog2(HALF_DIV);
      reg [COUNTER_WIDTH-1:0] even_counter;

      // On each positive edge of clk_in, count input cycles and toggle clk_out
      always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
          even_counter <= 0;
          clk_out      <= 1'b0;
        end else begin
          if (even_counter == HALF_DIV - 1) begin
            clk_out      <= ~clk_out;  // Toggle the divided clock
            even_counter <= 0;
          end else begin
            even_counter <= even_counter + 1;
          end
        end
      end
    end

    //--------------------------------------------------------------------------
    // Odd Division: For odd DIVISOR values, use dual-edge triggered toggling.
    // In this approach, two toggle-flops are used; one toggles on the positive
    // edge and the other on the negative edge. Their XOR produces a clock with
    // an effective division by DIVISOR.
    //--------------------------------------------------------------------------
    else begin : odd_divider
      // Count threshold for toggling. For odd DIVISOR, this is (DIVISOR+1)/2.
      localparam ODD_COUNT_THRESHOLD = (DIVISOR + 1) / 2;
      localparam ODD_COUNTER_WIDTH   = $clog2(ODD_COUNT_THRESHOLD);
      reg [ODD_COUNTER_WIDTH-1:0] odd_counter;

      // Positive-edge counter: resets after reaching the threshold.
      always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)
          odd_counter <= 'b0;
        else if (odd_counter == ODD_COUNT_THRESHOLD)
          odd_counter <= 'b0;
        else
          odd_counter <= odd_counter + 1;
      end

      //===========================================
      // EN toggle based on the cntr value
      //===========================================
      wire tff1_en = (odd_counter == 0);
      wire tff2_en = (odd_counter == ODD_COUNT_THRESHOLD);


      reg pos_edge_div;
      always_ff @(posedge clk_in or negedge rst_n) begin 
        if (!rst_n)
          pos_edge_div <= 1'b0;
        else if (tff1_en)
          pos_edge_div <= ~pos_edge_div;
      end

      reg neg_edge_div;
      always_ff @(negedge clk_in or negedge rst_n) begin
        if (!rst_n)
          neg_edge_div <= 1'b0;
        else if (tff2_en)
          neg_edge_div <= ~neg_edge_div;
      end

      assign clk_out = pos_edge_div ^ neg_edge_div;
    end
  endgenerate

endmodule
