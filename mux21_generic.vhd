library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

-- 2 to 1 Multiplexer with generic delay and number of bits entity
entity MUX21_GENERIC is
  	Generic (N: integer);
	Port (	A:	In	std_logic_vector(N-1 downto 0) ; -- A and B are the 2 inputs
			B:	In	std_logic_vector(N-1 downto 0);
			SEL:	In	std_logic;					 -- SEL is the selection signal
			Y:	Out	std_logic_vector(N-1 downto 0)); -- Y is the output
 end MUX21_GENERIC;

-- A process is used to describe the behavioral architecture of the 2-1 mux
architecture BEHAVIOURAL of MUX21_GENERIC is
   begin

    mux: process(A,B,SEL)
	begin
		if SEL='1' then
			Y <= A; --if SEL is equal to '1', the output Y is equal to A
		else
			Y <= B; --if SEL is equal to '0', the output Y is equal to B
		end if;
	end process;
end BEHAVIOURAL;


