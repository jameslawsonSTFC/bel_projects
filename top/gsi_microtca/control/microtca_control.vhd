library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.monster_pkg.all;

entity microtca_control is
  port(
    clk_20m_vcxo_i      : in std_logic;  -- 20MHz VCXO clock
--    clk_125m_wrpll_0_i  : in std_logic;  -- 125 MHz PLL reference
--    clk_125m_wrpll_1_i  : in std_logic;  -- 125 MHz PLL reference
--    clk_osc_0_i         : in std_logic;  -- local clk from 100MHz or 125Mhz oscillator
--    clk_osc_1_i         : in std_logic;  -- local clk from 100MHz or 125Mhz oscillator

    clk_125m_pllref_i : in std_logic; -- 125 MHz PLL reference - (clk_125m_wrpll_0  on schl)
    clk_125m_local_i  : in std_logic; -- local clk from 125Mhz oszillator (clk_osc_1  on sch)
    sfp234_ref_clk_i  : in std_logic; -- SFP clk (clk_125m_wrpll_1 on sch)
    lvtclk_i          : in std_logic; -- LEMO front panel input

    clk_125m_wrpll_i  : in std_logic; -- optional second clock from WR PLL
    
    -----------------------------------------
    -- PCI express pins
    -----------------------------------------
    pcie_clk_i     : in  std_logic;
    pcie_rx_i      : in  std_logic_vector(3 downto 0);
    pcie_tx_o      : out std_logic_vector(3 downto 0);
    
    ------------------------------------------------------------------------
    -- WR DAC signals
    ------------------------------------------------------------------------
    wr_dac_sclk_o  : out std_logic;
    wr_dac_din_o   : out std_logic;
    wr_ndac_cs_o   : out std_logic_vector(2 downto 1);
    
    -----------------------------------------------------------------------
    -- OneWire
    -----------------------------------------------------------------------
    rom_data        : inout std_logic;
    
    -----------------------------------------------------------------------
    -- lcd display
    -----------------------------------------------------------------------
    dis_di_o        : out std_logic_vector(6 downto 0);
    dis_ai_i        : in  std_logic_vector(1 downto 0);
    dis_do_i        : in  std_logic;
    dis_wr_o        : out std_logic := '0';
    dis_rst_o       : out std_logic := '1';
    
    -----------------------------------------------------------------------
    -- connector cpld
    -----------------------------------------------------------------------
    con             : out std_logic_vector(5 downto 1);
    
    -----------------------------------------------------------------------
    -- io
    -----------------------------------------------------------------------
    fpga_res        : in std_logic;
    nres            : in std_logic;
    pbs_f_i         : in std_logic;
    hswf_i          : in std_logic_vector(3 downto 0);
    

    hpwck           : out   std_logic;
    hpw             : inout std_logic_vector(15 downto 0) := (others => 'Z'); -- logic analyzer
    
    -----------------------------------------------------------------------
    -- lvds/lvttl lemos on front panel
    -----------------------------------------------------------------------
    lvtio_in_n_i     : in  std_logic_vector(5 downto 1);
    lvtio_in_p_i     : in  std_logic_vector(5 downto 1);
    lvtio_out_n_o    : out std_logic_vector(5 downto 1);
    lvtio_out_p_o    : out std_logic_vector(5 downto 1);
    lvtio_oe_n_o      : out std_logic_vector(5 downto 1);
    lvtio_term_en_o  : out std_logic_vector(5 downto 1);
    lvtio_led_act_o  : out std_logic_vector(5 downto 1);
    lvtio_led_dir_o  : out std_logic_vector(5 downto 1);

    -- clock input
    lvtclk_in_en_o   : out std_logic;

    -----------------------------------------------------------------------
    -- lvds/lvds libera triggers on backplane
    -----------------------------------------------------------------------
    lib_trig_n_o        : out std_logic_vector(3 downto 0);
    lib_trig_p_o        : out std_logic_vector(3 downto 0);
    lib_trig_oe_o       : out std_logic;

    -----------------------------------------------------------------------
    -- lvds/m-lvds microTCA.4 triggers, gates, clocks on backplane
    -----------------------------------------------------------------------
    mlvdio_in_n_i     : in  std_logic_vector(8 downto 1);
    mlvdio_in_p_i     : in  std_logic_vector(8 downto 1);
    mlvdio_out_n_o    : out std_logic_vector(8 downto 1);
    mlvdio_out_p_o    : out std_logic_vector(8 downto 1);
    mlvdio_oe_o       : out std_logic_vector(8 downto 1);
    mlvdio_fsen_o     : out std_logic_vector(8 downto 1);
    mlvdio_pdn_o      : out std_logic; -- output buffer powerdown, active low

    -----------------------------------------------------------------------
    -- lvds/lvds microTCA.4 backplane clocks
    -----------------------------------------------------------------------
    tclk_in_n_i      : in  std_logic_vector(4 downto 1);
    tclk_in_p_i      : in  std_logic_vector(4 downto 1);
    tclk_out_n_o     : out std_logic_vector(4 downto 1);
    tclk_out_p_o     : out std_logic_vector(4 downto 1);
    tclk_oe_o        : out std_logic_vector(4 downto 1);

    -----------------------------------------------------------------------
    -- mmc
    -----------------------------------------------------------------------
		mmc_spi0_sck_i	      : in  std_logic;
		mmc_spi0_miso_o 	    : out std_logic;
		mmc_spi0_mosi_i 	    : in  std_logic;
		mmc_spi0_sel_fpga_n_i : in  std_logic;

 		mmc_pcie_en_i	        : in  std_logic;
--    mmc_pcie_rst_n_i      : in  std_logic;

		mmc2fpga_usr_i	      : in  std_logic_vector(2 downto 1);
		fpga2mmc_int_o	      : out std_logic;


    -----------------------------------------------------------------------
    -- usb
    -----------------------------------------------------------------------
    slrd            : out   std_logic;
    slwr            : out   std_logic;
    fd              : inout std_logic_vector(7 downto 0) := (others => 'Z');
    pa              : inout std_logic_vector(7 downto 0) := (others => 'Z');
    ctl             : in    std_logic_vector(2 downto 0);
    uclk            : in    std_logic;
    ures            : out   std_logic;
    ifclk           : out   std_logic;
    
    -----------------------------------------------------------------------
    -- leds (6 LEDs for WR and FTRN status)
    -----------------------------------------------------------------------
    led_status      : out std_logic_vector(6 downto 1) := (others => '0');
    led_user        : out std_logic_vector(8 downto 1) := (others => '0');
    
    -----------------------------------------------------------------------
    -- SFP 
    -----------------------------------------------------------------------
   
    sfp_tx_dis_o     : out std_logic := '0';
    sfp_tx_fault_i   : in std_logic;
    sfp_los_i        : in std_logic;
    
    sfp_txp_o        : out std_logic;
    sfp_rxp_i        : in  std_logic;
    
    sfp_mod0         : in    std_logic;  -- grounded by module
    sfp_mod1         : inout std_logic;  -- SCL
    sfp_mod2         : inout std_logic); -- SDA
    
