library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

-- entity of the Pentium4 Adder which uses a Sum_Generator component and the Sparse Tree.
-- It is generic as regards the number of bits (power of 2) and the number of bits per block (power of two), 
-- that is to say how many bits a carry is generated
entity Pentium4_Adder is 
	generic(NBIT: integer;
			NBIT_PER_BLOCK: integer);
	port( a: in std_logic_vector(NBIT-1 downto 0);
		  b: in std_logic_vector(NBIT-1 downto 0);
		  c_in: in std_logic;
		  c_out :	out	std_logic;
		  s: out std_logic_vector(NBIT-1 downto 0));
end Pentium4_Adder;

architecture structural of Pentium4_Adder is

-- signal that is used to bring the output of the Sparse Tree to the c_in input of the Sum generator
signal c_values: std_logic_vector((NBIT/NBIT_PER_BLOCK) downto 0);

component CLA_carry_generator
	generic(NBIT: integer;
			NBIT_PER_BLOCK: integer);
	port( a: in std_logic_vector(NBIT downto 1);
		  b: in std_logic_vector(NBIT downto 1);
		  c_in: in std_logic;
		  c_out: out std_logic_vector((NBIT/NBIT_PER_BLOCK) downto 0));
end component;

component Sum_Generator
	generic(NBIT_PER_BLOCK: integer;
			NBLOCKS:	integer);
	port(	Cin: in std_logic_vector(NBLOCKS-1 downto 0);
			A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			S: out std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end component;


begin

CLA: CLA_carry_generator generic map(NBIT => NBIT, NBIT_PER_BLOCK => NBIT_PER_BLOCK)
						 port map(a => a, b => b, c_in => c_in, c_out => c_values);
						 
-- only the least significant (NBIT/NBIT_PER_BLOCK)-1 downto 0 bits are used by Sum_Generator because the MSB is already the carry out
SUM: Sum_Generator generic map(NBIT_PER_BLOCK => NBIT_PER_BLOCK, NBLOCKS => (NBIT/NBIT_PER_BLOCK))
				   port map(Cin => c_values((NBIT/NBIT_PER_BLOCK)-1 downto 0), S => s, A => a, B => b);
				   
c_out <= c_values((NBIT/NBIT_PER_BLOCK));

end structural;