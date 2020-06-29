library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pseudorng is
Port ( clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (127 downto 0);
       check: out STD_LOGIC);

--       constant seed: STD_LOGIC_VECTOR(7 downto 0) := "00000001";
end pseudorng;

architecture Behavioral of pseudorng is

--signal temp: STD_LOGIC;
signal Qt: STD_LOGIC_VECTOR(127 downto 0) := x"00000000000000000000000000000001";

begin

PROCESS(clock)
variable tmp : STD_LOGIC := '0';
BEGIN

IF rising_edge(clock) THEN
   IF (reset='1') THEN
   -- credit to QuantumRipple for pointing out that this should not
   -- be reset to all 0's, as you will enter an invalid state
      Qt <= x"00000010000000000000000000000001";
   --ELSE Qt <= seed;
   ELSIF en = '1' THEN
      tmp := Qt(127) XOR Qt(125) XOR Qt(100) XOR Qt(98);
      Qt <= tmp & Qt(127 downto 1);
   END IF;

END IF;
END PROCESS;
-- check <= temp;
check <= Qt(127);
Q <= Qt;

end Behavioral;