end microtca_control;

architecture rtl of microtca_control is

  -- white rabbits leds
  signal led_link_up  : std_logic;
  signal led_link_act : std_logic;
  signal led_track    : std_logic;
  signal led_pps      : std_logic;
  
  -- front end leds
  signal s_led_frnt_red  : std_logic;
  signal s_led_frnt_blue : std_logic;
  
  -- user leds (on board)
  signal s_leds_user : std_logic_vector(3 downto 0);
  
  -- lvds
--  signal s_lvds_p_i     : std_logic_vector(12 downto 0);
--  signal s_lvds_n_i     : std_logic_vector(12 downto 0);
--  signal s_lvds_i_led   : std_logic_vector(12 downto 0);
--  signal s_lvds_p_o     : std_logic_vector(16 downto 0);
--  signal s_lvds_n_o     : std_logic_vector(16 downto 0);
--  signal s_lvds_o_led   : std_logic_vector(16 downto 0);
--  signal s_lvds_oen     : std_logic_vector(12 downto 0);

  signal s_lvds_p_i     : std_logic_vector(11 downto 0);
  signal s_lvds_n_i     : std_logic_vector(11 downto 0);
  signal s_lvds_i_led   : std_logic_vector(11 downto 0);
  signal s_lvds_p_o     : std_logic_vector(11 downto 0);
  signal s_lvds_n_o     : std_logic_vector(11 downto 0);
  signal s_lvds_o_led   : std_logic_vector(11 downto 0);
  signal s_lvds_oen     : std_logic_vector(11 downto 0);


  signal s_pcie_rx      : std_logic_vector(3 downto 0);
  signal s_pcie_tx      : std_logic_vector(3 downto 0);

  
  constant c_family  : string := "Arria V"; 
  constant c_project : string := "microtca_control";
  constant c_initf   : string := c_project & ".mif"; 
  -- projectname is standard to ensure a stub mif that prevents unwanted scanning of the bus 
  -- multiple init files for n processors are to be seperated by semicolon ';'


  signal s_mmc_spi_clk        : std_logic_vector(2 downto 0);
  signal s_mmc_spi_mosi       : std_logic_vector(1 downto 0);
  signal s_mmc_spi_sel_fpga_n : std_logic_vector(2 downto 0);

  signal s_mmc_spi_clk_re         : std_logic;
  signal s_mmc_spi_sel_fpga_n_re  : std_logic;
        
  signal s_mmc_spi_shift_reg      : std_logic_vector(15 downto 0);
       
  signal s_mtca4_trig_oe_reg      : std_logic_vector(8 downto 1);
  signal s_mtca4_trig_pdn_reg     : std_logic;
  signal s_mtca4_clk_oe_reg       : std_logic_vector(4 downto 1);
  signal s_libera_trig_oe_reg     : std_logic;

  signal s_rstn_mmc_spi           : std_logic;
  signal s_clk_mmc_spi            : std_logic;
  
