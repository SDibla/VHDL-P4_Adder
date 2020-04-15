library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

-- Sparse Tree entity that generates the c_out signal that will feed the Sum_Generator as carry in.
-- This component generates a carry every NBIT_PER_BLOCK bits and has two operands which are on NBIT bits.
-- The component is generic but it has been chosen to allow only numbers which are 2^n, with any n, for both NBIT and NBIT_PER_BLOCK
entity CLA_carry_generator is
	generic(NBIT: integer;
			NBIT_PER_BLOCK: integer);
	port( a: in std_logic_vector(NBIT downto 1);
		  b: in std_logic_vector(NBIT downto 1);
		  c_in: in std_logic;
		  c_out: out std_logic_vector((NBIT/NBIT_PER_BLOCK) downto 0));
end CLA_carry_generator;

architecture structural of CLA_carry_generator is

--
constant NLEVELS_1: integer := log2(NBIT_PER_BLOCK);
constant NLEVELS_2: integer := log2(NBIT)-log2(NBIT_PER_BLOCK);

-- array of std_logic_vector that is used for signals G and P, with their indexes that match the ones 
-- in the actual relationships among G(i, j), P(i, j), G(i, k), G(i, k), P(k-1, j) and G(k-1, j)
type SignalVector is array (NBIT downto 1) of std_logic_vector(NBIT downto 1);

signal G: SignalVector;
signal P: SignalVector;

signal gi: std_logic_vector(NBIT downto 1);
signal pi: std_logic_vector(NBIT downto 1);


component PG_Network
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		p:	out	std_logic;
		g:	Out	std_logic);
end component;

component G_BLOCK
	Port (	p_ik:	In	std_logic;
		g_ik:	In	std_logic;
		g_k1j:	In	std_logic;
		g_ij:	out	std_logic);
end component;

component PG 
	Port (	p_ik:	In	std_logic;
		g_ik:	In	std_logic;
		p_k1j:	In	std_logic;
		g_k1j:	In	std_logic;
		p_ij:	out	std_logic;
		g_ij:	out	std_logic);
end component;


begin 

-- generating the PG Network with the signals pi and gi that represent both P(i,i) and G(i,i). They will be assigned later
PG_NET: for i in 1 to NBIT generate -- 2
	NetWork: PG_Network port map( A => a(i), B => b(i), p => pi(i), g => gi(i));
end generate;

-- the first bit of c_out is equal to c_in
c_out(0) <= c_in;
-- G(1,1) is calculated in order to take into account also the possible carry in
G(1)(1) <= (c_in and pi(1)) or gi(1);

-- assigning pi(i) and g(i) to P(i, i) and G(i, i)
assign: for i in 2 to NBIT generate
	P(i)(i) <= pi(i);
	G(i)(i) <= gi(i);
end generate;

-- For the first NLEVELS_1 (which in the case of 32 bits with a c_out every 4 is log2(4) = 2) the following generate statements have been used.
-- On the other hand, for the remaining NLEVELS_2 levels, another alghorithm has been found because a different behaviour has been detected.
-- For this first part, the block on the next level has always two "adjacent" blocks on the level before as "parents". For the second part it is not like
-- that and the behaviour will be explained then

-- Going through each level
E: for level in 1 to NLEVELS_1 generate
	-- Going through all the NBIT bits
	G0: for i in 1 to NBIT generate
			-- if the index i is equal to 2^level, a G block is needed
			FIRST: if i = 2**level generate
					-- as regards the ports of G_BLOCK, each one represents also the indexes in the actual relation: g_ik stands for G(i, k),
					-- so they are substituted with the values of G and P that have the right indexes for the formula. i = i, k = i-2**(level-1)+1
					-- and j = i-2**level+1. All indexes have been derived as functions of only i and level
					first_G: G_BLOCK port map(p_ik => P(i)(i-2**(level-1)+1), g_ik => G(i)(i-2**(level-1)+1), g_k1j => G(i-2**(level-1))(1), g_ij => G(i)(i-2**level+1));
			end generate;
			
			-- if the remainder of the division of the index i and 2^level is zero, and also i is different from 2^level (which is the case evaluated before)
			-- it means that a PG block is needed. This allows the generation of a PG block that "connects" two adjacent blocks of the previous level.
			-- i, k and j indexes are the same as the G block case
			PGi: if (i mod 2**level = 0) and ((i > 2**level) or (i < 2**level)) generate 
				first_PG: PG port map(p_ik => P(i)(i-2**(level-1)+1), g_ik => G(i)(i-2**(level-1)+1),
								  p_k1j => P(i-2**(level-1))(i-2**level+1), g_k1j => G(i-2**(level-1))(i-2**level+1),
								  p_ij => P(i)(i-2**level+1) , g_ij => G(i)(i-2**level+1));
			end generate;
			
		end generate;
