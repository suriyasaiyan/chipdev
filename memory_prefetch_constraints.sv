class memory_region;
  rand bit [31:0] start_address;
  rand bit [31:0] size;
  bit is_prefetchable;

  constraint prefetchable_constraint {
    if(is_prefetchable){
      start_address %64 == 0;
      size          %64 == 0;
    }
  }

  constraint not_prefetchable_constraint {
    if(!is_prefetchable)
      start_address %4 == 0;
  }

  function new();
    start_address = 32'h0;
    size          = 32'h0;
    is_prefetchable = 'b1;
  endfunction
endclass : memory_region
