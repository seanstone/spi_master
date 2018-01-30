module spi_master_tb;

    reg clk = 0;
    always #1 clk = ~clk;

    wire SCK;
    wire CS;
    wire MISO;
    wire MOSI;
    reg START = 0;
    reg [7:0] DOUT = 8'b 01011101;
    wire [7:0] DIN;

    assign MISO = 1; // test

    spi_master_m spi_master(
        .CLK(clk),
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO),
        .MOSI(MOSI),
        .START(START),
        .DIN(DIN),
        .DOUT(DOUT)
    );

    initial begin
        $dumpfile("sim/spi_master.vcd");
        $dumpvars(0, spi_master_tb);
        # 5 START = 1; # 1 START = 0;
        # 30 $finish;
    end

endmodule
