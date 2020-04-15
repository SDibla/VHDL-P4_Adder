library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

-- entity of the PG block that, starting from two P (P(i,k) and P(k-1,j)) inputs
-- and two G inputs (G(i,k) and G(k-1,j)), generates two outputs, P(i,j) and G(i,j) 
-- according to the relations below
entity PG is 
	Port (	p_ik:	In	std_logic;
		g_ik:	In	std_logic;
		p_k1j:	In	std_logic;
		g_k1j:	In	std_logic;
		p_ij:	out	std_logic;
		g_ij:	out	std_logic);
end PG;

architecture BEHAVIORAL of PG is
begin
	-- generation of the two outputs according to the relations of the PG block
	p_ij <= p_ik and p_k1j;
	g_ij <= g_ik or (p_ik and g_k1j); 

end architecture BEHAVIORAL;
 
