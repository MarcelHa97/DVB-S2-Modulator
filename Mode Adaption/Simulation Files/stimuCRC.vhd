library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stimuCRC is
--  Port ( );
end stimuCRC;

architecture archStimuCRC of stimuCRC is
component CRC8
    Port (inDataUP: in std_logic_vector(31 downto 0);
          CLK: in std_logic;
          enable: in std_logic;
          reset: in std_logic;
          new_CRC_Data: out std_logic;
          outDataCRC: out std_logic_vector(7 downto 0));
end component;

signal portIn: std_logic_vector(31 downto 0);
signal portOut: std_logic_vector(7 downto 0);
signal CLK: std_logic;
signal enable: std_logic;
signal new_data_CRC: std_logic;
signal reset: std_logic;

begin
design1: CRC8 port map (portIn, CLK, enable, reset, new_data_CRC, portOut);

enable <= '1';

stim1: process
begin
    portIn <= "01001101101111101010111111011110";
    wait for 100ns;
    portIn <= "00000000000000000000000001110001";
    wait for 100ns;
end process stim1;

stimCLK: process
begin
    CLK <= '1';
    wait for 10ns;
    CLK <= '0';
    wait for 10ns;
end process stimCLK;

stimReset: process
begin
    wait for 120ns;
    reset <= '1';
    wait for 5ns;
    reset <= '0';
end process stimReset;

end archStimuCRC;
