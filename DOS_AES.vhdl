library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.pseudorng;
use work.masked_aes_pkg.all;

entity DOS_AES is
generic (
	N : integer := 2
);
port (
	clock : in STD_LOGIC;
	reset : in STD_LOGIC;
	start : out STD_LOGIC;
	Cipher : out t_shared_gf8(N downto 0)
	);
end DOS_AES;

architecture behav of DOS_AES is 

signal plaintext : STD_LOGIC_VECTOR(127 downto 0);
signal key : STD_LOGIC_VECTOR(127 downto 0);
signal en : STD_LOGIC := '1';
signal Q : STD_LOGIC_VECTOR(127 downto 0);
signal check : STD_LOGIC;
signal StartxSI : STD_LOGIC;
signal rn : STD_LOGIC := '0';

-- the provided code processes 8 bits in 20 cycles, so that means
-- 16*20 = 320 cycles. A bit longer than the paper.
signal cycle : STD_LOGIC_VECTOR(7 downto 0);

--shared vars and random numbers for masks need to be in array
signal Binv1xDI : t_shared_gf2(N downto 0);
signal Binv2xDI : t_shared_gf2(N downto 0);
signal Binv3xDI : t_shared_gf2(N downto 0);
signal Bmul1xDI : t_shared_gf4(N downto 0);
signal Zinv1xDI : t_shared_gf2((N*(N+1)/2)-1 downto 0);
signal Zinv2xDI : t_shared_gf2((N*(N+1)/2)-1 downto 0);
signal Zinv3xDI : t_shared_gf2((N*(N+1)/2)-1 downto 0);
signal Zmul1xDI : t_shared_gf4((N*(N+1)/2)-1 downto 0);
signal Zmul2xDI : t_shared_gf4((N*(N+1)/2)-1 downto 0);
signal Zmul3xDI : t_shared_gf4((N*(N+1)/2)-1 downto 0);

signal PTxDI    : t_shared_gf8(N downto 0);
signal KxDI     : t_shared_gf8(N downto 0);

signal DonexSO  : std_logic;
signal CxDO     : t_shared_gf8(N downto 0);

begin

RAND : entity work.pseudorng
	port map (
		clock => clock,
		reset => reset,
		en => en,
		Q => Q,
		check => check
		);
		
AES : entity work.aes_top
	port map (
	clkxCI => clock,
	RstxBI => rn,
	PTxDI => PTxDI,
	KxDI => KxDI,
	Zmul1xDI => Zmul1xDI,
	Zmul2xDI => Zmul2xDI,
	Zmul3xDI => Zmul3xDI,
	Zinv1xDI => Zinv1xDI,
	Zinv2xDI => Zinv2xDI,
	Zinv3xDI => Zinv3xDI,
	Bmul1xDI => Bmul1xDI,
	Binv1xDI => Binv1xDI,
	Binv2xDI => Binv2xDI,
	Binv3xDI => Binv3xDI,
	StartxSI => StartxSI,
	DonexSO => DonexSO,
	CxDO => CxDO
	);
	

	
		
--I'm not gonna make an independent instance for all 14 random 
-- numbers im gonna need, instead i can split my 128 bit rand number into
-- a bunch of peices.



process (clock, reset)
begin
if (rising_edge(clock)) then
	cycle <= cycle + 1;
end if;

rn <= not reset;

if (reset = '1') then
	plaintext <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
	key <= x"000102030405060708090A0B0C0D0E0F";
	cycle <= x"00";
	StartxSI <= '0';
	Binv1xDI(0) <= "00";
	Binv1xDI(1) <= "00";
	Binv1xDI(2) <= "00";
	Binv2xDI(0) <= "00";
	Binv2xDI(1) <= "00";
	Binv2xDI(2) <= "00";
	Binv3xDI(0) <= "00";
	Binv3xDI(1) <= "00";
	Binv3xDI(2) <= "00";
	Bmul1xDI(0) <= x"0";
	Bmul1xDI(1) <= x"0";
	Bmul1xDI(2) <= x"0";
	Zinv1xDI(0) <= "00";
	Zinv1xDI(1) <= "00";
	Zinv1xDI(2) <= "00";
	Zinv2xDI(0) <= "00";
	Zinv2xDI(1) <= "00";
	Zinv2xDI(2) <= "00";
	Zinv3xDI(0) <= "00";
	Zinv3xDI(1) <= "00";
	Zinv3xDI(2) <= "00";
	Zmul1xDI(0) <= x"0";
	Zmul1xDI(1) <= x"0";
	Zmul1xDI(2) <= x"0";
	Zmul2xDI(0) <= x"0";
	Zmul2xDI(1) <= x"0";
	Zmul2xDI(2) <= x"0";
	Zmul3xDI(0) <= x"0";
	Zmul3xDI(1) <= x"0";
	Zmul3xDI(2) <= x"0";
	
	PTxDI(2) <= x"00";
	PTxDI(1) <= x"00";
	PTxDI(0) <= x"00";
	
	KxDI(2) <= x"00";
	KxDI(1) <= x"00";
	KxDI(0) <= x"00";
