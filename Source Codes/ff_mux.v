module ff_mux #(
    parameter RSTTYPE = "SYNC",
    parameter WIDTH = 1,
    parameter XREG = 1 
) (
    input clk, rst, clk_en,
    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q
);
    
    reg [WIDTH-1:0] Q_sync, Q_async;

    always @(*) begin
        if (XREG) begin
            Q = (RSTTYPE == "SYNC")? Q_sync: Q_async;
        end
        else begin
            Q = D;
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            Q_sync <= 0;
        end
        else if (clk_en) begin
            Q_sync <= D;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q_async <= 0;
        end
        else if (clk_en) begin
            Q_async <= D;
        end
    end
endmodule