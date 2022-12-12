library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_clock_divider is
	generic (
		g_DIVIDE_FACTOR	: integer := 10E3
	);
	port (
		i_clk	: in std_logic;
		i_rst	: in std_logic;
		o_clk	: out std_logic := '0'
	);
end entity data_clock_divider;

architecture RTL of data_clock_divider is

	signal r_Count : integer range 0 to g_DIVIDE_FACTOR/2 - 1 := 0;

begin

	process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			r_Count <= 0;
		elsif rising_edge(i_clk) then
			if r_Count < g_DIVIDE_FACTOR/2 - 1 then
				r_Count <= r_Count + 1;
			else
				r_Count <= 0;
				o_clk <= not o_clk;
			end if;
		end if;
	end process;

end architecture RTL;