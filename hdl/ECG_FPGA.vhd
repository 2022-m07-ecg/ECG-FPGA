library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.VGA_Char_Pkg.all;
library pll;

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
		o_vga_clk		: out std_logic;

		--HPS interface
		o_hps_io_hps_io_emac1_inst_TX_CLK	: out std_logic;
		o_hps_io_hps_io_emac1_inst_TXD0		: out std_logic;
		o_hps_io_hps_io_emac1_inst_TXD1		: out std_logic;
		o_hps_io_hps_io_emac1_inst_TXD2		: out std_logic;
		o_hps_io_hps_io_emac1_inst_TXD3		: out std_logic;
		i_hps_io_hps_io_emac1_inst_RXD0		: in std_logic;
		io_hps_io_hps_io_emac1_inst_MDIO	: inout std_logic;
		o_hps_io_hps_io_emac1_inst_MDC		: out std_logic;
		i_hps_io_hps_io_emac1_inst_RX_CTL	: in std_logic;
		o_hps_io_hps_io_emac1_inst_TX_CTL	: out std_logic;
		i_hps_io_hps_io_emac1_inst_RX_CLK	: in std_logic;
		i_hps_io_hps_io_emac1_inst_RXD1		: in std_logic;
		i_hps_io_hps_io_emac1_inst_RXD2		: in std_logic;
		i_hps_io_hps_io_emac1_inst_RXD3		: in std_logic;
		io_hps_io_hps_io_qspi_inst_IO0		: inout std_logic;
		io_hps_io_hps_io_qspi_inst_IO1		: inout std_logic;
		io_hps_io_hps_io_qspi_inst_IO2		: inout std_logic;
		io_hps_io_hps_io_qspi_inst_IO3		: inout std_logic;
		o_hps_io_hps_io_qspi_inst_SS0		: out std_logic;
		o_hps_io_hps_io_qspi_inst_CLK		: out std_logic;
		io_hps_io_hps_io_sdio_inst_CMD		: inout std_logic;
		io_hps_io_hps_io_sdio_inst_D0		: inout std_logic;
		io_hps_io_hps_io_sdio_inst_D1		: inout std_logic;
		o_hps_io_hps_io_sdio_inst_CLK		: out std_logic;
		io_hps_io_hps_io_sdio_inst_D2		: inout std_logic;
		io_hps_io_hps_io_sdio_inst_D3		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D0		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D1		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D2		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D3		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D4		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D5		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D6		: inout std_logic;
		io_hps_io_hps_io_usb1_inst_D7		: inout std_logic;
		i_hps_io_hps_io_usb1_inst_CLK		: in std_logic;
		o_hps_io_hps_io_usb1_inst_STP		: out std_logic;
		i_hps_io_hps_io_usb1_inst_DIR		: in std_logic;
		i_hps_io_hps_io_usb1_inst_NXT		: in std_logic;
		o_hps_io_hps_io_spim1_inst_CLK		: out std_logic;
		o_hps_io_hps_io_spim1_inst_MOSI		: out std_logic;
		i_hps_io_hps_io_spim1_inst_MISO		: in std_logic;
		o_hps_io_hps_io_spim1_inst_SS0		: out std_logic;
		i_hps_io_hps_io_uart0_inst_RX		: in std_logic;
		o_hps_io_hps_io_uart0_inst_TX		: out std_logic;
		io_hps_io_hps_io_i2c0_inst_SDA		: inout std_logic;
		io_hps_io_hps_io_i2c0_inst_SCL		: inout std_logic;
		io_hps_io_hps_io_i2c1_inst_SDA		: inout std_logic;
		io_hps_io_hps_io_i2c1_inst_SCL		: inout std_logic;
		o_memory_mem_a						: out std_logic_vector(14 downto 0);
		o_memory_mem_ba						: out std_logic_vector(2 downto 0);
		o_memory_mem_ck						: out std_logic;
		o_memory_mem_ck_n					: out std_logic;
		o_memory_mem_cke					: out std_logic;
		o_memory_mem_cs_n					: out std_logic;
		o_memory_mem_ras_n					: out std_logic;
		o_memory_mem_cas_n					: out std_logic;
		o_memory_mem_we_n					: out std_logic;
		o_memory_mem_reset_n				: out std_logic;
		io_memory_mem_dq					: inout std_logic_vector(31 downto 0);
		io_memory_mem_dqs					: inout std_logic_vector(3 downto 0);
		io_memory_mem_dqs_n					: inout std_logic_vector(3 downto 0);
		o_memory_mem_odt					: out std_logic;
		o_memory_mem_dm						: out std_logic_vector(3 downto 0);
		i_memory_oct_rzqin					: in std_logic
	);
end entity ECG_FPGA;

