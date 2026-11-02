module d_ff (
    input  logic D,
    input  logic clk,
    input  logic rst,
    output logic Q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end

endmodule