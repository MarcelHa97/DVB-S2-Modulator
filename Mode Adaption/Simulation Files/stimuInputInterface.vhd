library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stimuInputInterface is
--  Port ( );
end stimuInputInterface;

architecture archStimu of stimuInputInterface is
component InputInterface
    Port (CLK: in std_logic;
          newData: in std_logic;
          inputData: in std_logic;
          reset: in std_logic;
          sync_Byte: in std_logic_vector(7 downto 0);
          newPacket: out std_logic;
          outputPacket: out std_logic_vector(1023 downto 0) );
end component;

signal CLK: std_logic;
signal newData: std_logic;
signal inputData: std_logic;
signal reset: std_logic;
signal sync_Byte: std_logic_vector(7 downto 0);
signal newPacket: std_logic;
signal outputPacket: std_logic_vector(1023 downto 0);



begin
design1: InputInterface port map(CLK, newData, inputData, reset, sync_Byte, newPacket, outputPacket);
newData <= '1';
sync_Byte <= "01110001";


Input_Data_Process: process
begin
    inputData <= '1';
    wait for 200ns;
    inputData <= '0';
    wait for 100ns;
    inputData <= '1';
    wait for 400ns;
    inputData <= '0';
    wait for 100ns;
    inputData <= '1';
    wait for 300ns;
    inputData <= '0';
    wait for 800ns;
    inputData <= '1';
    wait for 100ns;
    inputData <= '0';
    wait for 200ns;
    inputData <= '1';
    wait for 100ns;
    inputData <= '0';
    wait for 100ns;
    
end process Input_Data_Process;

CLK_Process: process
begin
    CLK <= '1';
    wait for 10ns;
    CLK <= '0';
    wait for 10ns;
end process CLK_Process;

Reset_Process: process
begin
    wait for 20500ns;
    reset <= '1';
    wait for 200ns;
    reset <= '0';
end process Reset_Process;
   
    
end archStimu;
