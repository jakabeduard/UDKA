----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2024 01:09:21 PM
-- Design Name: 
-- Module Name: spi_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_sim is
--  Port ( );
end spi_sim;

architecture Behavioral of spi_sim is

component spi
port(clk:in STD_LOGIC;
           reset: in STD_LOGIC;
           start : in STD_LOGIC;
           cs : out STD_LOGIC;
           src_clk : out STD_LOGIC;
           
      
           miso1 : in std_logic_vector(15 downto 0);
           miso2 : in std_logic_vector(15 downto 0);
           
           adatki1 : out std_logic_vector(15 downto 0);
           adatki2 : out std_logic_vector(15 downto 0);
           
          ready : out STD_LOGIC);
end component;


begin



end Behavioral;
