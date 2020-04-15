library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

-- entity of the G block that, starting from one P (P(i,k)) input
-- and two G inputs (G(i,k) and G(k-1,j)), generates one output, G(i,j) 
-- according to the relations below. This block will be used to generate the actual 
-- carry out every NBIT_PER_BLOCK in the P4 Adder
entity G_BLOCK is 
	Port (	p_ik:	In	std_logic;
		g_ik:	In	std_logic;
		g_k1j:	In	std_logic;
		g_ij:	out	std_logic);
end G_BLOCK;

architecture BEHAVIORAL of G_BLOCK is
begin
	-- generation of the output according to the relation of the G block
	g_ij <= g_ik or(p_ik and g_k1j);

end architecture BEHAVIORAL;