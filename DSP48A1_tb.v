module Spartan6_DSP48A1_tb();

    reg [17:0] A_tb, B_tb, D_tb;
    reg [47:0] C_tb, PCIN_tb;
    reg CARRYIN;
    reg [7:0] OPMODE;
    reg CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;

    reg [35:0] M_expected;
    reg [47:0] P_expected;
    reg [17:0] BCOUT_expected;
    reg [47:0] PCOUT_expected;
    reg CARRYOUT_expected, CARRYOUTF_expected;

    wire [35:0] M_dut;
    wire [47:0] P_dut;
    wire [17:0] BCOUT_dut;
    wire [47:0] PCOUT_dut;
    wire CARRYOUT_dut, CARRYOUTF_dut;
    
    Spartan6_DSP48A1 DUT (
        .A(A_tb), .B(B_tb), .D(D_tb), .C(C_tb), .PCIN(PCIN_tb),
        .CARRYIN(CARRYIN), .OPMODE(OPMODE), .CLK(CLK), .CEA(CEA),
        .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM),
        .CEOPMODE(CEOPMODE), .CEP(CEP), .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC),
        .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
        .M(M_dut), .P(P_dut), .BCOUT(BCOUT_dut), .PCOUT(PCOUT_dut), .CARRYOUT(CARRYOUT_dut), .CARRYOUTF(CARRYOUTF_dut) 
    );
    
    initial begin
        CLK = 0;
        forever
            #1 CLK = ~CLK;
    end

    initial begin
        {RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 8'b1111_1111;
        {CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP} = 8'b1111_1111;
        {A_tb, B_tb, D_tb, C_tb, PCIN_tb, CARRYIN, OPMODE} = 0;
        {M_expected, P_expected, BCOUT_expected, PCOUT_expected, CARRYOUT_expected, CARRYOUTF_expected} = 0;

        @(negedge CLK);

        if (M_dut != M_expected) begin
            $display("ERROR!");
        end

        if (P_dut != P_expected) begin
            $display("ERROR!");
        end

        if (BCOUT_dut != BCOUT_expected) begin
            $display("ERROR!");
        end

        if (PCOUT_dut != PCOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUT_dut != CARRYOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUTF_dut != CARRYOUTF_expected) begin
            $display("ERROR!");
        end
        
        //DSP - Path 1 [A = 20, B = 10, C = 350, and D = 25]
       {RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 8'b0;
       OPMODE = 8'b1101_1101;
       A_tb = 18'd20;
       B_tb = 18'd10;
       C_tb = 48'd350;
       D_tb = 18'd25;

       CARRYIN = 1'b1;
       PCIN_tb = 48'h00f0000f0000;
       repeat (4) @(negedge CLK);

       BCOUT_expected = 18'hf;
       M_expected = 36'h12c;
       P_expected = 48'h32;
       PCOUT_expected = 38'h32;
       CARRYOUT_expected = 0;
       CARRYOUTF_expected = 0;

       if (M_dut != M_expected) begin
            $display("ERROR!");
        end

        if (P_dut != P_expected) begin
            $display("ERROR!");
        end

        if (BCOUT_dut != BCOUT_expected) begin
            $display("ERROR!");
        end

        if (PCOUT_dut != PCOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUT_dut != CARRYOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUTF_dut != CARRYOUTF_expected) begin
            $display("ERROR!");
        end

        //DSP - Path 2 [A = 20, B = 10, C = 350, and D = 25] 
       OPMODE = 8'b00010000;

       repeat (3) @(negedge CLK);

       BCOUT_expected = 18'h23;
       M_expected = 36'h2bc;
       P_expected = 0;
       PCOUT_expected = 0;
       CARRYOUT_expected = 0;
       CARRYOUTF_expected = 0;

       if (M_dut != M_expected) begin
            $display("ERROR!");
        end

        if (P_dut != P_expected) begin
            $display("ERROR!");
        end

        if (BCOUT_dut != BCOUT_expected) begin
            $display("ERROR!");
        end

        if (PCOUT_dut != PCOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUT_dut != CARRYOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUTF_dut != CARRYOUTF_expected) begin
            $display("ERROR!");
        end

        //DSP - Path 3 [A = 20, B = 10, C = 350, and D = 25] 
       OPMODE = 8'b00001010;

       repeat (3) @(negedge CLK);

       BCOUT_expected = 18'ha;
       M_expected = 36'hc8;
       P_expected = 0;
       PCOUT_expected = 0;
       CARRYOUT_expected = 0;
       CARRYOUTF_expected = 0;

       if (M_dut != M_expected) begin
            $display("ERROR!");
        end

        if (P_dut != P_expected) begin
            $display("ERROR!");
        end

        if (BCOUT_dut != BCOUT_expected) begin
            $display("ERROR!");
        end

        if (PCOUT_dut != PCOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUT_dut != CARRYOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUTF_dut != CARRYOUTF_expected) begin
            $display("ERROR!");
        end
        
        //DSP - Path 3 [A = 5, B = 6, C = 350, D = 25 and PCIN = 3000] 
       OPMODE = 8'b10100111;
       A_tb = 18'd5;
       B_tb = 18'd6;
       C_tb = 48'd350;
       D_tb = 18'd25; 
       PCIN_tb = 48'd3000;

       repeat (3) @(negedge CLK);

       BCOUT_expected = 18'h6;
       M_expected = 36'h1e;
       P_expected = 48'hfe6fffec0bb1;
       PCOUT_expected = 48'hfe6fffec0bb1;
       CARRYOUT_expected = 1'b1;
       CARRYOUTF_expected = 1'b1;

       if (M_dut != M_expected) begin
            $display("ERROR!");
        end

        if (P_dut != P_expected) begin
            $display("ERROR!");
        end

        if (BCOUT_dut != BCOUT_expected) begin
            $display("ERROR!");
        end

        if (PCOUT_dut != PCOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUT_dut != CARRYOUT_expected) begin
            $display("ERROR!");
        end

        if (CARRYOUTF_dut != CARRYOUTF_expected) begin
            $display("ERROR!");
        end
        #10;
        $stop;
    end
endmodule