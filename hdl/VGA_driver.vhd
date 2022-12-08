library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ieee;
use ieee.VGA_Char_Pkg.all;

entity VGA_driver is
	port (
		i_clk		: in std_logic;
		i_rst		: in std_logic;
		o_buf_sel	: out std_logic; 
		o_wr_req	: out t_WR_REQ;
		o_valid		: out std_logic;
		i_ready		: in std_logic;
		i_active	: in std_logic
	);
end VGA_driver;

architecture RTL of VGA_driver is

	constant c_SECTIONS : integer := 1;
	signal r_Section : integer range 0 to c_SECTIONS;

	signal r_Count : integer := 0;
	type t_MAX is array(0 to c_SECTIONS-1) of integer;
	constant c_MAX : t_MAX := (
		0 => 20
	);

begin

	CONTROLLER : process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			o_valid <= '0';
			r_Section <= 0;
			r_Count <= 0;
		elsif rising_edge(i_clk) then
			if i_ready = '1' and r_Section < c_SECTIONS then
				o_valid <= '1';
				o_buf_sel <= '1';
				if r_Count < c_MAX(r_Section) then
					r_Count <= r_Count + 1;
				else
					r_Count <= 0;
					r_Section <= r_Section + 1;
				end if;
			else
				o_valid <= '0';
				o_buf_sel <= '0';
			end if;
		end if;
	end process;

	DATAPATH : process(r_Section, r_Count)
	begin
		case r_Section  is
		when 0 =>
			o_wr_req.sel <= 43;
			o_wr_req.scale <= 1;
			o_wr_req.h_addr <= r_Count*16;
			o_wr_req.v_addr <= 10;
		when 1 =>
			o_wr_req.sel <= 0;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= 0;
			o_wr_req.v_addr <= 0;
		end case;
	end process;

end architecture RTL;