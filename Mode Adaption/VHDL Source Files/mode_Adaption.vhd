library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mode_Adaption is
    port(CLK: in std_logic;
         new_Data: in std_logic;
         input_Data: in std_logic;
         sync_Byte: in std_logic_vector(7 downto 0);
         output_Data: out std_logic_vector(1023 downto 0);
         new_Data_Packet: out std_logic;
         CRC8_Data: out std_logic_vector(7 downto 0);
         new_CRC_zwischen: out std_logic; --Simulation
         new_zwischen: out std_logic); --Simulation
end mode_Adaption;

architecture arch_mode_Adaption of mode_Adaption is
component CRC8
    Port (inDataUP: in std_logic_vector(1015 downto 0); --1015
          CLK: in std_logic;
          enable: in std_logic;
          reset: in std_logic;
          new_CRC_Data: out std_logic;
          outDataCRC: out std_logic_vector(7 downto 0));
end component;

component InputInterface
    Port (CLK: in std_logic;
          newData: in std_logic;
          inputData: in std_logic;
          reset: in std_logic;
          sync_Byte: in std_logic_vector(7 downto 0);
          newPacket: out std_logic;
          outputPacket: out std_logic_vector(1023 downto 0) ); 
end component;

component input_Buffer
    Port (input_Data_CRC: in std_logic_vector(7 downto 0);
          input_Data_Packet: in std_logic_vector(1023 downto 0);
          CLK: in std_logic;
          enable: in std_logic;
          new_CRC_Data: in std_logic;
          reset: in std_logic;
          output_Data: out std_logic_vector(1023 downto 0);
          CRC_stored: out std_logic;
          reset_Output: out std_logic;
          new_Data_Packet: out std_logic ); 
end component;

signal s_Reset_Input_Interface: std_logic;
signal s_New_Packet: std_logic;
signal s_Output_Packet: std_logic_vector(1023 downto 0);
signal s_Reset_CRC8: std_logic;
signal s_New_CRC8_Data: std_logic;
signal s_Out_Data_CRC8: std_logic_vector(7 downto 0);
signal s_Reset_Input_Buffer: std_logic;

begin
comp_Input_Interface: InputInterface port map(CLK, new_Data,input_Data,s_Reset_Input_Interface,sync_Byte,s_New_Packet,s_Output_Packet);
comp_CRC8: CRC8 port map(s_Output_Packet(1015 downto 0), CLK, s_New_Packet,s_Reset_CRC8,s_New_CRC8_Data,s_Out_Data_CRC8);
comp_Input_Buffer: input_Buffer port map(s_Out_Data_CRC8,s_Output_Packet,CLK,s_New_Packet,s_New_CRC8_Data,s_Reset_Input_Buffer,output_Data,s_Reset_CRC8,s_Reset_Input_Interface,new_Data_Packet);

CRC8_Data <= s_Out_Data_CRC8;
new_CRC_zwischen <= s_New_CRC8_Data;
new_zwischen <= s_New_Packet;
end arch_mode_Adaption;
