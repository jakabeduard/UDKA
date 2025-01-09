-- Simulation testbench for SPI ADC Reader
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_adc_testbench is
end spi_adc_testbench;

architecture Behavioral of spi_adc_testbench is
    -- Component Declaration
    component spi_adc_reader
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            start    : in  STD_LOGIC;
            stop     : in  STD_LOGIC;
            sclk     : out STD_LOGIC;
            cs       : out STD_LOGIC;
            mosi1    : out STD_LOGIC;
            mosi2    : out STD_LOGIC;
            miso     : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Signals for simulation
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '1';
    signal start    : STD_LOGIC := '0';
    signal stop     : STD_LOGIC := '0';
    signal sclk     : STD_LOGIC;
    signal cs       : STD_LOGIC;
    signal mosi1    : STD_LOGIC;
    signal mosi2    : STD_LOGIC;
    signal miso     : STD_LOGIC := '0';
    signal data_out : STD_LOGIC_VECTOR(31 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: spi_adc_reader
        Port map (
            clk => clk,
            rst => rst,
            start => start,
            stop => stop,
            sclk => sclk,
            cs => cs,
            mosi1 => mosi1,
            mosi2 => mosi2,
            miso => miso,
            data_out => data_out
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Simulation process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        -- Start conversion
        start <= '1';
        wait for 320 ns;
        start <= '0';

        -- Stop conversion
        wait for 200 ns;
        stop <= '1';
        wait for 40 ns;
        stop <= '0';

        -- MISO signal simulation (example)
        wait for 100 ns;
        miso <= '1';
        wait for 20 ns;
        miso <= '0';

        -- End simulation
        wait;
    end process;

end Behavioral;
