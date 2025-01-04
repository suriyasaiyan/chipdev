class no_of1_constraints;
  rand bit [7:0] data;

  constraint odd_ones_no_consecutive {
    $countones(data) %2 == 1;

    foreach (data[i]) {
      if(i < 7)
        data[i] != 1 || data[i+1] != 1;
      }
  }
endclass : no_of1_constraints

module tb ();
 no_of1_constraints test;

 initial begin
  test = new();

  assert(test.randomize()) else $error("randomization failed");
  $display("the randomized value: %b", test.data);
 end
endmodule
