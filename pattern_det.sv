module pattern_det(
  input clk,
  input rst_n,
  input bit_in,
  output reg found
  );

  // pattern to look for: 10110
  logic [4:0] shift_reg;

  always_ff @(posedge clk) begin 
    if(!rst_n) begin
      shift_reg <= 5'b0;
      found     <= 'b0;
    end else begin
      shift_reg <= {shift_reg [3:0], bit_in};
      
      if(shift_reg == 5'b10110) begin
        found <= 'b1;
        $display("pattern found");
      end else begin
        found <= 'b0;
      end
    end
  end
endmodule

///////////////////////////////////////////
// TESTBENCH
///////////////////////////////////////////

module tb_pattern_det;

  reg clk;
  reg rst_n;
  reg bit_in;
  wire found;

  pattern_det uut (
    .clk(clk),
    .rst_n(rst_n),
    .bit_in(bit_in),
    .found(found)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  task apply_reset();
    begin
      rst_n = 0;
      #20 rst_n = 1;
    end
  endtask

  task send_sequence(input [31:0] seq, input integer length);
    begin
      for (int i = 0; i < length; i = i + 1) begin
        bit_in = seq[length - i - 1];
        #10;
      end
    end
  endtask

  initial begin
    $dumpfile("pattern_det.vcd");
    $dumpvars(0, tb_pattern_det);

    bit_in = 0;

    apply_reset();

    // Test case 1: Pattern 10110 present in the stream
    $display("\nTest Case 1: Pattern 10110 present\n");
    send_sequence(32'b00010_10110_00001, 15);

    // Test case 2: Pattern 10110 not present
    $display("\nTest Case 2: Pattern 10110 not present\n");
    send_sequence(32'b00011_01001_00001, 15);

    // Test case 3: Pattern at the very end of the sequence
    $display("\nTest Case 3: Pattern at the end\n");
    send_sequence(32'b00000_00000_10110, 15);

    #50;
    $finish;
  end
endmodule