architecture RTL of ECG_FPGA is

	constant c_DATA_RATE : integer := 1000;
	constant c_THRESHOLD : unsigned(11 downto 0) := X"800";

	--VGA signals
	signal w_VGA_Clk		: std_logic;
	signal w_VGA_Pix		: std_logic;
	signal w_VGA_Buf_Sel	: std_logic;
	signal w_VGA_Wr_Req		: t_WR_REQ;
	signal w_VGA_Valid		: std_logic;
	signal w_VGA_Ready		: std_logic;
	signal w_VGA_Blank		: std_logic;

	signal w_BPM	: integer range 0 to 999;

	signal w_Data	: std_logic_vector(11 downto 0);
	signal w_Empty	: std_logic;
	signal r_Data_Valid_Delay	: std_logic := '0';
	signal w_Cascade_Clk	: std_logic;
	signal w_Data_Clk	: std_logic;	--Use this as 1kHz input data clock
	signal w_Input_Data : std_logic_vector(11 downto 0);	--Assign filter data to this wire

	component system is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0     : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK     : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			memory_mem_a                    : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                   : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                 : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                  : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                 : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                 : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n              : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                  : out   std_logic;                                        -- mem_odt
			memory_mem_dm                   : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                : in    std_logic                     := 'X';             -- oct_rzqin
			data_input_export               : in    std_logic_vector(12 downto 0) := (others => 'X'); -- export
			reset_reset_n                   : in    std_logic                     := 'X'              -- reset_n
		);
	end component system;

