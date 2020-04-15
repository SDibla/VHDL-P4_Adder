library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

-- entity of the Ripple Carry Adder that will be used as a component of the CSA block
entity RCA is 
	generic (n: integer);
	Port (	A:	In	std_logic_vector(n-1 downto 0);
		B:	In	std_logic_vector(n-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(n-1 downto 0);
		Co:	Out	std_logic);
end RCA; 

-- structural architecture that uses a generate statement to generate as many Full Adders as needed by the adder
architecture STRUCTURAL of RCA is
  signal STMP : std_logic_vector(n-1 downto 0);
  signal CTMP : std_logic_vector(n downto 0);

  component FA 
	port ( A:	In	std_logic;
		B:	In	std_logic;
		Ci:	In	std_logic;
		S:	Out	std_logic;
		Co:	Out	std_logic);
  end component; 

begin

  CTMP(0) <= Ci;
  S <= STMP;
  Co <= CTMP(n);  
  -- generate statement that generates FAs in such a way that the carry-out of one FA is the carry-in of the following one
  ADDER1: for I in 1 to n generate
    FAI : FA 
	  port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;
	
end STRUCTURAL;

