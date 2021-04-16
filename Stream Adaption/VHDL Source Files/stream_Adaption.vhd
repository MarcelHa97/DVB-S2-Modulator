library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stream_Adaption is
    generic(Kbch_length : integer := 14232;  -- 7032
            DFL_length : integer := 13364;  -- 6144
            BBHeader_Bits: integer := 80);   -- 80
            
    Port (new_Input_Frame : in std_logic_vector((Kbch_length) downto 1);
          CLK : in std_logic;
          reset: in std_logic;
          enable_Stream_Adaption: in std_logic;
          output_BBFrame: out std_logic_vector((Kbch_length - 1) downto 0);
          new_BBFrame: out std_logic;
          new_BBFrame2: out std_logic; -- sim
          o_Frame: out std_logic_vector((Kbch_length - 1) downto 0));
end stream_Adaption;

architecture arch_Stream_Adaption of stream_Adaption is
component BB_Scrambler
    Port    (CLK: in std_logic;
             reset: in std_logic;
             input_Data_Frame: in std_logic_vector((Kbch_length - 1) downto 0);
             enable_Scrambler: in std_logic;
             output_Scram_Data_Frame: out std_logic_vector((Kbch_length - 1) downto 0);
             new_Output_Data: out std_logic);
end component;

signal s_padding_Bits: std_logic_vector((Kbch_length - BBHeader_Bits - DFL_length - 1) downto 0);
signal s_BBFrame: std_logic_vector((Kbch_length - 1) downto 0);
signal s_Enable_Scrambler: std_logic;
signal s_o_Frame: std_logic_vector((Kbch_length - 1) downto 0);
signal s_new_BBFrame: std_logic;

begin
s_padding_Bits <= (others => '0');

Scrambler: BB_Scrambler port map(CLK, reset, s_BBFrame, s_Enable_Scrambler, output_BBFrame, s_new_BBFrame);

process(CLK)
begin
    if(CLK = '1' and CLK'event and enable_Stream_Adaption = '1') then
        s_BBFrame((Kbch_length - 1) downto (Kbch_length - BBHeader_Bits - DFL_length)) <= new_Input_Frame((Kbch_length - 1) downto (Kbch_length - BBHeader_Bits - DFL_length));
        s_BBFrame((Kbch_length - BBHeader_Bits - DFL_length - 1) downto 0) <= s_padding_Bits; 
        s_Enable_Scrambler <= '1';
        o_Frame <= new_Input_Frame; --sim
    end if;
    
    if(reset = '1') then
        s_Enable_Scrambler <= '0';
    end if;
    
end process;

new_BBFrame <= s_new_BBFrame;
--new_BBFrame2 <= s_new_BBFrame;

end arch_Stream_Adaption;
