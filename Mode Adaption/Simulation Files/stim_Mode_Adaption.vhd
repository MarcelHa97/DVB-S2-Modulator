library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stim_Mode_Adaption is
--  Port ( );
end stim_Mode_Adaption;

architecture arch_Stim_Mode_Adaption of stim_Mode_Adaption is
component mode_Adaption
    port(CLK: in std_logic;
         new_Data: in std_logic;
         input_Data: in std_logic;
         sync_Byte: in std_logic_vector(7 downto 0);
         output_Data: out std_logic_vector(1023 downto 0);
         new_Data_Packet: out std_logic ;
         CRC8_Data: out std_logic_vector(7 downto 0);
         new_CRC_zwischen: out std_logic; --Simulation
         new_zwischen: out std_logic); --Simulation
end component;

signal s_CLK: std_logic;
signal s_New_Data: std_logic;
signal s_Input_Data: std_logic;
signal s_Sync_Byte: std_logic_vector(7 downto 0);
signal s_Output_Data: std_logic_vector(1023 downto 0);
signal s_New_Data_Packet: std_logic;
signal CRC8: std_logic_vector(7 downto 0); --Simulation
signal v_new_CRC_zwischen: std_logic; -- Simulation
signal v_new_zwischen: std_logic; --Simulation

begin
design1: mode_Adaption port map(s_CLK, s_New_Data, s_Input_Data, s_Sync_Byte, s_Output_Data, s_New_Data_Packet,CRC8,v_new_CRC_zwischen, v_new_zwischen);
s_New_Data <= '1';
s_Sync_Byte <= "11100111";

Input_Data_Process: process
begin
    s_Input_Data <= '1';
    wait for 200ns;
    s_Input_Data <= '0';
    wait for 100ns;
    s_Input_Data <= '1';
    wait for 400ns;
    s_Input_Data <= '0';
    wait for 100ns;
    s_Input_Data <= '1';
    wait for 300ns;
    s_Input_Data <= '0';
    wait for 800ns;
    s_Input_Data <= '1';
    wait for 100ns;
    s_Input_Data <= '0';
    wait for 200ns;
    s_Input_Data <= '1';
    wait for 100ns;
    s_Input_Data <= '0';
    wait for 100ns;
    
end process Input_Data_Process;
CLK_Process: process
begin
    s_CLK <= '1';
    wait for 10ns;
    s_CLK <= '0';
    wait for 10ns;
end process CLK_Process;

end arch_Stim_Mode_Adaption;
