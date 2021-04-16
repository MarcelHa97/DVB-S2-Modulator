library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BB_Scrambler is
    generic(Kbch_length : integer := 14232;  --7032
            DFL_length : integer := 13364; -- ??
            BBHeader_Bits: integer := 80);
    Port    (CLK: in std_logic;
             reset: in std_logic;
             input_Data_Frame: in std_logic_vector((Kbch_length - 1) downto 0);
             enable_Scrambler: in std_logic;
             output_Scram_Data_Frame: out std_logic_vector((Kbch_length - 1) downto 0);
             new_Output_Data: out std_logic);            
end BB_Scrambler;

architecture arch_BBScrambler of BB_Scrambler is
begin

process(CLK)
    variable v_scramble_output_Data: std_logic_vector((Kbch_length - 1) downto 0);
    variable v_shift_reg: std_logic_vector(14 downto 0);
    variable v_input_shift_reg: std_logic;
begin
    if (CLK = '1' and CLK'event and enable_Scrambler = '1') then
        v_shift_reg := "100101010000000";
        
        for I in (Kbch_length - 1) downto 0 
        loop
            v_input_shift_reg := v_shift_reg(1) xor v_shift_reg(0);
            
            v_scramble_output_Data(I) := v_input_shift_reg xor input_Data_Frame(I);
            
            v_shift_reg(13 downto 0) := v_shift_reg(14 downto 1);
            v_shift_reg(14) := v_input_shift_reg;
        end loop;
        output_Scram_Data_Frame <= v_scramble_output_Data;
        new_Output_Data <= '1';
    end if;
    
    
    if (reset = '1') then
        new_Output_Data <= '0';
    end if;
end process;

end arch_BBScrambler;
