----------------------------------------------------------------------------------
-- Engineer: Marcel Hammerl
-- 
-- Create Date: 26.01.2021
-- Design Name: Mode Adaption
-- Module Name: Input Interface
-- Project Name: DVB-S2
-- Description: 
-- The input interface receives a serial data stream from the processing system 
-- and created data packets with a bit length of 1024 bits. The data packets only 
-- contain 1016 data bits. The first 8 bits of the packets are a sync byte, which 
-- will be replaced in the next unit after the CRC8 calculatation. If a new packet
-- with 1024 bits was created, the unit set a status bit to indicated that a new 
-- packet is available.
--
-- Version: 1.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InputInterface is
    Port (CLK:                          in          std_logic;                              -- Clock input
          newData:                      in          std_logic;                              -- Status bit to indicate the input unit that new data is availble
          inputData:                    in          std_logic;                              -- Serial data stream with a data width of 1 bit
          reset:                        in          std_logic;                              -- Resets the newPacket status bit
          sync_Byte:                    in          std_logic_vector(7 downto 0);           -- Input of the sync byte
          newPacket:                    out         std_logic;                              -- Indicates the next unit that a new data packet is available
          outputPacket:                 out         std_logic_vector(1023 downto 0) );      -- Output of the data packet with 1024 bits
end InputInterface;

architecture archInputInterface of InputInterface is
begin
Data_Input: process(clk,inputData)                                                          
variable cout:                          integer range 0 to 1024;                            -- Variable for the definition of the circut
variable sync:                          std_logic_vector(7 downto 0);                       -- Stores the sync byte
variable outPacket:                     std_logic_vector(1023 downto 0);                    -- Stores the output packet
variable input_data:                    std_logic;                                          -- Stores the last input data for the calculation process
begin
    sync := sync_Byte;                                                                      -- The defined variable receives the value of the sync byte
    input_data := inputData;                                                                -- The defined variable receives the last state of the input data
    
    if(CLK = '1' and CLK'event) then                                                        -- If the clock receives a falling flag the if statement will be executed
        if (newData = '1' and cout < 1016) then                                             -- If the new data variable is set and the value of the cout variable is small than 1016 
            outPacket := outPacket(1022 downto 0) & input_data;                             -- the input data will be stored in the output packet buffer
            cout := cout + 1;                                                               -- Increasing of the cout value
        elsif (cout > 1015) then                                                            -- If cout is bigger than 1015 the output packet receives the sync byte
            outPacket(1023 downto 1016) := sync;
            outputPacket <= outPacket;
            cout := 0;
            newPacket <= '1';                                                               -- Sets the new packet bit
        end if;
    end if;
    
     if (reset = '1') then                                                                  -- Resets the new packet status bit
        newPacket <= '0';
    end if;   
end process Data_Input;

end archInputInterface;
