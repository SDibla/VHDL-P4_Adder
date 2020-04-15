library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

-- generic Sum_Generator block made up of a generic number of CSA blocks (NBLOCKS), created by the generate statement below.
-- the two generic parameters are the number of bit per CSA block and the number of CSA blocks to generate.
-- This entity has two inputs for the operands but also one input (C_in) which contains all the carry_in that will feed each block
-- and that will be provided by the CLA_carry_generator (Sparse Tree)
entity Sum_Generator is
	generic(NBIT_PER_BLOCK: integer;
			NBLOCKS:	integer);
	port(	Cin: in std_logic_vector(NBLOCKS-1 downto 0);
			A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			S: out std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end Sum_Generator;

architecture structural of Sum_Generator is

	
	component CSA_Block
		generic(NBIT: integer);
		port(	A: in std_logic_vector(NBIT-1 downto 0);
				B: in std_logic_vector(NBIT-1 downto 0);
				Cin: in std_logic;
				S: out std_logic_vector(NBIT-1 downto 0));
	end component;

	
	begin
	
	-- every CSA block will have NBIT_PER_BLOCK, with its input operand ranging from (i+1)*NBIT_PER_BLOCK-1 downto i*NBIT_PER_BLOCK.
	-- Hence we have that (i+1)*NBIT_PER_BLOCK-i*NBIT_PER_BLOCK = NBIT_PER_BLOCK which is right. This is valid also for the sum signal
	G0: for i in 0 to NBLOCKS-1 generate
		CSABLOCK: CSA_Block generic map(NBIT => NBIT_PER_BLOCK)
								port map(A => A((i+1)*NBIT_PER_BLOCK-1 downto (i)*NBIT_PER_BLOCK),
										 B => B((i+1)*NBIT_PER_BLOCK-1 downto (i)*NBIT_PER_BLOCK),
										 Cin => Cin(i), S => S((i+1)*NBIT_PER_BLOCK-1 downto (i)*NBIT_PER_BLOCK));
		end generate;
							
end structural;