begin

  main : monster
    generic map(
      g_family      => c_family,
      g_project     => c_project,
      g_flash_bits  => 25,
      g_gpio_out    => 6,  -- 2xfront end+4xuser leds
      g_lvds_inout  => 12, -- front end lemos + MicroTCA.4 backplane triggers + Libera triggers (5 + 8) FIXME : need one more !!!
--      g_lvds_out    => 4,  -- Libera bacplane triggers (4) 
      g_lvds_invert => true,
      g_en_pcie     => true,
      g_en_usb      => true,
      g_en_lcd      => true,
      g_lm32_init_files => c_initf
    )
    port map(
      core_clk_20m_vcxo_i    => clk_20m_vcxo_i,
      core_clk_125m_pllref_i => clk_125m_pllref_i,
      core_clk_125m_sfpref_i => sfp234_ref_clk_i,
      core_clk_125m_local_i  => clk_125m_local_i,
      core_rstn_i            => pbs_f_i,

      core_clk_butis_t0_o    => s_clk_mmc_spi,
      core_rstn_butis_o      => s_rstn_mmc_spi,

      wr_onewire_io          => rom_data,
      wr_sfp_sda_io          => sfp_mod2,
      wr_sfp_scl_io          => sfp_mod1,
      wr_sfp_det_i           => sfp_mod0,
      wr_sfp_tx_o            => sfp_txp_o,
      wr_sfp_rx_i            => sfp_rxp_i,
      wr_dac_sclk_o          => wr_dac_sclk_o,
      wr_dac_din_o           => wr_dac_din_o,
      wr_ndac_cs_o           => wr_ndac_cs_o,

      gpio_o(5 downto 2)     => s_leds_user(3 downto 0),
      gpio_o(1)              => s_led_frnt_blue,
      gpio_o(0)              => s_led_frnt_red,

      lvds_p_i               => s_lvds_p_i,
      lvds_n_i               => s_lvds_n_i,
      lvds_i_led_o           => s_lvds_i_led,
      lvds_p_o               => s_lvds_p_o,
      lvds_n_o               => s_lvds_n_o,
      lvds_o_led_o           => s_lvds_o_led,
      lvds_oen_o             => s_lvds_oen,

      led_link_up_o          => led_link_up,
      led_link_act_o         => led_link_act,
      led_track_o            => led_track,
      led_pps_o              => led_pps,

      pcie_refclk_i          => pcie_clk_i,
      pcie_rstn_i            => mmc_pcie_en_i,
      pcie_rx_i              => pcie_rx_i,
      pcie_tx_o              => pcie_tx_o,

      usb_rstn_o             => ures,
      usb_ebcyc_i            => pa(3),
      usb_speed_i            => pa(0),
      usb_shift_i            => pa(1),
      usb_readyn_io          => pa(7),
      usb_fifoadr_o          => pa(5 downto 4),
      usb_sloen_o            => pa(2),
      usb_fulln_i            => ctl(1),
      usb_emptyn_i           => ctl(2),
      usb_slrdn_o            => slrd,
      usb_slwrn_o            => slwr,
      usb_pktendn_o          => pa(6),
      usb_fd_io              => fd,

      lcd_scp_o              => dis_di_o(3),
      lcd_lp_o               => dis_di_o(1),
      lcd_flm_o              => dis_di_o(2),
      lcd_in_o               => dis_di_o(0));

  sfp_tx_dis_o <= '0'; -- SFP always enabled

  -- pcie lane 0 
  -- s_pcie_rx(0)          <= pcie_rx_i;
  -- s_pcie_rx(3 downto 1) <= (others => '0');
  -- pcie_tx_o             <= s_pcie_tx(0);


  -- Link LEDs
  dis_wr_o    <= '0';
  dis_rst_o   <= '1';
  dis_di_o(5) <= '0' when (not led_link_up)                   = '1' else 'Z'; -- red
  dis_di_o(6) <= '0' when (    led_link_up and not led_track) = '1' else 'Z'; -- blue
  dis_di_o(4) <= '0' when (    led_link_up and     led_track) = '1' else 'Z'; -- green

  -- Front end: 6 LEDs for WR and FTRN status (from left to right: red, blue, green, white, red, blue)
  led_status(1) <= not (led_link_act and led_link_up); -- red   = traffic/no-link
  led_status(2) <= not led_link_up;                    -- blue  = link
  led_status(3) <= not led_track;                      -- green = timing valid
  led_status(4) <= not led_pps;                        -- white = PPS
  led_status(5) <= s_led_frnt_red;                     -- red   = generic front end - gpio0
  led_status(6) <= s_led_frnt_blue;                    -- blue  = generic front end - gpio1
  
  -- On board/user leds: 8 leds (from left to right: white, green, blue, red, white, green, blue, red)
  led_user(1)          <= not (led_link_act and led_link_up); -- red   = traffic/no-link
  led_user(2)          <= not led_link_up;                    -- blue  = link
  led_user(3)          <= not led_track;                      -- green = timing valid
  led_user(4)          <= not led_pps;                        -- white = PPS
  led_user(8 downto 5) <= s_leds_user;                        -- gpio5 ... gpio2
  
  
  -- wires to CPLD, currently unused
  con <= (others => 'Z');
  

  -- lemo io connectors on front panel

  -- lvds/lvttl lemos in/out
  s_lvds_p_i(4 downto 0) <= lvtio_in_p_i(5 downto 1);
  s_lvds_n_i(4 downto 0) <= lvtio_in_n_i(5 downto 1);

  lvtio_out_p_o(5 downto 1)   <= s_lvds_p_o(4 downto 0);
  lvtio_out_n_o(5 downto 1)   <= s_lvds_n_o(4 downto 0);
  
  -- lvds/lvttl lemos output enable
  lvtio_oe_n_o(1) <= '0' when s_lvds_oen(0)='0' else 'Z'; -- LVTTL_IO1
  lvtio_oe_n_o(2) <= '0' when s_lvds_oen(1)='0' else 'Z'; -- LVTTL_IO2
  lvtio_oe_n_o(3) <= '0' when s_lvds_oen(2)='0' else 'Z'; -- LVTTL_IO3
  lvtio_oe_n_o(4) <= '0' when s_lvds_oen(3)='0' else 'Z'; -- LVTTL_IO4
  lvtio_oe_n_o(5) <= '0' when s_lvds_oen(4)='0' else 'Z'; -- LVTTL_IO5
  
  -- lvds/lvttl lemos terminator (terminate on input mode)
  lvtio_term_en_o(1) <= '1' when s_lvds_oen(0)='1' else '0';
  lvtio_term_en_o(2) <= '1' when s_lvds_oen(1)='1' else '0';
  lvtio_term_en_o(3) <= '1' when s_lvds_oen(2)='1' else '0';
  lvtio_term_en_o(4) <= '1' when s_lvds_oen(3)='1' else '0';
  lvtio_term_en_o(5) <= '1' when s_lvds_oen(4)='1' else '0';
  
  -- lvds/lvttl lemos direction leds (blue) -- hi = led on
  lvtio_led_dir_o(1) <= (s_lvds_oen(0));
  lvtio_led_dir_o(2) <= (s_lvds_oen(1));
  lvtio_led_dir_o(3) <= (s_lvds_oen(2));
  lvtio_led_dir_o(4) <= (s_lvds_oen(3));
  lvtio_led_dir_o(5) <= (s_lvds_oen(4));
  
  -- lvds/lemos activity leds (red) -- -- hi = led on
  lvtio_led_act_o(1) <= (s_lvds_i_led(0)) or (s_lvds_o_led(0));
  lvtio_led_act_o(2) <= (s_lvds_i_led(1)) or (s_lvds_o_led(1));
  lvtio_led_act_o(3) <= (s_lvds_i_led(2)) or (s_lvds_o_led(2));
  lvtio_led_act_o(4) <= (s_lvds_i_led(3)) or (s_lvds_o_led(3));
  lvtio_led_act_o(5) <= (s_lvds_i_led(4)) or (s_lvds_o_led(4));

  -----------------------------------------------------------
  -- microTCA.4 backplane triggers
  -- using only 7 IOs !!!
  s_lvds_p_i(11 downto 5) <= mlvdio_in_p_i(7 downto 1);
  s_lvds_n_i(11 downto 5) <= mlvdio_in_n_i(7 downto 1);

  mlvdio_out_p_o(7 downto 1)   <= s_lvds_p_o(11 downto 5);
  mlvdio_out_n_o(7 downto 1)   <= s_lvds_n_o(11 downto 5);
  mlvdio_out_p_o(8)            <= '0';
  mlvdio_out_n_o(8)            <= '1';

  mlvdio_oe_o(7 downto 1)      <= (not s_lvds_oen(11 downto 5)) and s_mtca4_trig_oe_reg(7 downto 1);
  mlvdio_oe_o(8)               <= '0';
  mlvdio_fsen_o                <= (others => '0'); -- 
  mlvdio_pdn_o    <= s_mtca4_trig_pdn_reg; -- output buffer powerdown, active low

  -----------------------------------------------
  -- microTCA.4 clocks
