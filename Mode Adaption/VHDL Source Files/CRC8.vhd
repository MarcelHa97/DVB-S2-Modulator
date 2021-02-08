----------------------------------------------------------------------------------
-- Engineer: Marcel Hammerl
-- 
-- Create Date: 23.01.2021
-- Design Name: CRC8 (cyclic redundancy check)
-- Module Name: CRC8
-- Project Name: DVB-S2
-- Description: 
-- This block calculates a error-detacting code to detect accidental changes to raw data.
-- The circut images a CRC-8 encoder (cyclic redundancy check),which calculates a 8-bits 
-- error-detacting code from a 1016 bits long input data.
-- The input data has a length of 1016 bit.
-- The calculation circut is releizd as a 8-bit shift register with the generator polynomial "1 1 1 0 1 0 1 0 1"
--
-- Version: 1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CRC8 is
    Port (inDataUP:         in      std_logic_vector(1015 downto 0);            -- Input Data with a length of 1016 bit
          CLK:              in      std_logic;                                  -- Clock
          enable:           in      std_logic;                                  -- If this bit is set, the CRC error code will be calculated and stored at the output
          reset:            in      std_logic;                                  -- Resets the new_CRC_Data flag (sets it to zero)
          new_CRC_Data:     out     std_logic;                                  -- Indicates that new data was stored in the output register
          outDataCRC:       out     std_logic_vector(7 downto 0));              -- CRC error code with a length of 8 bit
end CRC8;

architecture arch_CRC8 of CRC8 is
signal outputDataCRC:               std_logic_vector(7 downto 0);
signal s_enable:                    std_logic;
begin
-- The following code describes the behaviour of a 8-bit shift register with the generator polynomial "1 1 1 0 1 0 1 0 1"
    process(CLK)
    variable Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8: std_logic;
    variable Q1_out, Q2_out, Q3_out, Q4_out, Q5_out, Q6_out, Q7_out, Q8_out: std_logic;   
    
    begin 
        Q1 := '0';
        Q2 := '0';
        Q3 := '0';
        Q4 := '0';
        Q5 := '0';
        Q6 := '0';
        Q7 := '0';
        Q8 := '0';
        
        Q1_out := '0';
        Q2_out := '0';
        Q3_out := '0';
        Q4_out := '0';
        Q5_out := '0';
        Q6_out := '0';
        Q7_out := '0';
        Q8_out := '0';
        

        for I in 1015 downto 0                                                      --Length of the input data
         loop
            Q1 := (inDataUP(I) xor Q8_out);
            Q2 := Q1_out;
            Q3 := (Q2_out xor (inDataUP(I) xor Q8_out));
            Q4 := Q3_out;
            Q5 := (Q4_out xor (inDataUP(I) xor Q8_out));
            Q6 := Q5_out;
            Q7 := (Q6_out xor (inDataUP(I) xor Q8_out));
            Q8 := (Q7_out xor (inDataUP(I) xor Q8_out));
            
            Q1_out := Q1;
            Q2_out := Q2;
            Q3_out := Q3;
            Q4_out := Q4;
            Q5_out := Q5;
            Q6_out := Q6;
            Q7_out := Q7;
            Q8_out := Q8;
        end loop;
        
            outputDataCRC(7) <= Q8;
            outputDataCRC(6) <= Q7;
            outputDataCRC(5) <= Q6;
            outputDataCRC(4) <= Q5;
            outputDataCRC(3) <= Q4;
            outputDataCRC(2) <= Q3;
            outputDataCRC(1) <= Q2;
            outputDataCRC(0) <= Q1;
        
         if (reset = '1') then                                                      --If the reset input is set to '1', the new_CRC_Data flag will set to '0'
            new_CRC_Data <= '0';
         elsif (CLK = '0' and CLK'event and enable = '1') then                      --If the enable input is set and the clock input receive a falling flag, the calculated code will be stored in the output register
                                         
            new_CRC_Data <= '1';
         end if;       
    end process;
    
    outDataCRC <= outputDataCRC;
    

    
    
    
   
end arch_CRC8;
