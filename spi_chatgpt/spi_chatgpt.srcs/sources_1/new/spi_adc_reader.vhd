-- SPI interface for 2x16-bit data reading from AD7476A ADC
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_adc_reader is
    Port (
        clk      : in  STD_LOGIC;     -- System clock
        rst      : in  STD_LOGIC;     -- Reset signal
        start    : in  STD_LOGIC;     -- Start conversion
        stop     : in  STD_LOGIC;     -- Stop conversion
        sclk     : out STD_LOGIC;     -- SPI clock
        cs       : out STD_LOGIC;     -- Chip select
        mosi1    : out STD_LOGIC;     -- Master Out Slave In 1
        mosi2    : out STD_LOGIC;     -- Master Out Slave In 2
        miso     : in  STD_LOGIC;     -- Master In Slave Out
        data_out : out STD_LOGIC_VECTOR(31 downto 0) -- 32-bit output data (2x16-bit)
    );
end spi_adc_reader;

architecture Behavioral of spi_adc_reader is
    signal sclk_reg      : STD_LOGIC := '0';
    signal cs_reg        : STD_LOGIC := '1';
    signal data_reg      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal bit_counter   : INTEGER range 0 to 31 := 0;
    signal reading       : BOOLEAN := false;
    signal shift_register: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
    process(clk, rst)
    begin
        if rst = '1' then
            sclk_reg <= '0';
            cs_reg <= '1';
            data_reg <= (others => '0');
            bit_counter <= 0;
            reading <= false;
        elsif rising_edge(clk) then
            if start = '1' and not reading then
                cs_reg <= '0';
                reading <= true;
            elsif stop = '1' then
                cs_reg <= '1';
                reading <= false;
            end if;

            if reading then
                if bit_counter < 32 then
                    sclk_reg <= not sclk_reg;
                    if sclk_reg = '1' then
                        if bit_counter < 16 then
                            shift_register(bit_counter) <= miso;
                            mosi1 <= shift_register(bit_counter);
                        else
                            shift_register(bit_counter) <= miso;
                            mosi2 <= shift_register(bit_counter);
                        end if;
                        bit_counter <= bit_counter + 1;
                    end if;
                else
                    cs_reg <= '1';
                    reading <= false;
                    bit_counter <= 0;
                    data_reg <= shift_register;
                end if;
            end if;
        end if;
    end process;

    sclk <= sclk_reg;
    cs <= cs_reg;
    data_out <= data_reg;

end Behavioral;

