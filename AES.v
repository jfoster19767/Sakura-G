module AES (
	input clock,
	input reset,
	
	output ready,
	output st,
	output [127:0] c_txt
);

integer i;
integer j;

reg [5:0] cycle = 6'hff;
reg [127:0] c_txt_reg = 128'h00000000000000000000000000000000;
reg ready_reg = 1'b0;

reg [127:0] p_txt_reg1 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg1 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg2 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg2 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg3 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg3 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg4 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg4 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg5 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg5 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg6 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg6 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg7 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg7 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg8 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg8 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg9 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg9 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt_reg10 = 128'h00000000000000000000000000000000;
reg [127:0] key_reg10 = 128'h00000000000000000000000000000000;

reg [127:0] p_txt = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
reg [127:0] key = 128'h0F0E0D0C0B0A09080706050403020100;
reg start = 1'b0;

always @(posedge clock)
	if (!reset)
	begin
		cycle <= 6'hFF;
		c_txt_reg <= 128'h00000000000000000000000000000000;
		p_txt_reg1 <= 128'h00000000000000000000000000000000;
		key_reg1 <= 128'h00000000000000000000000000000000;
		p_txt_reg2 <= 128'h00000000000000000000000000000000;
		key_reg2 <= 128'h00000000000000000000000000000000;
		p_txt_reg3 <= 128'h00000000000000000000000000000000;
		key_reg3 <= 128'h00000000000000000000000000000000;
		p_txt_reg4 <= 128'h00000000000000000000000000000000;
		key_reg4 <= 128'h00000000000000000000000000000000;
		p_txt_reg5 <= 128'h00000000000000000000000000000000;
		key_reg5 <= 128'h00000000000000000000000000000000;
		p_txt_reg6 <= 128'h00000000000000000000000000000000;
		key_reg6 <= 128'h00000000000000000000000000000000;
		p_txt_reg7 <= 128'h00000000000000000000000000000000;
		key_reg7 <= 128'h00000000000000000000000000000000;
		p_txt_reg8 <= 128'h00000000000000000000000000000000;
		key_reg8 <= 128'h00000000000000000000000000000000;
		p_txt_reg9 <= 128'h00000000000000000000000000000000;
		key_reg9 <= 128'h00000000000000000000000000000000;
		p_txt_reg10 <= 128'h00000000000000000000000000000000;
		key_reg10 <= 128'h00000000000000000000000000000000;
		ready_reg <= 1'b0;
		p_txt <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		key <= 128'h0F0E0D0C0B0A09080706050403020100;
		start <= 1'b0;
	end
	else if (p_txt == 128'h00000000000000000000000000002328)
	begin
		// Done //
	end
	else if (start)
	begin
		p_txt_reg1 <= AddRoundKey(p_txt, key);
		key_reg1 <= key;
		ready_reg <= 1'b0;
		cycle <= cycle + 1'b1;
		start <= 1'b0;
	end
	else 
		case (cycle)
			6'hFF: 
			begin
				start <= 1'b1;
				p_txt <= p_txt + 1'b1;
				cycle <= cycle + 1'b1;
			end
			6'h01:
			begin
				p_txt_reg2 <= AddRoundKey(keyExpansion(key_reg1, 4'h1), mixColumns(shift_rows({c(p_txt_reg1[127:120]), c(p_txt_reg1[119:112]), c(p_txt_reg1[111:104]), c(p_txt_reg1[103:96]), c(p_txt_reg1[95:88]), c(p_txt_reg1[87:80]), c(p_txt_reg1[79:72]), c(p_txt_reg1[71:64]), c(p_txt_reg1[63:56]), c(p_txt_reg1[55:48]), c(p_txt_reg1[47:40]), c(p_txt_reg1[39:32]), c(p_txt_reg1[31:24]), c(p_txt_reg1[23:16]), c(p_txt_reg1[15:8]), c(p_txt_reg1[7:0])})));
				key_reg2 <= keyExpansion(key_reg1, 4'h1);
				cycle <= cycle + 1'b1;
			end
			6'h02:
			begin
				p_txt_reg3 <= AddRoundKey(keyExpansion(key_reg2, 4'h2), mixColumns(shift_rows({c(p_txt_reg2[127:120]), c(p_txt_reg2[119:112]), c(p_txt_reg2[111:104]), c(p_txt_reg2[103:96]), c(p_txt_reg2[95:88]), c(p_txt_reg2[87:80]), c(p_txt_reg2[79:72]), c(p_txt_reg2[71:64]), c(p_txt_reg2[63:56]), c(p_txt_reg2[55:48]), c(p_txt_reg2[47:40]), c(p_txt_reg2[39:32]), c(p_txt_reg2[31:24]), c(p_txt_reg2[23:16]), c(p_txt_reg2[15:8]), c(p_txt_reg2[7:0])})));
				key_reg3 <= keyExpansion(key_reg2, 4'h2);
				cycle <= cycle + 1'b1;
			end
			6'h03:
			begin
				p_txt_reg4 <= AddRoundKey(keyExpansion(key_reg3, 4'h3), mixColumns(shift_rows({c(p_txt_reg3[127:120]), c(p_txt_reg3[119:112]), c(p_txt_reg3[111:104]), c(p_txt_reg3[103:96]), c(p_txt_reg3[95:88]), c(p_txt_reg3[87:80]), c(p_txt_reg3[79:72]), c(p_txt_reg3[71:64]), c(p_txt_reg3[63:56]), c(p_txt_reg3[55:48]), c(p_txt_reg3[47:40]), c(p_txt_reg3[39:32]), c(p_txt_reg3[31:24]), c(p_txt_reg3[23:16]), c(p_txt_reg3[15:8]), c(p_txt_reg3[7:0])})));
				key_reg4 <= keyExpansion(key_reg3, 4'h3);
				cycle <= cycle + 1'b1;
			end
			6'h04:
			begin
				p_txt_reg5 <= AddRoundKey(keyExpansion(key_reg4, 4'h4), mixColumns(shift_rows({c(p_txt_reg4[127:120]), c(p_txt_reg4[119:112]), c(p_txt_reg4[111:104]), c(p_txt_reg4[103:96]), c(p_txt_reg4[95:88]), c(p_txt_reg4[87:80]), c(p_txt_reg4[79:72]), c(p_txt_reg4[71:64]), c(p_txt_reg4[63:56]), c(p_txt_reg4[55:48]), c(p_txt_reg4[47:40]), c(p_txt_reg4[39:32]), c(p_txt_reg4[31:24]), c(p_txt_reg4[23:16]), c(p_txt_reg4[15:8]), c(p_txt_reg4[7:0])})));
				key_reg5 <= keyExpansion(key_reg4, 4'h4);
				cycle <= cycle + 1'b1;
			end
			6'h05:
			begin
				p_txt_reg6 <= AddRoundKey(keyExpansion(key_reg5, 4'h5), mixColumns(shift_rows({c(p_txt_reg5[127:120]), c(p_txt_reg5[119:112]), c(p_txt_reg5[111:104]), c(p_txt_reg5[103:96]), c(p_txt_reg5[95:88]), c(p_txt_reg5[87:80]), c(p_txt_reg5[79:72]), c(p_txt_reg5[71:64]), c(p_txt_reg5[63:56]), c(p_txt_reg5[55:48]), c(p_txt_reg5[47:40]), c(p_txt_reg5[39:32]), c(p_txt_reg5[31:24]), c(p_txt_reg5[23:16]), c(p_txt_reg5[15:8]), c(p_txt_reg5[7:0])})));
				key_reg6 <= keyExpansion(key_reg5, 4'h5);
				cycle <= cycle + 1'b1;
			end
			6'h06:
			begin
				p_txt_reg7 <= AddRoundKey(keyExpansion(key_reg6, 4'h6), mixColumns(shift_rows({c(p_txt_reg6[127:120]), c(p_txt_reg6[119:112]), c(p_txt_reg6[111:104]), c(p_txt_reg6[103:96]), c(p_txt_reg6[95:88]), c(p_txt_reg6[87:80]), c(p_txt_reg6[79:72]), c(p_txt_reg6[71:64]), c(p_txt_reg6[63:56]), c(p_txt_reg6[55:48]), c(p_txt_reg6[47:40]), c(p_txt_reg6[39:32]), c(p_txt_reg6[31:24]), c(p_txt_reg6[23:16]), c(p_txt_reg6[15:8]), c(p_txt_reg6[7:0])})));
				key_reg7 <= keyExpansion(key_reg6, 4'h6);
				cycle <= cycle + 1'b1;
			end
			6'h07:
			begin
				p_txt_reg8 <= AddRoundKey(keyExpansion(key_reg7, 4'h7), mixColumns(shift_rows({c(p_txt_reg7[127:120]), c(p_txt_reg7[119:112]), c(p_txt_reg7[111:104]), c(p_txt_reg7[103:96]), c(p_txt_reg7[95:88]), c(p_txt_reg7[87:80]), c(p_txt_reg7[79:72]), c(p_txt_reg7[71:64]), c(p_txt_reg7[63:56]), c(p_txt_reg7[55:48]), c(p_txt_reg7[47:40]), c(p_txt_reg7[39:32]), c(p_txt_reg7[31:24]), c(p_txt_reg7[23:16]), c(p_txt_reg7[15:8]), c(p_txt_reg7[7:0])})));
				key_reg8 <= keyExpansion(key_reg7, 4'h7);
				cycle <= cycle + 1'b1;
			end
			6'h08:
			begin
				p_txt_reg9 <= AddRoundKey(keyExpansion(key_reg8, 4'h8), mixColumns(shift_rows({c(p_txt_reg8[127:120]), c(p_txt_reg8[119:112]), c(p_txt_reg8[111:104]), c(p_txt_reg8[103:96]), c(p_txt_reg8[95:88]), c(p_txt_reg8[87:80]), c(p_txt_reg8[79:72]), c(p_txt_reg8[71:64]), c(p_txt_reg8[63:56]), c(p_txt_reg8[55:48]), c(p_txt_reg8[47:40]), c(p_txt_reg8[39:32]), c(p_txt_reg8[31:24]), c(p_txt_reg8[23:16]), c(p_txt_reg8[15:8]), c(p_txt_reg8[7:0])})));
				key_reg9 <= keyExpansion(key_reg8, 4'h8);
				cycle <= cycle + 1'b1;
			end
			6'h09:
			begin
				p_txt_reg10 <= AddRoundKey(keyExpansion(key_reg9, 4'h9), mixColumns(shift_rows({c(p_txt_reg9[127:120]), c(p_txt_reg9[119:112]), c(p_txt_reg9[111:104]), c(p_txt_reg9[103:96]), c(p_txt_reg9[95:88]), c(p_txt_reg9[87:80]), c(p_txt_reg9[79:72]), c(p_txt_reg9[71:64]), c(p_txt_reg9[63:56]), c(p_txt_reg9[55:48]), c(p_txt_reg9[47:40]), c(p_txt_reg9[39:32]), c(p_txt_reg9[31:24]), c(p_txt_reg9[23:16]), c(p_txt_reg9[15:8]), c(p_txt_reg9[7:0])})));
				key_reg10 <= keyExpansion(key_reg9, 4'h9);
				cycle <= cycle + 1'b1;
			end
			6'h0a:
			begin
				c_txt_reg <= AddRoundKey(keyExpansion(key_reg10, 4'ha), shift_rows({c(p_txt_reg10[127:120]), c(p_txt_reg10[119:112]), c(p_txt_reg10[111:104]), c(p_txt_reg10[103:96]), c(p_txt_reg10[95:88]), c(p_txt_reg10[87:80]), c(p_txt_reg10[79:72]), c(p_txt_reg10[71:64]), c(p_txt_reg10[63:56]), c(p_txt_reg10[55:48]), c(p_txt_reg10[47:40]), c(p_txt_reg10[39:32]), c(p_txt_reg10[31:24]), c(p_txt_reg10[23:16]), c(p_txt_reg10[15:8]), c(p_txt_reg10[7:0])}));
				ready_reg <= 1'b1;
				cycle <= cycle + 1'b1;
			end
			default: cycle <= cycle + 1'b1; 
		endcase 
	
assign c_txt = c_txt_reg;
assign ready = ready_reg;
assign st = start;
	
function [7:0] c;

	input [7:0] byte_in;

	case (byte_in)
		8'h00: c=8'h63;
	   8'h01: c=8'h7c;
	   8'h02: c=8'h77;
	   8'h03: c=8'h7b;
	   8'h04: c=8'hf2;
	   8'h05: c=8'h6b;
	   8'h06: c=8'h6f;
	   8'h07: c=8'hc5;
	   8'h08: c=8'h30;
	   8'h09: c=8'h01;
	   8'h0a: c=8'h67;
	   8'h0b: c=8'h2b;
	   8'h0c: c=8'hfe;
	   8'h0d: c=8'hd7;
	   8'h0e: c=8'hab;
	   8'h0f: c=8'h76;
	   8'h10: c=8'hca;
	   8'h11: c=8'h82;
	   8'h12: c=8'hc9;
	   8'h13: c=8'h7d;
	   8'h14: c=8'hfa;
	   8'h15: c=8'h59;
	   8'h16: c=8'h47;
	   8'h17: c=8'hf0;
	   8'h18: c=8'had;
	   8'h19: c=8'hd4;
	   8'h1a: c=8'ha2;
	   8'h1b: c=8'haf;
	   8'h1c: c=8'h9c;
	   8'h1d: c=8'ha4;
	   8'h1e: c=8'h72;
	   8'h1f: c=8'hc0;
	   8'h20: c=8'hb7;
	   8'h21: c=8'hfd;
	   8'h22: c=8'h93;
	   8'h23: c=8'h26;
	   8'h24: c=8'h36;
	   8'h25: c=8'h3f;
	   8'h26: c=8'hf7;
	   8'h27: c=8'hcc;
	   8'h28: c=8'h34;
	   8'h29: c=8'ha5;
	   8'h2a: c=8'he5;
	   8'h2b: c=8'hf1;
	   8'h2c: c=8'h71;
	   8'h2d: c=8'hd8;
	   8'h2e: c=8'h31;
	   8'h2f: c=8'h15;
	   8'h30: c=8'h04;
	   8'h31: c=8'hc7;
	   8'h32: c=8'h23;
	   8'h33: c=8'hc3;
	   8'h34: c=8'h18;
	   8'h35: c=8'h96;
	   8'h36: c=8'h05;
	   8'h37: c=8'h9a;
	   8'h38: c=8'h07;
	   8'h39: c=8'h12;
	   8'h3a: c=8'h80;
	   8'h3b: c=8'he2;
	   8'h3c: c=8'heb;
	   8'h3d: c=8'h27;
	   8'h3e: c=8'hb2;
	   8'h3f: c=8'h75;
	   8'h40: c=8'h09;
	   8'h41: c=8'h83;
	   8'h42: c=8'h2c;
	   8'h43: c=8'h1a;
	   8'h44: c=8'h1b;
	   8'h45: c=8'h6e;
	   8'h46: c=8'h5a;
	   8'h47: c=8'ha0;
	   8'h48: c=8'h52;
	   8'h49: c=8'h3b;
	   8'h4a: c=8'hd6;
	   8'h4b: c=8'hb3;
	   8'h4c: c=8'h29;
	   8'h4d: c=8'he3;
	   8'h4e: c=8'h2f;
	   8'h4f: c=8'h84;
	   8'h50: c=8'h53;
	   8'h51: c=8'hd1;
	   8'h52: c=8'h00;
	   8'h53: c=8'hed;
	   8'h54: c=8'h20;
	   8'h55: c=8'hfc;
	   8'h56: c=8'hb1;
	   8'h57: c=8'h5b;
	   8'h58: c=8'h6a;
	   8'h59: c=8'hcb;
	   8'h5a: c=8'hbe;
	   8'h5b: c=8'h39;
	   8'h5c: c=8'h4a;
	   8'h5d: c=8'h4c;
	   8'h5e: c=8'h58;
	   8'h5f: c=8'hcf;
	   8'h60: c=8'hd0;
	   8'h61: c=8'hef;
	   8'h62: c=8'haa;
	   8'h63: c=8'hfb;
	   8'h64: c=8'h43;
	   8'h65: c=8'h4d;
	   8'h66: c=8'h33;
	   8'h67: c=8'h85;
	   8'h68: c=8'h45;
	   8'h69: c=8'hf9;
	   8'h6a: c=8'h02;
	   8'h6b: c=8'h7f;
	   8'h6c: c=8'h50;
	   8'h6d: c=8'h3c;
	   8'h6e: c=8'h9f;
	   8'h6f: c=8'ha8;
	   8'h70: c=8'h51;
	   8'h71: c=8'ha3;
	   8'h72: c=8'h40;
	   8'h73: c=8'h8f;
	   8'h74: c=8'h92;
	   8'h75: c=8'h9d;
	   8'h76: c=8'h38;
	   8'h77: c=8'hf5;
	   8'h78: c=8'hbc;
	   8'h79: c=8'hb6;
	   8'h7a: c=8'hda;
	   8'h7b: c=8'h21;
	   8'h7c: c=8'h10;
	   8'h7d: c=8'hff;
	   8'h7e: c=8'hf3;
	   8'h7f: c=8'hd2;
	   8'h80: c=8'hcd;
	   8'h81: c=8'h0c;
	   8'h82: c=8'h13;
	   8'h83: c=8'hec;
	   8'h84: c=8'h5f;
	   8'h85: c=8'h97;
	   8'h86: c=8'h44;
	   8'h87: c=8'h17;
	   8'h88: c=8'hc4;
	   8'h89: c=8'ha7;
	   8'h8a: c=8'h7e;
	   8'h8b: c=8'h3d;
	   8'h8c: c=8'h64;
	   8'h8d: c=8'h5d;
	   8'h8e: c=8'h19;
	   8'h8f: c=8'h73;
	   8'h90: c=8'h60;
	   8'h91: c=8'h81;
	   8'h92: c=8'h4f;
	   8'h93: c=8'hdc;
	   8'h94: c=8'h22;
	   8'h95: c=8'h2a;
	   8'h96: c=8'h90;
	   8'h97: c=8'h88;
	   8'h98: c=8'h46;
	   8'h99: c=8'hee;
	   8'h9a: c=8'hb8;
	   8'h9b: c=8'h14;
	   8'h9c: c=8'hde;
	   8'h9d: c=8'h5e;
	   8'h9e: c=8'h0b;
	   8'h9f: c=8'hdb;
	   8'ha0: c=8'he0;
	   8'ha1: c=8'h32;
	   8'ha2: c=8'h3a;
	   8'ha3: c=8'h0a;
	   8'ha4: c=8'h49;
	   8'ha5: c=8'h06;
	   8'ha6: c=8'h24;
	   8'ha7: c=8'h5c;
	   8'ha8: c=8'hc2;
	   8'ha9: c=8'hd3;
	   8'haa: c=8'hac;
	   8'hab: c=8'h62;
	   8'hac: c=8'h91;
	   8'had: c=8'h95;
	   8'hae: c=8'he4;
	   8'haf: c=8'h79;
	   8'hb0: c=8'he7;
	   8'hb1: c=8'hc8;
	   8'hb2: c=8'h37;
	   8'hb3: c=8'h6d;
	   8'hb4: c=8'h8d;
	   8'hb5: c=8'hd5;
	   8'hb6: c=8'h4e;
	   8'hb7: c=8'ha9;
	   8'hb8: c=8'h6c;
	   8'hb9: c=8'h56;
	   8'hba: c=8'hf4;
	   8'hbb: c=8'hea;
	   8'hbc: c=8'h65;
	   8'hbd: c=8'h7a;
	   8'hbe: c=8'hae;
	   8'hbf: c=8'h08;
	   8'hc0: c=8'hba;
	   8'hc1: c=8'h78;
	   8'hc2: c=8'h25;
	   8'hc3: c=8'h2e;
	   8'hc4: c=8'h1c;
	   8'hc5: c=8'ha6;
	   8'hc6: c=8'hb4;
	   8'hc7: c=8'hc6;
	   8'hc8: c=8'he8;
	   8'hc9: c=8'hdd;
	   8'hca: c=8'h74;
	   8'hcb: c=8'h1f;
	   8'hcc: c=8'h4b;
	   8'hcd: c=8'hbd;
	   8'hce: c=8'h8b;
	   8'hcf: c=8'h8a;
	   8'hd0: c=8'h70;
	   8'hd1: c=8'h3e;
	   8'hd2: c=8'hb5;
	   8'hd3: c=8'h66;
	   8'hd4: c=8'h48;
	   8'hd5: c=8'h03;
	   8'hd6: c=8'hf6;
	   8'hd7: c=8'h0e;
	   8'hd8: c=8'h61;
	   8'hd9: c=8'h35;
	   8'hda: c=8'h57;
	   8'hdb: c=8'hb9;
	   8'hdc: c=8'h86;
	   8'hdd: c=8'hc1;
	   8'hde: c=8'h1d;
	   8'hdf: c=8'h9e;
	   8'he0: c=8'he1;
	   8'he1: c=8'hf8;
	   8'he2: c=8'h98;
	   8'he3: c=8'h11;
	   8'he4: c=8'h69;
	   8'he5: c=8'hd9;
	   8'he6: c=8'h8e;
	   8'he7: c=8'h94;
	   8'he8: c=8'h9b;
	   8'he9: c=8'h1e;
	   8'hea: c=8'h87;
	   8'heb: c=8'he9;
	   8'hec: c=8'hce;
	   8'hed: c=8'h55;
	   8'hee: c=8'h28;
	   8'hef: c=8'hdf;
	   8'hf0: c=8'h8c;
	   8'hf1: c=8'ha1;
	   8'hf2: c=8'h89;
	   8'hf3: c=8'h0d;
	   8'hf4: c=8'hbf;
	   8'hf5: c=8'he6;
	   8'hf6: c=8'h42;
	   8'hf7: c=8'h68;
	   8'hf8: c=8'h41;
	   8'hf9: c=8'h99;
	   8'hfa: c=8'h2d;
	   8'hfb: c=8'h0f;
	   8'hfc: c=8'hb0;
	   8'hfd: c=8'h54;
	   8'hfe: c=8'hbb;
	   8'hff: c=8'h16;
	endcase 
	
endfunction
 
function [127:0] shift_rows;

	input [127:0] data_in;
	begin 
		shift_rows[127:120] = data_in[127:120];
		shift_rows[119:112] = data_in[87:80];
		shift_rows[111:104] = data_in[47:40];
		shift_rows[103:96] = data_in[7:0];
		
		shift_rows[95:88] = data_in[95:88];
		shift_rows[87:80] = data_in[55:48];
		shift_rows[79:72] = data_in[15:8];
		shift_rows[71:64] = data_in[103:96];
		
		shift_rows[63:56] = data_in[63:56];
		shift_rows[55:48] = data_in[23:16];
		shift_rows[47:40] = data_in[111:104];
		shift_rows[39:32] = data_in[71:64];
		
		shift_rows[31:24] = data_in[31:24];
		shift_rows[23:16] = data_in[119:112];
		shift_rows[15:8] = data_in[79:72];
		shift_rows[7:0] = data_in[39:32];
		
	end
	
endfunction

function [127:0] mixColumns;

	input [127:0] state;
	
		for (i = 0; i <= 3; i = i + 1)
		begin
			mixColumns[i*32+:8]  = MultiplyByTwo(state[(i*32)+:8])^(state[(i*32 + 8)+:8])^(state[(i*32 + 16)+:8])^MultiplyByThree(state[(i*32 + 24)+:8]);
			mixColumns[(i*32 + 8)+:8] = MultiplyByThree(state[(i*32)+:8])^MultiplyByTwo(state[(i*32 + 8)+:8])^(state[(i*32 + 16)+:8])^(state[(i*32 + 24)+:8]);
			mixColumns[(i*32 + 16)+:8] = (state[(i*32)+:8])^MultiplyByThree(state[(i*32 + 8)+:8])^MultiplyByTwo(state[(i*32 + 16)+:8])^(state[(i*32 + 24)+:8]);
			mixColumns[(i*32 + 24)+:8]  = (state[(i*32)+:8])^(state[(i*32 + 8)+:8])^MultiplyByThree(state[(i*32 + 16)+:8])^MultiplyByTwo(state[(i*32 + 24)+:8]);
		end


endfunction

function [7:0] MultiplyByTwo;

	input [7:0] x;
	
	begin 
			/* multiplication by 2 is shifting on bit to the left, and if the original 8 bits had a 1 @ MSB, xor the result with 0001 1011*/
			if(x[7] == 1) MultiplyByTwo = ((x << 1) ^ 8'h1b);
			else MultiplyByTwo = x << 1; 
	end
 	
endfunction

function [7:0] MultiplyByThree;

	input [7:0] x;
	
	begin 
			/* multiplication by 3 ,= 01 ^ 10 = (NUM * 01) XOR (NUM * 10) = (NUM) XOR (NUM Muliplication by 2) */
			MultiplyByThree = MultiplyByTwo(x) ^ x;
	end 
	
endfunction
	
function [31:0] rcon;
	
	input [3:0] r;
	
	case (r)
	 4'h1: rcon=32'h01000000;
    4'h2: rcon=32'h02000000;
    4'h3: rcon=32'h04000000;
    4'h4: rcon=32'h08000000;
    4'h5: rcon=32'h10000000;
    4'h6: rcon=32'h20000000;
    4'h7: rcon=32'h40000000;
    4'h8: rcon=32'h80000000;
    4'h9: rcon=32'h1b000000;
    4'ha: rcon=32'h36000000;
    default: rcon=32'h00000000;
  endcase
  
endfunction
	
function [127:0] keyExpansion	;

	input [127:0] keyInput;
	input [3:0] keyNum;
	
	begin
		keyExpansion[127:96] = keyInput[127:96] ^ {c(keyInput[23:16]), c(keyInput[15:8]), c(keyInput[7:0]), c(keyInput[31:24])} ^ rcon(keyNum); 	
		keyExpansion[95:64] = keyInput[95:64] ^ keyExpansion[127:96];
		keyExpansion[63:32] = keyInput[63:32] ^ keyExpansion[95:64];
		keyExpansion[31:0] = keyInput[31:0] ^ keyExpansion[63:32];
	end
	
endfunction

function [127:0] AddRoundKey;

	input [127:0] state;
	input [127:0] key;
	
	for (j = 0; j <= 15; j = j + 1)
		AddRoundKey[j*8 +: 8] = key[j*8 +: 8] ^ state[j*8 +: 8];
		
endfunction
	
endmodule 