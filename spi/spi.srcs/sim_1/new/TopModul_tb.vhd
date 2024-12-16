
----------------------------------------------------------------------------------
-- Testbench for TopModule
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopModule_tb is
end TopModule_tb;

architecture Behavioral of TopModule_tb is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal miso1, miso2 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal min_val, max_val, h_val : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal div_val : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal kapcsolo_1, kapcsolo_2 : STD_LOGIC := '0';
    signal LEDSelect : STD_LOGIC_VECTOR(7 downto 0);
    signal LED : STD_LOGIC_VECTOR(6 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate TopModule
    UUT: entity work.TopModule
        Port Map (
            clk => clk,
            reset => reset,
            start => start,
            miso1 => miso1,
            miso2 => miso2,
            min_val => min_val,
            max_val => max_val,
            div_val => div_val,
            h_val => h_val,
            kapcsolo_1 => kapcsolo_1,
            kapcsolo_2 => kapcsolo_2,
            LEDSelect => LEDSelect,
            LED => LED
        );

    -- Clock Process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus Process
    stim_process: process
    begin
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';
        
        start <= '1';
        miso1 <= x"1234";
        miso2 <= x"5678";
        min_val <= x"00000001";
        max_val <= x"000000FF";
        div_val <= "0010101010";
        h_val <= x"ABCDEFFF";
        kapcsolo_1 <= '0';
        kapcsolo_2 <= '1';

        wait for 100 * clk_period;
        start <= '0';

        wait;
    end process;

end Behavioral;
