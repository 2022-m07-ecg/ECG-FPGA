library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity input_sim is
	port (
		i_clk	: in std_logic;
		i_rst	: in std_logic;
		o_data	: out std_logic_vector(11 downto 0)
	);
end input_sim;

architecture RTL of input_sim is

	signal r_Address : integer range 0 to 149 := 0;

begin

	ROM_READ : process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			r_Address <= 0;
		elsif rising_edge(i_clk) then
			if r_Address < 149 then
				r_Address <= r_Address + 1;
			else
				r_Address <= 0;
			end if;
		end if;
	end process;

	INST_ROM : entity work.ROM(SYN)
	port map (
		address => std_logic_vector(to_unsigned(r_Address, 8)),
		clock => i_clk,
		q => o_data
	);

end architecture;