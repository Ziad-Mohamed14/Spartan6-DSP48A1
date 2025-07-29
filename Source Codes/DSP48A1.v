module Spartan6_DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
) (
    input [17:0] A, B, D,
    input [47:0] C, PCIN,
    input CARRYIN,
    input [7:0] OPMODE,
    input CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP,
    input RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
    output [35:0] M,
    output [47:0] P,
    output [17:0] BCOUT,
    output [47:0] PCOUT,
    output CARRYOUT, CARRYOUTF
);

    wire [17:0] BCIN, B_MUX;
    assign B_MUX = (B_INPUT == "DIRECT") ? B : (B_INPUT == "CASCADE") ? BCIN : 18'b0;

    wire [17:0] D_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(18), .XREG(DREG)) D_ff_mux (.clk(CLK), .rst(RSTD), .clk_en(CED), .D(D), .Q(D_REG));

    wire [17:0] A0_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(18), .XREG(A0REG)) A0_ff_mux (.clk(CLK), .rst(RSTA), .clk_en(CEA), .D(A), .Q(A0_REG));

    wire [47:0] C_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(48), .XREG(CREG)) C_ff_mux (.clk(CLK), .rst(RSTC), .clk_en(CEC), .D(C), .Q(C_REG));

    wire [7:0] OPMODE_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(8), .XREG(OPMODEREG)) OPMODE_ff_mux (.clk(CLK), .rst(RSTOPMODE), .clk_en(CEOPMODE), .D(OPMODE), .Q(OPMODE_REG));

    wire [17:0] pre_adder_subtract;
    assign pre_adder_subtract = (OPMODE_REG[6] == 1'b0) ? (D_REG + B_MUX) : (D_REG - B_MUX);

    wire [17:0] B1;
    assign B1 = (OPMODE_REG[4] == 1'b1) ? pre_adder_subtract : B_MUX;

    wire [17:0] B1_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(18), .XREG(B1REG)) B1_ff_mux (.clk(CLK), .rst(RSTB), .clk_en(CEB), .D(B1), .Q(B1_REG));
    assign BCOUT = B1_REG;

    wire [17:0] A1_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(18), .XREG(A1REG)) A1_ff_mux (.clk(CLK), .rst(RSTA), .clk_en(CEA), .D(A0_REG), .Q(A1_REG));

    wire [35:0] multiplication;
    assign multiplication = A1_REG * B1_REG;

    wire [35:0] M_REG;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(36), .XREG(MREG)) M_ff_mux (.clk(CLK), .rst(RSTM), .clk_en(CEM), .D(multiplication), .Q(M_REG));
    assign M = M_REG;

    wire [47:0] D_A_B;
    assign D_A_B = {D_REG[11:0], A1_REG, B1_REG};

    wire [47:0] X_MUX;
    four_one_mux #(.WIDTH(48)) X_four_one_mux (
        .in0({48{1'b0}}),
        .in1({{12{1'b0}}, M_REG}),
        .in2(P),
        .in3(D_A_B),
        .sel(OPMODE_REG[1:0]),
        .out(X_MUX)
    );

    wire [47:0] Z_MUX;
    four_one_mux #(.WIDTH(48)) Z_four_one_mux (
        .in0({48{1'b0}}),
        .in1(PCIN),
        .in2(P),
        .in3(C_REG),
        .sel(OPMODE_REG[3:2]),
        .out(Z_MUX)
    );

    wire carry_cascade;
    assign carry_cascade = (CARRYINSEL == "OPMODE5") ? OPMODE_REG[5] :
                           (CARRYINSEL == "CARRYIN") ? CARRYIN : 1'b0;

    wire CIN;
    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(1), .XREG(CARRYINREG)) CYI (.clk(CLK), .rst(RSTCARRYIN), .clk_en(CECARRYIN), .D(carry_cascade), .Q(CIN));

    wire [47:0] post_adder_subtractor;
    wire CARRY_OUT_POST;
    assign {CARRY_OUT_POST, post_adder_subtractor} = 
        (OPMODE_REG[7] == 1'b1) ? (Z_MUX - (X_MUX + CIN)) : (Z_MUX + X_MUX + CIN);

    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(1), .XREG(CARRYOUTREG)) CY0 (.clk(CLK), .rst(RSTCARRYIN), .clk_en(CECARRYIN), .D(CARRY_OUT_POST), .Q(CARRYOUT));
    assign CARRYOUTF = CARRYOUT;

    ff_mux #(.RSTTYPE(RSTTYPE), .WIDTH(48), .XREG(PREG)) P_ff_mux (.clk(CLK), .rst(RSTP), .clk_en(CEP), .D(post_adder_subtractor), .Q(P));
    assign PCOUT = P;
endmodule