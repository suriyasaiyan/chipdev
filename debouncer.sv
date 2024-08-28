module debouncer (
    input wire clk,        
    input wire reset,     
    input wire noisy_btn,  
    output reg clean_btn    
);

    parameter DEBOUNCE_COUNT = 500_000; 
  
    reg [19:0] debounce_cnt; 
    reg btn_sync_1, btn_sync_2; // Synchronization flip-flops
    reg btn_stable;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_1 <= 1'b0;
            btn_sync_2 <= 1'b0;
        end else begin
            btn_sync_1 <= noisy_btn;
            btn_sync_2 <= btn_sync_1;
        end
    end

    // Debounce logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debounce_cnt <= 20'd0;
            btn_stable <= 1'b0;
            clean_btn <= 1'b0;
        end else begin
            if (btn_sync_2 == btn_stable) begin
                debounce_cnt <= 20'd0;
            end else begin
                if (debounce_cnt < DEBOUNCE_COUNT) begin
                    debounce_cnt <= debounce_cnt + 1;
                end else begin
                    btn_stable <= btn_sync_2;
                    clean_btn <= btn_stable;
                end
            end
        end
    end

endmodule
