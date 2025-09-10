// time_mux_7seg.sv
// Time-multiplex a single seven_segment_display decoder to show two nibbles.
// Uses `counter` (clock divider) and `seven_segment_display` (decoder).
// - Common anode displays: anode_en is active LOW (0 = selected).
// - seg_bus is active LOW (0 turns a segment ON).
//
// Inputs:  clk         : system clock
//          nibble0[3:0]: value to show on display 0
//          nibble1[3:0]: value to show on display 1
//
// Outputs: seg_bus[6:0]    : shared segment bus (drive to physical segments)
//          anode_en[1:0]   : per-digit common-anode enables (active LOW)
//          seg0_latched[6:0], seg1_latched[6:0] : decoded patterns latched for each nibble

module time_mux_7seg(
    input  logic        clk,         // system clock
    input  logic [3:0]  nibble0,     // value for digit 0
    input  logic [3:0]  nibble1,     // value for digit 1
    output logic [6:0]  seg_bus,     // shared segment bus (active LOW)
    output logic [1:0]  anode_en,    // active LOW common anode enables: anode_en[0] -> digit0, anode_en[1] -> digit1
    output logic [6:0]  seg0_latched,// latched pattern for nibble0 (for observation / test)
    output logic [6:0]  seg1_latched // latched pattern for nibble1 (for observation / test)
);

    // Slow clock from provided counter module. counter divides 'clk' down and exposes clk_new.
    logic clk_slow;
    counter u_counter (
        .clk    (clk),
        .clk_new(clk_slow)
    );

    // Selection flip-flop toggles at each rising edge of clk_slow.
    // When sel == 0 -> present nibble0 to decoder and enable digit0.
    // When sel == 1 -> present nibble1 to decoder and enable digit1.
    logic sel;
    always_ff @(posedge clk_slow) begin
        sel <= ~sel;
    end

    // Wire to feed the single decoder (selected nibble).
    logic [3:0] decoder_in;
    assign decoder_in = (sel == 1'b0) ? nibble0 : nibble1;

    // Single decoder instance (provided in seven_segment_display.sv)
    logic [6:0] decoded_seg;
    seven_segment_display u_decoder (
        .s   (decoder_in),
        .seg (decoded_seg)
    );

    // Drive the shared segment bus with the decoder output.
    // Only the currently-selected digit should be enabled via anode_en.
    assign seg_bus = decoded_seg;

    // Common-anode enables (active LOW)
    // When sel==0 we want digit0 active (anode_en[0] = 0), digit1 inactive (1)
    // When sel==1 we want digit1 active (anode_en[1] = 0), digit0 inactive (1)
    always_comb begin
        if (sel == 1'b0) begin
            anode_en = 2'b10; // anode_en[0]=0 (active), anode_en[1]=1 (off)
        end else begin
            anode_en = 2'b01; // anode_en[1]=0 (active), anode_en[0]=1 (off)
        end
    end

    // Latch the decoded patterns for each nibble whenever that nibble is selected.
    // This gives two 7-bit outputs that represent what each nibble decodes to,
    // without needing a second decoder instance.
    always_ff @(posedge clk_slow) begin
        if (sel == 1'b0) begin
            // we just selected nibble0 (decoder_in == nibble0) so store pattern to seg0_latched
            seg0_latched <= decoded_seg;
        end else begin
            // we just selected nibble1
            seg1_latched <= decoded_seg;
        end
    end

    // Init values for simulation clarity
    initial begin
        sel = 1'b0;
        seg0_latched = 7'b1111111;
        seg1_latched = 7'b1111111;
    end

endmodule
