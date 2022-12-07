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

	-- constant c_MAX :
	-- type t_QUEUE is array(0 to 100) of t_WR_REQ;
	-- signal r_QUEUE : t_QUEUE;
	signal r_Count : integer := 0;

begin

	process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			o_valid <= '0';
			r_Count <= 0;
		elsif rising_edge(i_clk) then
			if r_Count < 20 then
				o_buf_sel <= '1';
				o_valid <= '1';
				o_wr_req.sel <= 43;
				o_wr_req.scale <= 1;
				o_wr_req.h_addr <= r_Count*16;
				o_wr_req.v_addr <= 40;
				if i_ready = '1' then
					r_Count <= r_Count + 1;
				end if;
			elsif r_Count < 25 then
				o_buf_sel <= '1';
				o_valid <= '1';
				o_wr_req.sel <= 43;
				o_wr_req.scale <= 1;
				o_wr_req.h_addr <= 20*16;
				o_wr_req.v_addr <= (r_Count-20)*20;
				if i_ready = '1' then
					r_Count <= r_Count + 1;
				end if;
			elsif r_Count < 25 then
				o_buf_sel <= '1';
				o_valid <= '1';
				o_wr_req.sel <= 45;
				o_wr_req.scale <= 1;
				o_wr_req.h_addr <= 21*16;
				o_wr_req.v_addr <= (r_Count-25)*20;
				if i_ready = '1' then
					r_Count <= r_Count + 1;
				end if;
			else
				o_valid <= '0';
				o_buf_sel <= '0';
			end if;
		end if;
	end process;

end architecture RTL;