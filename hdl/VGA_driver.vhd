library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.VGA_Char_Pkg.all;

entity VGA_driver is
	port (
		i_clk		: in std_logic;
		i_rst		: in std_logic;
		o_buf_sel	: out std_logic := '1';
		o_wr_req	: out t_WR_REQ;
		o_valid		: out std_logic;
		i_ready		: in std_logic;
		i_blank 	: in std_logic;
		
		i_bpm		: in integer range 0 to 999;
		i_ecg_valid	: in std_logic;
		i_ecg		: in std_logic_vector(4 downto 0)
	);
end VGA_driver;

architecture RTL of VGA_driver is
	
	constant c_MESSAGE : string := "MO7 ECG GROUP 2";
	constant c_SECTIONS : integer := 8;
	signal r_Section : integer range 0 to c_SECTIONS := 0;

	signal r_Count : integer := 0;
	type t_MAX is array(0 to c_SECTIONS-1) of integer;
	constant c_MAX : t_MAX := (
		0 => 40,
		1 => 10,
		2 => 28,
		3 => 26,
		4 => c_MESSAGE'length,
		5 => 3,
		6 => 40,
		7 => 80
	);

	type t_BCD is array(2 downto 0) of integer range 0 to 9;
	signal r_BPM : integer range 0 to 999 := 0;
	signal w_BPM_BCD : t_BCD;

	type t_ECG is array(0 to c_H_ACTIVE/8 - 1) of unsigned(4 downto 0);
	signal r_ECG_Staged	: t_ECG := (others => "10000");	--Constantly get updated with new data
	signal r_ECG_Active	: t_ECG := (others => "10000");	--Only get updated before starting new frame

begin

	CONTROLLER : process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			o_valid <= '0';
			r_Section <= 0;
			r_Count <= 0;
		elsif rising_edge(i_clk) then
			if r_Section < c_SECTIONS then
				o_valid <= '1';
				if o_valid = '1' and i_ready = '1' then
					if r_Count < c_MAX(r_Section)-1 then
						r_Count <= r_Count + 1;
					else
						r_Count <= 0;
						r_Section <= r_Section + 1;
					end if;
				end if;
			else
				o_valid <= '0';
				if i_ready = '1' and i_blank  = c_BLANK_POL then
					r_BPM <= i_BPM;
					r_ECG_Active <= r_ECG_Staged;
					o_buf_sel <= not o_buf_sel;
					r_Section <= 0;
				end if;
			end if;
		end if;
	end process;

	DATAPATH : process(r_Section, r_Count, w_BPM_BCD, r_ECG_Active)
	begin
		case r_Section  is
		when 0 =>
			o_wr_req.sel <= 43;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= r_Count*8;
			o_wr_req.v_addr <= 40;
		when 1 =>
			if r_Count mod 2 = 0 then
				o_wr_req.sel <= 43;
			else
				o_wr_req.sel <= 45;
			end if;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= 320 + (r_Count mod 2)*8;
			o_wr_req.v_addr <= (r_Count / 2)*10;
		when 2 =>
			o_wr_req.sel <= 43;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= 416 + r_Count*8;
			o_wr_req.v_addr <= 120;
		when 3 =>
			if r_Count mod 2 = 0 then
				o_wr_req.sel <= 44;
			else
				o_wr_req.sel <= 43;
			end if;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= 400 + (r_Count mod 2)*8;
			o_wr_req.v_addr <= (r_Count / 2)*10;
		when 4 =>
			if character'pos(c_MESSAGE(r_Count+1)) < X"40" then
				o_wr_req.sel <= character'pos(c_MESSAGE(r_Count+1)) - 48;
			else
				o_wr_req.sel <= character'pos(c_MESSAGE(r_Count+1)) - 55;
			end if;
			o_wr_req.scale <= 1;
			o_wr_req.h_addr <= 16 + r_Count*16;
			o_wr_req.v_addr <= 10;
		when 5 =>
			o_wr_req.sel <= w_BPM_BCD(2-r_Count);
			o_wr_req.scale <= 3;
			o_wr_req.h_addr <= 432 + r_Count*64;
			o_wr_req.v_addr <= 20;
		when 6 =>
			o_wr_req.sel <= 46;
			o_wr_req.scale <= 3;
			o_wr_req.h_addr <= (r_Count mod 10)*64;
			o_wr_req.v_addr <= 150 + (r_Count / 10)*80;
		when 7 =>
			o_wr_req.sel <= 43;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= r_Count*8;
			o_wr_req.v_addr <= 150 + (31 - to_integer(r_ECG_Active(r_Count)) )*10;
		when others =>
			o_wr_req.sel <= 0;
			o_wr_req.scale <= 0;
			o_wr_req.h_addr <= 0;
			o_wr_req.v_addr <= 0;
		end case;
	end process;

	BPM_2_BCD : process(r_BPM)
		variable v_Inter : integer range 0 to 999;
	begin
		v_Inter := r_BPM;
		for i in 2 downto 0 loop
			w_BPM_BCD(i) <= v_Inter / 10**i;
			v_Inter := v_Inter mod 10**i;
		end loop;
	end process;

	ECG_SHIFT : process(i_clk, i_rst)
	begin
		if i_rst = '1' then
			r_ECG_Staged <= (others => "10000");
		elsif rising_edge(i_clk) then
			if i_ecg_valid = '1' then
				for i in 0 to c_H_ACTIVE/8 - 2 loop
					r_ECG_Staged(i) <= r_ECG_Staged(i+1);
				end loop;
				r_ECG_Staged(c_H_ACTIVE/8 - 1) <= unsigned(i_ecg);
			end if;
		end if;
	end process;

end architecture RTL;