#include <iostream>
#include <atomic>
#include <thread>

std::atomic<int> counter(0); 
void increment(){
  for(int i = 0; i < 1000; i++){
    counter.fetch_add(1, std::memory_order_relaxed);
  }
}
