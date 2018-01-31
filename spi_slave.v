module spi_slave_m (input CS, input SCK, output MISO, input MOSI, input [7:0] DOUT, output reg [7:0] DIN = 0);

    reg [2:0] n = 0;
    assign MISO = (!CS) && DOUT[n];

    always @ (negedge CS) begin
        n <= 0;
        DIN <= 0;
    end

    always @ (posedge SCK) begin
        if (!CS) begin
            DIN[n] <= MOSI;
        end
    end

    always @ (negedge SCK) begin
        if (!CS) begin
            n <= n + 1;
        end
    end

endmodule
