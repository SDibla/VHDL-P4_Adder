library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

-- PG_Network is the network that will every single p and g term
-- that will feed the first row of P blocks (with one G block)
entity PG_Network is
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		p:	out	std_logic;
		g:	Out	std_logic);
end PG_Network;

architecture BEHAVIORAL of PG_Network is
begin
	-- generation of p and g starting from the two input bits
	p <= A xor B;
	g <= A and B; 

end architecture BEHAVIORAL;
 