begin

	o_vga_red	<= (others => w_VGA_Pix);
	o_vga_green	<= (others => w_VGA_Pix);
	o_vga_blue	<= (others => w_VGA_Pix);
	o_vga_clk	<= w_VGA_Clk;	
	o_vga_blank <= w_VGA_Blank;

	INST_FIFO : entity work.FIFO(SYN)
	port map (
		aclr => not i_nrst,
		data => w_Input_Data,
		rdclk => i_clk,
		rdreq => '1',
		wrclk => w_Data_Clk,
		wrreq => '1',
		q => w_Data,
		rdempty => w_Empty
	);

	DELAY : process(i_clk)
	begin
		if rising_edge(i_clk) then
			r_Data_Valid_Delay <= not w_Empty;
		end if;
	end process;
	
	INST_PLL : entity pll.PLL(rtl)
	port map (
		refclk		=> i_clk,
		rst			=> not i_nrst,
		outclk_0	=> w_VGA_Clk,
		outclk_1	=> w_Cascade_Clk,
		locked		=> o_pll_status
	);

	INST_DIVIDER : entity work.data_clock_divider(RTL)
	generic map (
		g_DIVIDE_FACTOR => 1E3
	)
	port map (
		i_clk => w_Cascade_Clk,
		i_rst => not i_nrst,
		o_clk => w_Data_Clk
	);

	INST_BPM_CALC : entity work.BPM_calculator(RTL)
	generic map (
		g_DATA_RATE	=> c_DATA_RATE,
		g_THRESHOLD	=> c_THRESHOLD
	)
	port map (
		i_clk	=> i_clk,
		i_rst	=> not i_nrst,
		i_data	=> w_Data,
		i_valid	=> r_Data_Valid_Delay,
		o_bpm	=> w_BPM
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
		i_bpm		=> w_BPM,
		i_ecg_valid	=> r_Data_Valid_Delay,
		i_ecg		=> w_Data(11 downto 7)
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

	u0 : component system
		port map (
			clk_clk							=> i_clk,
			hps_io_hps_io_emac1_inst_TX_CLK	=> o_hps_io_hps_io_emac1_inst_TX_CLK,
			hps_io_hps_io_emac1_inst_TXD0	=> o_hps_io_hps_io_emac1_inst_TXD0,
			hps_io_hps_io_emac1_inst_TXD1	=> o_hps_io_hps_io_emac1_inst_TXD1,
			hps_io_hps_io_emac1_inst_TXD2	=> o_hps_io_hps_io_emac1_inst_TXD2,
			hps_io_hps_io_emac1_inst_TXD3	=> o_hps_io_hps_io_emac1_inst_TXD3,
			hps_io_hps_io_emac1_inst_RXD0	=> i_hps_io_hps_io_emac1_inst_RXD0,
			hps_io_hps_io_emac1_inst_MDIO	=> io_hps_io_hps_io_emac1_inst_MDIO,
			hps_io_hps_io_emac1_inst_MDC	=> o_hps_io_hps_io_emac1_inst_MDC,
			hps_io_hps_io_emac1_inst_RX_CTL	=> i_hps_io_hps_io_emac1_inst_RX_CTL,
			hps_io_hps_io_emac1_inst_TX_CTL	=> o_hps_io_hps_io_emac1_inst_TX_CTL,
			hps_io_hps_io_emac1_inst_RX_CLK	=> i_hps_io_hps_io_emac1_inst_RX_CLK,
			hps_io_hps_io_emac1_inst_RXD1	=> i_hps_io_hps_io_emac1_inst_RXD1,
			hps_io_hps_io_emac1_inst_RXD2	=> i_hps_io_hps_io_emac1_inst_RXD2,
			hps_io_hps_io_emac1_inst_RXD3	=> i_hps_io_hps_io_emac1_inst_RXD3,
			hps_io_hps_io_qspi_inst_IO0		=> io_hps_io_hps_io_qspi_inst_IO0,
			hps_io_hps_io_qspi_inst_IO1		=> io_hps_io_hps_io_qspi_inst_IO1,
			hps_io_hps_io_qspi_inst_IO2		=> io_hps_io_hps_io_qspi_inst_IO2,
			hps_io_hps_io_qspi_inst_IO3		=> io_hps_io_hps_io_qspi_inst_IO3,
			hps_io_hps_io_qspi_inst_SS0		=> o_hps_io_hps_io_qspi_inst_SS0,
			hps_io_hps_io_qspi_inst_CLK		=> o_hps_io_hps_io_qspi_inst_CLK,
			hps_io_hps_io_sdio_inst_CMD		=> io_hps_io_hps_io_sdio_inst_CMD,
			hps_io_hps_io_sdio_inst_D0		=> io_hps_io_hps_io_sdio_inst_D0,
			hps_io_hps_io_sdio_inst_D1		=> io_hps_io_hps_io_sdio_inst_D1,
			hps_io_hps_io_sdio_inst_CLK		=> o_hps_io_hps_io_sdio_inst_CLK,
			hps_io_hps_io_sdio_inst_D2		=> io_hps_io_hps_io_sdio_inst_D2,
			hps_io_hps_io_sdio_inst_D3		=> io_hps_io_hps_io_sdio_inst_D3,
			hps_io_hps_io_usb1_inst_D0		=> io_hps_io_hps_io_usb1_inst_D0,
			hps_io_hps_io_usb1_inst_D1		=> io_hps_io_hps_io_usb1_inst_D1,
			hps_io_hps_io_usb1_inst_D2		=> io_hps_io_hps_io_usb1_inst_D2,
			hps_io_hps_io_usb1_inst_D3		=> io_hps_io_hps_io_usb1_inst_D3,
			hps_io_hps_io_usb1_inst_D4		=> io_hps_io_hps_io_usb1_inst_D4,
			hps_io_hps_io_usb1_inst_D5		=> io_hps_io_hps_io_usb1_inst_D5,
			hps_io_hps_io_usb1_inst_D6		=> io_hps_io_hps_io_usb1_inst_D6,
			hps_io_hps_io_usb1_inst_D7		=> io_hps_io_hps_io_usb1_inst_D7,
			hps_io_hps_io_usb1_inst_CLK		=> i_hps_io_hps_io_usb1_inst_CLK,
			hps_io_hps_io_usb1_inst_STP		=> o_hps_io_hps_io_usb1_inst_STP,
			hps_io_hps_io_usb1_inst_DIR		=> i_hps_io_hps_io_usb1_inst_DIR,
			hps_io_hps_io_usb1_inst_NXT		=> i_hps_io_hps_io_usb1_inst_NXT,
			hps_io_hps_io_spim1_inst_CLK	=> o_hps_io_hps_io_spim1_inst_CLK,
			hps_io_hps_io_spim1_inst_MOSI	=> o_hps_io_hps_io_spim1_inst_MOSI,
			hps_io_hps_io_spim1_inst_MISO	=> i_hps_io_hps_io_spim1_inst_MISO,
			hps_io_hps_io_spim1_inst_SS0	=> o_hps_io_hps_io_spim1_inst_SS0,
			hps_io_hps_io_uart0_inst_RX		=> i_hps_io_hps_io_uart0_inst_RX,
			hps_io_hps_io_uart0_inst_TX		=> o_hps_io_hps_io_uart0_inst_TX,
			hps_io_hps_io_i2c0_inst_SDA		=> io_hps_io_hps_io_i2c0_inst_SDA,
			hps_io_hps_io_i2c0_inst_SCL		=> io_hps_io_hps_io_i2c0_inst_SCL,
			hps_io_hps_io_i2c1_inst_SDA		=> io_hps_io_hps_io_i2c1_inst_SDA,
			hps_io_hps_io_i2c1_inst_SCL		=> io_hps_io_hps_io_i2c1_inst_SCL,
			memory_mem_a					=> o_memory_mem_a,
			memory_mem_ba					=> o_memory_mem_ba,
			memory_mem_ck					=> o_memory_mem_ck,
			memory_mem_ck_n					=> o_memory_mem_ck_n,
			memory_mem_cke					=> o_memory_mem_cke,
			memory_mem_cs_n					=> o_memory_mem_cs_n,
			memory_mem_ras_n				=> o_memory_mem_ras_n,
			memory_mem_cas_n				=> o_memory_mem_cas_n,
			memory_mem_we_n					=> o_memory_mem_we_n,
			memory_mem_reset_n				=> o_memory_mem_reset_n,
			memory_mem_dq					=> io_memory_mem_dq,
			memory_mem_dqs					=> io_memory_mem_dqs,
			memory_mem_dqs_n				=> io_memory_mem_dqs_n,
			memory_mem_odt					=> o_memory_mem_odt,
			memory_mem_dm					=> o_memory_mem_dm,
			memory_oct_rzqin				=> i_memory_oct_rzqin,
			data_input_export				=> w_Data & r_Data_Valid_Delay,
			reset_reset_n					=> i_nrst
		);

end architecture RTL;