--  tclk_in_n_i  
--  tclk_in_p_i  
  tclk_out_n_o <= (others => '1');
  tclk_out_p_o <= (others => '0');
  tclk_oe_o    <= s_mtca4_clk_oe_reg;

  -----------------------------------------------------------
  -- trigger outputs on backplane for Libera
  -- currently not driven because monster has max 12 lvdios

  -- no intputs from Libera backplane
--  s_lvds_p_i(16 downto 13) <= (others => '0');
--  s_lvds_n_i(16 downto 13) <= (others => '1');

  lib_trig_n_o(3 downto 0)   <= (others => '1'); -- s_lvds_p_o(16 downto 13);
  lib_trig_p_o(3 downto 0)   <= (others => '0'); -- s_lvds_n_o(16 downto 13);

  -- output buffers enable
  lib_trig_oe_o <= s_libera_trig_oe_reg; 


  ----------------------------------------------
  fpga2mmc_int_o  <= '0'; -- irq to mmc



  bpl_signal_en_reg  :process(s_clk_mmc_spi)
  begin
    if rising_edge(s_clk_mmc_spi) then
      if s_rstn_mmc_spi = '0' then
        s_mmc_spi_clk        <= (others => '0');
        s_mmc_spi_mosi       <= (others => '0');
        s_mmc_spi_sel_fpga_n <= (others => '1');

        s_mmc_spi_clk_re         <= '0';
        s_mmc_spi_sel_fpga_n_re  <= '0';
              
        s_mmc_spi_shift_reg      <= (others => '0');
             
        s_mtca4_trig_oe_reg      <= (others => '0');
        s_mtca4_trig_pdn_reg     <= '0';
        s_mtca4_clk_oe_reg       <= (others => '0');
        s_libera_trig_oe_reg     <= '0';

      else
        -- right shift inputs for sync and edge detection
        s_mmc_spi_clk   <= mmc_spi0_sck_i   & s_mmc_spi_clk(2 downto 1);
        s_mmc_spi_mosi  <= mmc_spi0_mosi_i  & s_mmc_spi_mosi(1);
        s_mmc_spi_sel_fpga_n <= mmc_spi0_sel_fpga_n_i & s_mmc_spi_sel_fpga_n(2 downto 1);

        -- rising edge on clock
        if s_mmc_spi_clk(1) = '1' and s_mmc_spi_clk(0) = '0' then 
          s_mmc_spi_clk_re  <= '1';
        else 
          s_mmc_spi_clk_re  <= '0';
        end if;

        -- rising edge on Chip Select
        if s_mmc_spi_sel_fpga_n(1) = '1' and s_mmc_spi_sel_fpga_n(0) = '0' then 
          s_mmc_spi_sel_fpga_n_re  <= '1';
        else 
          s_mmc_spi_sel_fpga_n_re  <= '0';
        end if;

        -- SPI shift in
        if s_mmc_spi_sel_fpga_n(1) = '0' and s_mmc_spi_clk_re = '1'  then
          s_mmc_spi_shift_reg <=  s_mmc_spi_mosi(0) & s_mmc_spi_shift_reg(s_mmc_spi_shift_reg'left downto 1) ;
        else
          s_mmc_spi_shift_reg <= s_mmc_spi_shift_reg;
        end if;
        
        mmc_spi0_miso_o <= s_mmc_spi_shift_reg(s_mmc_spi_shift_reg'right);
        
        -- store settings given by mmc
        if s_mmc_spi_sel_fpga_n_re = '1' then 
          s_mtca4_trig_oe_reg   <= s_mmc_spi_shift_reg(7 downto 0);
          s_mtca4_trig_pdn_reg  <= s_mmc_spi_shift_reg(12);
          s_mtca4_clk_oe_reg    <= s_mmc_spi_shift_reg(11 downto 8);
          s_libera_trig_oe_reg  <= s_mmc_spi_shift_reg(13);
        else -- hold
          s_mtca4_trig_oe_reg   <= s_mtca4_trig_oe_reg;
          s_mtca4_trig_pdn_reg  <= s_mtca4_trig_pdn_reg;
          s_mtca4_clk_oe_reg    <= s_mtca4_clk_oe_reg;
          s_libera_trig_oe_reg  <= s_libera_trig_oe_reg;
        end if;
        
      end if; -- reset
    end if; -- clk
  end process bpl_signal_en_reg;

  
end rtl;