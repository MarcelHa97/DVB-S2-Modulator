----------------------------------------------------------------------------------
-- Engineer: Marcel Hammerl
-- 
-- Create Date: 26.01.2021
-- Design Name: Mode Adaption
-- Module Name: Input Interface Buffer
-- Project Name: DVB-S2
-- Description: 
-- This unit receives the packages from the input interface and the calculated CRC8
-- code from the CRC8 calculator. The input interface buffer makes the decision if 
-- it replace the sync byte at the front of the package with the CRC sum or not. 
-- The input interface buffer sets the CRC8 sum at the front of the data package.
--
-- Version: 1.0
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_Buffer is
    Port (input_Data_CRC:                               in              std_logic_vector(7 downto 0);                   -- Input of the CRC8 data              
          input_Data_Packet:                            in              std_logic_vector(1023 downto 0);                -- Input of the data package
          CLK:                                          in              std_logic;                                      -- Clock signal
          enable:                                       in              std_logic;                                      -- Enables the block and indicates that new data is available
          new_CRC_Data:                                 in              std_logic;                                      -- Indicates that a new CRC8 sum is available, but is not necessary anymore
          reset:                                        in              std_logic;                                      -- Resets the "new_Data_Packet" status bit
          output_Data:                                  out             std_logic_vector(1023 downto 0);                -- Output data with added CRC8 sum
          CRC_stored:                                   out             std_logic;                                      -- Resets the CRC8 block
          reset_Output:                                 out             std_logic;                                      -- Resets the input interface
          new_Data_Packet:                              out             std_logic );                                    -- Indicates that a new data package is available
end input_Buffer;

architecture arch_Input_Buffer of input_Buffer is

signal reset_out: std_logic;                                                                        -- Signal to store the reset out bit
signal CRC_Data: std_logic_vector(7 downto 0);                                                      -- Signal to store the CRC8 sum

begin
process(CLK)

variable out_Data: std_logic_vector(1023 downto 0);                                                 -- Storage of the new data package
variable v_stored_CRC: std_logic;
variable v_Status_Sync_Byte: std_logic;

begin

    if(CLK = '1' and CLK'event and enable = '1') then                                               -- The process starts with a falling flag of the clock and it enable equal one
       if (v_Status_Sync_Byte = '1') then                                                           -- The CRC data will be added to the input package
            out_Data(1015 downto 0) := input_Data_Packet(1015 downto 0);
            out_Data(1023 downto 1016) := CRC_Data; 
       else 
            out_Data := input_Data_Packet;
            v_Status_Sync_Byte := '1';
       end if;
       CRC_Data <= input_Data_CRC;    
       output_Data <= out_Data;
       new_Data_Packet <= '1';                                                                      -- Indicates that a new package is availble
       reset_out <= '1';
    end if;
    
    
    if reset_out = '1' then                                                                         -- Resets the CRC8 unit -- Is not necessary anymore
        reset_out <= '0';
    end if;
    

    if (reset = '1') then                                                                           -- Resets the "new_Data_Packet" bit 
        new_Data_Packet <= '0';
    end if;  
end process;

    reset_Output <= reset_out;
    
end arch_Input_Buffer;
