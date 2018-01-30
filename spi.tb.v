module spi_tb;

    reg clk = 0;
    always #1 clk = ~clk;

    wire SCK;
    wire CS;
    wire MISO;
    wire MOSI;
    reg START = 0;
    wire BUSY;
    reg [7:0] MASTER_DOUT = 8'h 56;
    wire [7:0] MASTER_DIN;
    reg [7:0] SLAVE_DOUT = 8'h 34;
    wire [7:0] SLAVE_DIN;

    spi_master_m spi_master(
        .CLK(clk),
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO),
        .MOSI(MOSI),
        .START(START),
        .BUSY(BUSY),
        .DIN(MASTER_DIN),
        .DOUT(MASTER_DOUT)
    );

    spi_slave_m spi_slave(
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO),
        .MOSI(MOSI),
        .DIN(SLAVE_DIN),
        .DOUT(SLAVE_DOUT)
    );

    initial begin
        $dumpfile("sim/spi.vcd");
        $dumpvars(0, spi_tb);
        # 5 START = 1; # 1 START = 0;
        # 60 $finish;
    end

    always @ (negedge BUSY) begin
        START = 1; # 1 START = 0;
    end

endmodule
