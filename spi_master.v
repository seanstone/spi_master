module spi_master_m (input CLK, input START, output BUSY, input [7:0] DOUT, output reg [7:0] DIN = 0, output CS, output SCK, input MISO, output MOSI);

    parameter t_pre = 0;
    parameter t_post = 0;

    reg [3:0] n = 0;
    wire [3:0] SCK_n = 7 - (n - (t_post + 1));
    wire SCK_output = 0 <= SCK_n && SCK_n <= 7;
    assign BUSY = n > 0;
    assign SCK = SCK_output && CLK;
    assign MOSI = SCK_output && DOUT[SCK_n];
    assign CS = !BUSY;

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

    always @ (posedge START) begin
        if (!BUSY) begin
            n <= 7 + (t_pre + 1) + (t_post + 1);
            DIN = 0;
        end
    end

endmodule