end generate;

-- the bit 1 of c-out has already been evaluated and it corresponds to G(NBIT_PER_BLOCK)(1), in the case of the pentium4 adder it will be G(4, 1)
c_out(1) <= G(NBIT_PER_BLOCK)(1);

-- now we got all G(NBIT/NBIT_PER_BLOCK*i, NBIT/NBIT_PER_BLOCK*(i-1) + 1) and P(NBIT/NBIT_PER_BLOCK*i)(NBIT/NBIT_PER_BLOCK*(i-1) + 1)
-- that is to say for example: G(4)(1), G(8)(5), G(12)(9). The carry out are to be calculated from this point, where the second alghorithm starts.
-- The alghorithm identifies a main "root" or "parent" in one level and its "leaves" or "children" in the following one, with the indexes i, k and j
-- derived as it will be shown 

-- Going through levels
EE: for level in 0 to NLEVELS_2-1 generate
	-- Going through all the NBIT bits
	G1: for i in NBIT_PER_BLOCK to NBIT generate
		-- identification of the "parent": if the remainder of the division between i and NBIT_PER_BLOCK*(2^level) is zero AND i is equal
		-- to NBIT_PER_BLOCK*(2^level) or the division between i and NBIT_PER_BLOCK*(2^level) is an odd number, a parent is present.
		-- For the pentium4 adder, for the first of these levels NBIT_PER_BLOCK*(2^level) = 8, and we have a "root" at i = 8, 24, (40, ecc...)
		ROOT: if (i mod (NBIT_PER_BLOCK*(2**level)) = 0) and (i=(NBIT_PER_BLOCK*(2**level)) or (i/(NBIT_PER_BLOCK*(2**level))) mod 2 > 0) generate
			-- k is the index that allows to go through the level after the one we are right now
			L: for k in i + NBIT_PER_BLOCK to i + NBIT_PER_BLOCK*(2**level) generate
				-- if k is a multiple of NBIT_PER_BLOCK (in this case 4) and the index i is equal to NBIT_PER_BLOCK*(2**level)
				-- (in this case 8, then 16 (32, 64, ecc...)), a G block has to be generated, with the c_out output assigned 
				G2: if k mod NBIT_PER_BLOCK = 0 and i = NBIT_PER_BLOCK*(2**level) generate			
					-- i = k, k = i+1, j = i-NBIT_PER_BLOCK*(2**level)+1
					G_L2: G_BLOCK port map(p_ik => P(k)(i+1), g_ik => G(k)(i+1), g_k1j => G(i)(i-NBIT_PER_BLOCK*(2**level)+1), g_ij => G(k)(i-NBIT_PER_BLOCK*(2**level)+1));	
					c_out(k/NBIT_PER_BLOCK) <= G(k)(i-NBIT_PER_BLOCK*(2**level)+1);
				end generate;
				-- if k is a multiple of NBIT_PER_BLOCK (in this case 4) and the index i is NOT equal to NBIT_PER_BLOCK*(2**level)
				-- a PG block has to be generated
				LEAF: if k mod NBIT_PER_BLOCK = 0 and i > 2**(level+2) generate
						-- i = k, k = i+1, j = i-NBIT_PER_BLOCK*(2**level)+1
						PG_L2: PG port map(p_ik => P(k)(i+1), g_ik => G(k)(i+1),
								  p_k1j => P(i)(i-NBIT_PER_BLOCK*(2**level)+1), g_k1j => G(i)(i-NBIT_PER_BLOCK*(2**level)+1),
								  p_ij => P(k)(i-NBIT_PER_BLOCK*(2**level)+1) , g_ij => G(k)(i-NBIT_PER_BLOCK*(2**level)+1));
				end generate;
				
			end generate;
		end generate;
	end generate;
end generate;

end structural;