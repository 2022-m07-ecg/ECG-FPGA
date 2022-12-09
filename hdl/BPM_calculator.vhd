library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BPM_calculator is
	generic (
		g_CLK_PERIOD	: integer := 6667;
		g_THRESHOLD		: unsigned(11 downto 0) := "100000000000"
	);
	port (
		i_clk	: in std_logic;
		i_rst	: in std_logic;
		i_data	: in std_logic_vector(11 downto 0);
		o_bpm	: out integer range 0 to 999
	);
end BPM_calculator;

architecture RTL of BPM_calculator is

	signal r_Count	: integer := 0;
	signal r_State	: integer range 0 to 2 := 0;
	signal r_Max	: unsigned(11 downto 0) := (others => '0');

begin

	BPM : process(i_clk)
		variable v_Data	: unsigned(11 downto 0);
	begin
		if i_rst = '1' then
			r_Count <= 0;
			r_State <= 0;
		elsif rising_edge(i_clk) then
			v_Data := unsigned(i_data);
			r_Count <= r_Count + 1;
			case r_State is
			when 0 =>
				if v_Data > g_THRESHOLD then
					r_State <= 1;
					r_Max <= v_Data;
				end if;
			when 1 =>
				if v_Data > r_Max then
					r_Max <= v_Data;
				else
					r_State <= 2;
					o_bpm <= 60 / (r_Count*g_CLK_PERIOD/1E6);
					r_Count <= 0;
				end if;
			when 2 =>
				if v_Data < g_THRESHOLD then
					r_State <= 0;
				end if;
			end case;
		end if;
	end process;

end architecture RTL;