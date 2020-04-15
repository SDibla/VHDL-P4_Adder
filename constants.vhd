package CONSTANTS is
	constant IVDELAY : time := 0.1 ns;
	constant NDDELAY : time := 0.2 ns;
	constant NDDELAYRISE : time := 0.6 ns;
	constant NDDELAYFALL : time := 0.4 ns;
	constant NRDELAY : time := 0.2 ns;
	constant DRCAS : time := 1 ns;
	constant DRCAC : time := 2 ns;
	constant NumBit : integer := 4;	
	constant TP_MUX : time := 0.5 ns;

	function log2( i : integer) return integer;
	
end package CONSTANTS;

package body CONSTANTS is
	
	function log2( i : integer) return integer is
		variable temp    : integer := i;
		variable ret_val : integer := 1; 
	begin
		while temp > 2 loop
			ret_val := ret_val + 1;
			temp    := temp / 2;
		end loop;
		return ret_val;
	end function log2;

end package body CONSTANTS;