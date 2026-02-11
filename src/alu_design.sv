module pipelined_alu (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] a_in,
    input  logic [7:0] b_in,
    input  logic [2:0] op_in,
    output logic [7:0] alu_out,
    output logic       carry_out
);

    // --- Internal Pipeline Registers ---
    // Stage 1 Registers
    logic [7:0] a_reg, b_reg;
    logic [2:0] op_reg;

    // Stage 2 Intermediate wires (Combinational)
    logic [8:0] result_w; 

    // --- Stage 1: Input Sampling (Sequential) ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg  <= 8'd0;
            b_reg  <= 8'd0;
            op_reg <= 3'd0;
        end else begin
            a_reg  <= a_in;
            b_reg  <= b_in;
            op_reg <= op_in;
        end
    end

    // --- Stage 2: Execution Logic (Combinational) ---
    always_comb begin
        case (op_reg)
            3'b000: result_w = a_reg + b_reg;          // ADD
            3'b001: result_w = a_reg - b_reg;          // SUB
            3'b010: result_w = {1'b0, a_reg & b_reg};  // AND
            3'b011: result_w = {1'b0, a_reg | b_reg};  // OR
            3'b100: result_w = {1'b0, a_reg ^ b_reg};  // XOR
            3'b101: result_w = {1'b0, ~a_reg};         // NOT (on A)
            3'b110: result_w = {1'b0, a_reg << 1};     // SLL (Shift Left 1)
            3'b111: result_w = {1'b0, a_reg >> 1};     // SRL (Shift Right 1)
            default: result_w = 9'd0;
        endcase
    end
  
    // --- Stage 3: Output Registers (Sequential) ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_out   <= 8'd0;
            carry_out <= 1'b0;
        end else begin
            alu_out   <= result_w[7:0]; // Capture lower 8 bits
            carry_out <= result_w[8];   // Capture the 9th bit (Carry)
        end
    end
endmodule
      
      
