
-- Top Module for System Integration
-- Engineer: 
--
-- Description: This module integrates the spi, DispDriver, binaris_szamlalo, and
-- DisMultiplexer modules into a unified top-level design for simulation and testing.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopModule is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        start : in STD_LOGIC;
        miso1 : in STD_LOGIC_VECTOR(15 downto 0);
        miso2 : in STD_LOGIC_VECTOR(15 downto 0);
        min_val : in STD_LOGIC_VECTOR(31 downto 0);
        max_val : in STD_LOGIC_VECTOR(31 downto 0);
        div_val : in STD_LOGIC_VECTOR(9 downto 0);
        h_val : in STD_LOGIC_VECTOR(31 downto 0);
        kapcsolo_1 : in STD_LOGIC;
        kapcsolo_2 : in STD_LOGIC;
        LEDSelect : out STD_LOGIC_VECTOR(7 downto 0);
        LED : out STD_LOGIC_VECTOR(6 downto 0)
    );
end TopModule;

architecture Behavioral of TopModule is

    signal src_clk : STD_LOGIC;
    signal cs : STD_LOGIC;
    signal src_ce : STD_LOGIC;
    signal adatki1, adatki2 : STD_LOGIC_VECTOR(15 downto 0);
    signal ready : STD_LOGIC;
    signal data_out : STD_LOGIC_VECTOR(31 downto 0);
    signal count : STD_LOGIC_VECTOR(2 downto 0);

    -- Clock divider for generating src_clk
    signal div_clk : STD_LOGIC;

    component spi
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            start : in STD_LOGIC;
            cs : out STD_LOGIC;
            src_clk : out STD_LOGIC;
            miso1 : in STD_LOGIC_VECTOR(15 downto 0);
            miso2 : in STD_LOGIC_VECTOR(15 downto 0);
            adatki1 : out STD_LOGIC_VECTOR(15 downto 0);
            adatki2 : out STD_LOGIC_VECTOR(15 downto 0);
            ready : out STD_LOGIC
        );
    end component;

    component DispDriver
        Port (
            src_clk : in STD_LOGIC;
            src_ce : in STD_LOGIC;
            reset : in STD_LOGIC;
            data : in STD_LOGIC_VECTOR(31 downto 0);
            LEDSelect : out STD_LOGIC_VECTOR(7 downto 0);
            LED : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    component DisMultiplexer
        Port (
            reset : in STD_LOGIC;
            min_val : in STD_LOGIC_VECTOR(31 downto 0);
            max_val : in STD_LOGIC_VECTOR(31 downto 0);
            div_val : in STD_LOGIC_VECTOR(9 downto 0);
            h_val : in STD_LOGIC_VECTOR(31 downto 0);
            kapcsolo_1 : in STD_LOGIC;
            kapcsolo_2 : in STD_LOGIC;
            data : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component binaris_szamlalo
        GENERIC (BITEK_SZAMA : natural := 3);
        Port (
            src_clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            q : out STD_LOGIC_VECTOR(BITEK_SZAMA-1 downto 0)
        );
    end component;

begin

    -- Instantiate SPI module
    U_spi: spi
        Port Map (
            clk => clk,
            reset => reset,
            start => start,
            cs => cs,
            src_clk => src_clk,
            miso1 => miso1,
            miso2 => miso2,
            adatki1 => adatki1,
            adatki2 => adatki2,
            ready => ready
        );

    -- Instantiate DisMultiplexer module
    U_DisMultiplexer: DisMultiplexer
        Port Map (
            reset => reset,
            min_val => min_val,
            max_val => max_val,
            div_val => div_val,
            h_val => h_val,
            kapcsolo_1 => kapcsolo_1,
            kapcsolo_2 => kapcsolo_2,
            data => data_out
        );

    -- Instantiate Display Driver
    U_DispDriver: DispDriver
        Port Map (
            src_clk => div_clk,
            src_ce => '1', -- Assuming always enabled
            reset => reset,
            data => data_out,
            LEDSelect => LEDSelect,
            LED => LED
        );

    -- Clock Divider Process
    ClockDivider: process (clk)
        variable counter : integer range 0 to 25000 := 0;
        variable clk_out : STD_LOGIC := '0';
    begin
        if rising_edge(clk) then
            if counter = 25000 then
                counter := 0;
                clk_out := not clk_out;
            else
                counter := counter + 1;
            end if;
        end if;
        div_clk <= clk_out;
    end process ClockDivider;

end Behavioral;
