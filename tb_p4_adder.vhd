library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TB_P4_ADDER is
end TB_P4_ADDER;

architecture TEST of TB_P4_ADDER is
	constant NB: integer := 32;  -- substitute with 4 for the other test
	constant NBPB: integer := 4; -- substitute with 2 for the other test
	signal a1, b1, s1: std_logic_vector(NB-1 downto 0);
	signal c_in1, c_out1: std_logic;
	-- P4 component declaration
	component Pentium4_Adder is
	generic(NBIT: integer;
			NBIT_PER_BLOCK: integer);
	port( a: in std_logic_vector(NBIT-1 downto 0);
		  b: in std_logic_vector(NBIT-1 downto 0);
		  c_in: in std_logic;
		  c_out :	out	std_logic;
		  s: out std_logic_vector(NBIT-1 downto 0));
	end component;
	
	
begin
	
	-- process
		-- begin
		
		-- a1 <= "0011";
		-- b1 <= "0110";
		-- c_in1 <= '0';
		
		-- wait for 3 ns;
		
		-- a1 <= "0011";
		-- b1 <= "0110";
		-- c_in1 <= '1';
		
		-- wait for 3 ns;
		
		-- a1 <= "1111";
		-- b1 <= "0001";
		-- c_in1 <= '0';
		
		-- wait for 3 ns;
		
		-- a1 <= "0100";
		-- b1 <= "0011";
		-- c_in1 <= '0';
		
		-- wait for 3 ns;
		
		-- a1 <= "0100";
		-- b1 <= "0011";
		-- c_in1 <= '1';
		
		-- wait for 3 ns;

	-- end process;
	
	
	process
		begin
		
		a1 <= "00110100100100100100111010011011";
		b1 <= "01001001111110010100100101010100";
		c_in1 <= '0';
		
		wait for 3 ns;
		
		a1 <= "00110100100100100100111010011011";
		b1 <= "01001001111110010100100101010100";
		c_in1 <= '1';
		
		wait for 3 ns;
		
		a1 <= "11111111111111111111111111111111";
		b1 <= "00000000000000000000000000000001";
		c_in1 <= '0';
		
		wait for 3 ns;
		
		a1 <= "00100100100110010010011110010111";
		b1 <= "01101101001001010010011110010000";
		c_in1 <= '0';
		
		wait for 3 ns;
		
		a1 <= "00100100100110010010011110010111";
		b1 <= "01101101001001010010011110010000";
		c_in1 <= '1';
		
		wait for 3 ns;

	end process;
	
	P4add: Pentium4_Adder generic map (NBIT => NB, NBIT_PER_BLOCK => NBPB)
							port map(a => a1, b => b1, c_in => c_in1, c_out => c_out1, s => s1);
end TEST;

