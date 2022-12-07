library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use ieee.VGA_Char_Pkg.all;

entity VGA_driver is
	port (
		i_clk	: in std_logic;
		
		o_wr_req	: out t_WR_REQ;
		o_valid		: out std_logic;
		i_ready		: in std_logic;
		i_active	: in std_logic
	);
end VGA_driver;

architecture RTL of VGA_driver is

begin



end architecture;