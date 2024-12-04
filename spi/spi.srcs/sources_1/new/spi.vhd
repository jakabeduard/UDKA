----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 01:50:38 PM
-- Design Name: 
-- Module Name: spi - Behavioral
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
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi is
    Port ( clk:in STD_LOGIC;
           reset: in STD_LOGIC;
           start : in STD_LOGIC;
           cs : out STD_LOGIC;
           src_clk : out STD_LOGIC;
           
      
           miso1 : in std_logic_vector(15 downto 0);
           miso2 : in std_logic_vector(15 downto 0);
           
           adatki1 : out std_logic_vector(15 downto 0);
           adatki2 : out std_logic_vector(15 downto 0);
           
          intout : out STD_LOGIC); --intout out  nem megy  az nelkul 
           
           
           
           
end spi;

architecture Behavioral of spi is

type allapot_tipus is (RDY, INIT1, W1, INIT2, W2, INIT3, W3, INIT4, W4, INIT5, INIT6, W5, VEGE);

signal akt_all, kov_all : allapot_tipus;  
constant N1 : std_logic_vector(3 downto 0) := "0011";
constant N2 : std_logic_vector(3 downto 0) := "0011";
constant N3 : std_logic_vector(3 downto 0) := "0011";
constant N4 : std_logic_vector(3 downto 0) := "0011";
constant P : std_logic_vector(15 downto 0):="0011";


signal RI, RI_next : std_logic_vector(15 downto 0);
signal Rk, Rk_next : std_logic_vector(15 downto 0);
signal RBE1, RBE_next1 : std_logic_vector(15 downto 0);
signal RBE2, RBE_next2 : std_logic_vector(15 downto 0);


signal R_Status, R_Status_next : std_logic;
signal R_CS, R_CS_next : std_logic;
signal R_SCLK, R_SCLK_next : std_logic;
signal R_Delay, R_Delay_next : std_logic;
signal R_intout, R_intout_next : std_logic;



--signal R_MOSI1, R_MOSI_next1 : std_logic_vector(15 downto 0);
--signal R_MOSI2, R_MOSI_next2 : std_logic_vector(15 downto 0);

begin

AR:process(clk, reset)
begin
    if reset='1' then
        akt_all <=RDY;
    elsif clk'event and clk='1' then
        akt_all <= kov_all;
    end if;
end process AR;


KAL:process(akt_all, start, RI)
begin
   case akt_all is
   
   when RDY =>
        if start = '1' then
            kov_all <= INIT1;
        else
            kov_all <= RDY;
        end if;
        
        
   when INIT1 =>
   
      kov_all <= W1;
      
      
   when W1 =>
        if RI > 1 then
            kov_all <= INIT2;
        else
            kov_all <= W1;
        end if; 
        
   when INIT2 =>
   
      kov_all <= W2;
      
   when W2 =>
        if RI > 1 then
            kov_all <= INIT3;
        else
            kov_all <= W2;
        end if; 
        
   when INIT3 =>
   
      kov_all <= W3;

   when W3 =>
        if RI > 1 then
            kov_all <= INIT4;
        else
            kov_all <= W3;
        end if;  

   when INIT4 =>
   
      kov_all <= W4;   
      
  when W4 =>
        if RI > 1 then
            kov_all <= INIT5;
        else
            kov_all <= W4;
        end if;  
 when INIT5 =>
        if RK > 1 then
            kov_all <= W3;
        else
            kov_all <= INIT6;
        end if; 
        
   when INIT6 =>
   
      kov_all <= W5;    
      
  when W5 =>
        if RI > 1 then
            kov_all <= W5;
        else
            kov_all <= VEGE;
        end if;      
   when VEGE =>
   
      kov_all <= RDY;     
   end case;
   

end process KAL;


with akt_all select
    Ri_next<= 
            Ri - 1 when W1,
            Ri - 1 when W2,
            Ri - 1 when W3,
            Ri - 1 when W4,
            Ri - 1 when W5,
            N1 when INIT1,
            N2 when INIT2,
            N3 when INIT3,
            N3 when INIT4,
            N3 when INIT5,
            N2 when INIT6,
            Ri when others;
            

              
with akt_all select
     Rk_next<= conv_std_logic_vector(16,16) when INIT1,
            Rk-1 when INIT5,
              Rk when others;
               
               
with akt_all select
        RBE_next1<=  x"0000" when RDY,
                   RBE1(14 downto 0)& R_MOSI1 when INIT4,
                   RBE1 when others;  
               
               
with akt_all select
        RBE_next2<=  x"0000" when RDY,
                   RBE2(14 downto 0)& R_MOSI2 when INIT4,
                   RBE2 when others;    



with akt_all select
       R_MOSI_next1 <=  x"0000" when RDY,
                   RBE2(14 downto 0)& R_MOSI2 when INIT4,
                   RBE2 when others; 
                   


with akt_all select
       R_MOSI_next2 <=  x"0000" when RDY,
                   RBE2(14 downto 0)& R_MOSI2 when INIT4,
                   RBE2 when others;       
                   
               
with akt_all select
   R_Status_next <= 
               R_Status when RDY,
                    '1' when VEGE,
                    '0' when others;
                  
 
 with akt_all select
   R_CS_next <=   '1' when INIT1,
                  '1' when W1,
                  '1' when INIT6,
                  '1' when W5,
                  '1' WHEN VEGE,
                  '0' when others;          
                  
 with akt_all select
   R_SCLK_next <=  
                  '0' when W3,
                  '0' when INIT4,
                  '-1' when INIT5,
                  '0' when INIT6,
                  '0' WHEN W5, 
                  '1' when others;               
              




end Behavioral;