elsif (rising_edge(clock)) then
	case (cycle) is
		when x"00" =>
			StartxSI <= '1';
			plaintext <= plaintext + 1;
		when x"01" =>
			--update rand numbers
			Binv1xDI(0) <= Q(1 downto 0);
			Binv1xDI(1) <= Q(3 downto 2);
			Binv1xDI(2) <= Q(5 downto 4);
			Binv2xDI(0) <= Q(7 downto 6);
			Binv2xDI(1) <= Q(9 downto 8);
			Binv2xDI(2) <= Q(11 downto 10);
			Binv3xDI(0) <= Q(13 downto 12);
			Binv3xDI(1) <= Q(15 downto 14);
			Binv3xDI(2) <= Q(17 downto 16);
			Bmul1xDI(0) <= Q(21 downto 18);
			Bmul1xDI(1) <= Q(25 downto 22);
			Bmul1xDI(2) <= Q(29 downto 26);
			Zinv1xDI(0) <= Q(31 downto 30);
			Zinv1xDI(1) <= Q(33 downto 32);
			Zinv1xDI(2) <= Q(35 downto 34);
			Zinv2xDI(0) <= Q(37 downto 36);
			Zinv2xDI(1) <= Q(39 downto 38);
			Zinv2xDI(2) <= Q(41 downto 40);
			Zinv3xDI(0) <= Q(43 downto 42);
			Zinv3xDI(1) <= Q(45 downto 44);
			Zinv3xDI(2) <= Q(47 downto 46);
			Zmul1xDI(0) <= Q(51 downto 48);
			Zmul1xDI(1) <= Q(55 downto 52);
			Zmul1xDI(2) <= Q(59 downto 56);
			Zmul2xDI(0) <= Q(63 downto 60);
			Zmul2xDI(1) <= Q(67 downto 64);
			Zmul2xDI(2) <= Q(71 downto 68);
			Zmul3xDI(0) <= Q(75 downto 72);
			Zmul3xDI(1) <= Q(79 downto 76);
			Zmul3xDI(2) <= Q(83 downto 80);
			
			PTxDI(0) <= plaintext(127 downto 120) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(127 downto 120) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			StartxSI <= '0';
		when x"02" =>
			--compute 8bit cipher
			PTxDI(0) <= plaintext(119 downto 112) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(119 downto 112) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);	
					
		when x"03" =>
			PTxDI(0) <= plaintext(111 downto 104) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(111 downto 104) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"04" =>
			PTxDI(0) <= plaintext(103 downto 96) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(103 downto 96) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"05" =>
			PTxDI(0) <= plaintext(95 downto 88) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(95 downto 88) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"06" =>
			PTxDI(0) <= plaintext(87 downto 80) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(87 downto 80) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);	
			
		when x"07" =>
			PTxDI(0) <= plaintext(79 downto 72) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(79 downto 72) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"08" =>
			PTxDI(0) <= plaintext(71 downto 64) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(71 downto 64) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);	
			
		when x"09" =>
			PTxDI(0) <= plaintext(63 downto 56) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(63 downto 56) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"0A" =>
			PTxDI(0) <= plaintext(55 downto 48) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(55 downto 48) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);	
			
		when x"0B" =>			
			PTxDI(0) <= plaintext(47 downto 40) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(47 downto 40) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"0C" =>
			PTxDI(0) <= plaintext(39 downto 32) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(39 downto 32) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);	
			
		when x"0D" =>
			PTxDI(0) <= plaintext(31 downto 24) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(31 downto 24) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"0E" =>	
			PTxDI(0) <= plaintext(23 downto 16) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(23 downto 16) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
			
		when x"0F" =>
			PTxDI(0) <= plaintext(15 downto 8) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(15 downto 8) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
		when x"10" =>	
			PTxDI(0) <= plaintext(7 downto 0) xor Q(91 downto 84);
			PTxDI(1) <= Q(91 downto 84) xor Q(99 downto 92);
			PTxDI(2) <= Q(99 downto 92);
			
			KxDI(0) <= key(7 downto 0) xor Q(23 downto 16);
			KxDI(1) <= Q(23 downto 16) xor Q(31 downto 24);
			KxDI(2) <= Q(31 downto 24);
		
		when others =>
			--Do Nothing--
	end case;
end if;
end process;

start <= StartxSI;
Cipher <= CxDO;

end architecture;