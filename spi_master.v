module spi_master_m (input CLK, input START, input [7:0] DOUT, output reg [7:0] DIN = 0, output CS, output SCK, input MISO, output MOSI);

    reg [3:0] n = 0;
    wire [3:0] SCK_n = n - 2;
    wire SCK_output = 0 <= SCK_n && SCK_n <= 7;
    assign CS = !(n > 0);
    assign SCK = CLK && SCK_output;
    assign MOSI = !CS && SCK_output && DOUT[SCK_n];

    always @ (negedge CLK) begin
        if (n > 0) begin
            n <= n - 1;
        end
    end

    always @ (posedge CLK) begin
        if (SCK_output) begin
            DIN[SCK_n] = MISO;
        end
    end

    always @ (CLK) begin
        if (START && !n) begin
            n <= 7 + 3;
        end
    end

endmodule
