module spi_master_m (input CLK, output BUSY, output TXE = 1, input [7:0] DOUT, output [7:0] DIN, output CS, output SCK, input MISO, output MOSI);

    parameter t_pre = 0;
    parameter t_post = 0;

    reg [3:0] n = 0;
    wire [3:0] SCK_n = 7 - (n - (t_post + 1));
    wire SCK_output = BUSY && 0 <= SCK_n && SCK_n <= 7;
    reg [7:0] dout = 0;

    assign BUSY = n > 0;
    assign SCK = SCK_output && CLK;
    assign MOSI = SCK_output && dout[SCK_n];
    assign CS = !BUSY;

    always @ (CLK) begin

        if (CLK) begin // posedge
            if (SCK_output) begin
                DIN[SCK_n] <= MISO; // sample MISO at posedge
            end
        end
        else begin // negedge
            if (BUSY) begin
                n <= n - 1; // shift MOSI at negedge
            end
        end

        if (!BUSY && !TXE) begin
            n <= 7 + (t_pre + 1) + (t_post + 1);
            dout <= DOUT; // sample DOUT at start of transfer command
            TXE <= 1;
            DIN <= 0;
        end

    end

    always @ (DOUT) begin
        TXE <= 0;
    end

endmodule
