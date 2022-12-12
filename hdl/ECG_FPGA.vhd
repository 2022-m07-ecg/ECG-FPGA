library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.VGA_Char_Pkg.all;
library pll_50_21;

entity ECG_FPGA is
	port (
		--Global ports
		i_clk			: in std_logic;	--50MHz
		i_nrst			: in std_logic;	--Active low
		o_pll_status	: out std_logic;

		--VGA interface
		o_vga_red		: out std_logic_vector(7 downto 0);
		o_vga_green		: out std_logic_vector(7 downto 0);
		o_vga_blue		: out std_logic_vector(7 downto 0);
		o_vga_h_sync	: out std_logic;
		o_vga_v_sync	: out std_logic;
		o_vga_blank		: out std_logic;
		o_vga_clk		: out std_logic
	);
end entity ECG_FPGA;

architecture RTL of ECG_FPGA is

	--VGA signals
	signal w_VGA_Clk		: std_logic;
	signal w_VGA_Pix		: std_logic;
	signal w_VGA_Buf_Sel	: std_logic;
	signal w_VGA_Wr_Req		: t_WR_REQ;
	signal w_VGA_Valid		: std_logic;
	signal w_VGA_Ready		: std_logic;
	signal w_VGA_Blank		: std_logic;

	signal r_BPM	: integer range 0 to 999 := 0;
	signal r_BPM_Count : integer range 0 to 50E6 := 0;

begin

	o_vga_red	<= (others => w_VGA_Pix);
	o_vga_green	<= (others => w_VGA_Pix);
	o_vga_blue	<= (others => w_VGA_Pix);
	o_vga_clk	<= w_VGA_Clk;
	o_vga_blank <= w_VGA_Blank;

	process(i_clk, i_nrst)
	begin
		if i_nrst = '0' then
			r_BPM_Count <= 0;
			r_BPM <= 0;
		elsif rising_edge(i_clk) then
			if r_BPM_Count < 50E6 then
				r_BPM_Count <= r_BPM_Count + 1;
			elsif r_BPM < 999 then
				r_BPM_Count <= 0;
				r_BPM <= r_BPM + 1;
			else
				r_BPM_Count <= 0;
				r_BPM <= 0;
			end if;
		end if;
	end process;
	
	INST_PLL_50_21 : entity pll_50_21.PLL_50_21(rtl)
	port map(
		refclk		=> i_clk,
		rst			=> not i_nrst,
		outclk_0	=> w_VGA_Clk,
		locked		=> o_pll_status
	);

	INST_VGA_DRIVER : entity work.VGA_driver(RTL)
	port map (
		i_clk		=> i_clk,
		i_rst		=> not i_nrst,
		o_buf_sel	=> w_VGA_Buf_Sel,
		o_wr_req	=> w_VGA_Wr_Req,
		o_valid		=> w_VGA_Valid,
		i_ready		=> w_VGA_Ready,
		i_blank		=> w_VGA_Blank,
		i_bpm		=> r_BPM,
		i_ecg_valid	=> '0',
		i_ecg		=> (others => '0')
	);

	INST_VGA_CORE : entity work.VGA_core(RTL)
	port map (
		i_wr_clk	=> i_clk,
		i_rd_clk	=> w_VGA_Clk,
		i_rst		=> not i_nrst,
		i_buf_sel	=> w_VGA_Buf_Sel,
		i_wr_req	=> w_VGA_Wr_Req,
		i_valid		=> w_VGA_Valid,
		o_ready		=> w_VGA_Ready,
		o_h_sync	=> o_vga_h_sync,
		o_v_sync	=> o_vga_v_sync,
		o_blank		=> w_VGA_Blank,
		o_pix		=> w_VGA_Pix
	);

end architecture RTL;