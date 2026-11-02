module d_ff_tb;

    logic D, clk, rst;
    logic Q;

    // Instantiate the D Flip-Flop
    d_ff uut (
        .D(D),
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Generate clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply test inputs
    initial begin
        $monitor("Time=%0t | rst=%b | clk=%b | D=%b | Q=%b",
                 $time, rst, clk, D, Q);

        rst = 1; D = 0;
        #10;

        rst = 0; D = 1;
        #10;

        D = 0;
        #10;

        D = 1;
        #10;

        D = 0;
        #10;

        rst = 1;
        #10;

        rst = 0; D = 1;
        #10;

        $finish;
    end

endmodule