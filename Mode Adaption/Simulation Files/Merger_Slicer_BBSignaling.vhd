----------------------------------------------------------------------------------
-- Company: DHBW Ravensburg Campus Friedrichshafen - SeeSat e.V
-- Engineer: Mert-Can Ünlü
-- 
-- Create Date: 11.02.2021 22:23:26
-- Design Name: Merger_Slicer_BBSignaling
-- Module Name: Merger_Slicer_BBSignaling
-- Project Name: DVB-S2 
-- Target Devices: Zynq-7020
-- Tool Versions: 2020.1
-- Description: In this Block the Merger-Slicer- and the BBSignaling-Block will instantiated
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Merger_Slicer_BBSignaling is
generic( Kbch_length : integer := 14232;                                            --Kbch frame length
         UP_Packet_Length : integer := 1024); --1769                                      -- Length of a UP Packet 
port(
    CLK                 : in std_logic;
    dataUP              : in std_logic_vector(UP_Packet_Length downto 1);                       --Here will be stored the next UP packet from the Input-Buffer
    enable              : in std_logic;                                             --Indicates that the next UP is ready 
    reset               : in std_logic;                                             --The Stream Adaption indicates that the Frame(BBHeader_Datafield) is received; Reset "frame_ready"
    
    dataUP_received     : out std_logic;                                            --Indicates that one UP is received
    frame_ready         : out std_logic;                                            --Indicates to the Stream Adaption, that the Frame is ready
    BBHeader_Datafield  : out std_logic_vector(Kbch_length downto 1);                      --Frame for Stream Adaption

    x_out               : out   std_logic_vector(20 downto 0);
    count_out           : out   std_logic_vector(20 downto 0)
);
end Merger_Slicer_BBSignaling;



architecture Behavioral of Merger_Slicer_BBSignaling is
-----------------------------------------------------------------------------------------------------------------------------------
--Instantiation of Merger_slicer
component Merger_Slicer                                            
    port(
        clk                 : in    std_logic;
        enable              : in    std_logic;                          
        dataUP              : in    std_logic_vector(UP_Packet_Length downto 1);    
        reset               : in    std_logic;                          
        BBHeader            : in    std_logic_vector(80 downto 1);
        
        frame_ready         : out   std_logic;                         
        BBHeader_Datafield  : out   std_logic_vector(Kbch_length downto 1);    
        UP_reset            : out   std_logic;                           
        
        x_out               : out   std_logic_vector(20 downto 0);
        count_out           : out   std_logic_vector(20 downto 0)
        );
end component;
-----------------------------------------------------------------------------------------------------------------------------------
--Instantiation of BBSignaling
component BBSignaling
port(
    BBHEADER          : OUT std_logic_vector(80 downto 1);  
    CLK               : IN  std_logic
);
end component;
-----------------------------------------------------------------------------------------------------------------------------------
--Signals
signal BBHeader_s : std_logic_vector(80 downto 1);
signal CLK0       : std_logic;
-----------------------------------------------------------------------------------------------------------------------------------
begin
-----------------------------------------------------------------------------------------------------------------------------------
--Instatiation of Merger_Slicer
comp_Merger_Slicer: Merger_Slicer
port map(
        clk                 => CLK,               
        enable              => enable,
        dataUP              => dataUP,         
        reset               => reset,
        BBHeader            => BBHeader_s,
               
        frame_ready         => frame_ready,   
        BBHeader_Datafield  => BBHeader_Datafield,
        UP_reset            => dataUP_received,
        
        x_out               => x_out,
        count_out           => count_out
        );
-----------------------------------------------------------------------------------------------------------------------------------     
--Instantiation of BBSiganling             
comp_BBSignaling: BBSignaling
port map(
        BBHEADER => BBHeader_s, 
        CLK      => CLK  
        );
-----------------------------------------------------------------------------------------------------------------------------------

end Behavioral;


