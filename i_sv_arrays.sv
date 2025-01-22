module array_types_demo;

  // 1. Fixed-size array
  // A static array with a fixed size known at compile time.
  int fixed_array [0:4];

  // 2. Dynamic array
  // An array that can be resized during runtime.
  int dynamic_array [];

  // 3. Associative array
  // An array indexed by values of any integral data type.
  int associative_array [string];

  // 4. Queue
  // An array that supports push and pop operations.
  int queue [$];

  initial begin
    $display("\nDemonstrating Fixed-size Array\n----------------------------");
    // Initialize fixed-size array
    fixed_array = '{1, 2, 3, 4, 5};
    foreach (fixed_array[i])
      $display("fixed_array[%0d] = %0d", i, fixed_array[i]);

    $display("\nDemonstrating Dynamic Array\n--------------------------");
    // Initialize and resize dynamic array
    dynamic_array = new[5];
    foreach (dynamic_array[i])
      dynamic_array[i] = i * 2;
    foreach (dynamic_array[i])
      $display("dynamic_array[%0d] = %0d", i, dynamic_array[i]);

    // Resize dynamic array
    dynamic_array = new[3];
    foreach (dynamic_array[i])
      dynamic_array[i] = i + 10;
    foreach (dynamic_array[i])
      $display("Resized dynamic_array[%0d] = %0d", i, dynamic_array[i]);

    $display("\nDemonstrating Associative Array\n-----------------------------");
    // Initialize associative array
    associative_array["apple"] = 100;
    associative_array["banana"] = 200;
    associative_array["cherry"] = 300;
    foreach (associative_array[key])
      $display("associative_array[%s] = %0d", key, associative_array[key]);

    $display("\nDemonstrating Queue\n-------------------");
    // Initialize and manipulate queue
    queue.push_back(10);
    queue.push_back(20);
    queue.push_back(30);

    foreach (queue[i])
      $display("queue[%0d] = %0d", i, queue[i]);

    // Pop and display queue elements
    $display("Popped element: %0d", queue.pop_front());
    foreach (queue[i])
      $display("After pop queue[%0d] = %0d", i, queue[i]);

    queue.push_front(5);
    $display("After push_front queue = %p", queue);
  end

endmodule
