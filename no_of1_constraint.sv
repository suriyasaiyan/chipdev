class no_of1_constraints;
  rand bit [7:0] var;

  constraint odd_ones_constraint {
    count_ones(var) %2 == 1;
    // or
    popcount(var) %2 == 1;
  }

  constraint odd_ones_no_consecutive {
    count_ones(var) %2 == 1;

    foreach (var[i]) begin
      if(i < 7)
        var[i] != 1 || var[i+1] != 1;
    end
  }

  function int count_ones (input bit [7:0] val);
    int count;
    foreach (val[i]) begin
      if(val[i])
        count++;
    return count;
    end 
  endfunction
endclass : no_of1_constraints
