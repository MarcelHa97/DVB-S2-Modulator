----------------------------------------------------------------------------------
-- Company: DHBW Ravensburg Campus Friedrichshafen - SeeSat e.V
-- Engineer: Mert-Can Ünlü
-- 
-- Create Date: 20.01.2021 19:33:38
-- Design Name: BB_Signaling
-- Module Name: BBSiganling
-- Project Name: DVB-S2
-- Target Devices: Unknown
-- Tool Versions: 2020.1
-- Description: BBSignaling
-- 
-- Dependencies: The BBSignaling Block generates the BBHeader.
--               The BBHeader consist of 80 Bits.
--               The BBHeader is placed in front of each data field

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BBSignaling is      
port(    
    BBHEADER          : OUT std_logic_vector(80 downto 1);  
    CLK               : IN  std_logic
        );
end BBSignaling;



architecture Behavioral of BBSignaling is
-------------------------------------------------------------------------------------------------------------------------------------------
--BBHEADER(80 Bits) = MATYPE(16 Bits) | UPL(16 Bits) | DFL(16 Bits) | SYNC(8 Bits) | SYNCD(16 Bits) | CRC-8(8 Bits)
signal BBHEADER_s : std_logic_vector(0 to 79)         := x"00000000000000000000";      --BBHEADER(80 Bits)
------------------------------------------------------------------------------------------------------------------------------------------- 
--Initialization MATYPE(2 Bytes) = MATYPE_1 | MATYPE_2:
 signal MATYPE        : std_logic_vector(15 downto 0) := x"0000";
       
  signal MATYPE_1     : std_logic_vector(0 to 7)      := x"00";                        --First byte of BBHEADER(8 Bits)
    signal TS_GS      : std_logic_vector(1 downto 0)  := "11";                         --11=Transport, (X)00=Generic Packetized, 01=Generic continous, 10=reserved 
    signal SIS_MIS    : std_logic                     := '1';                          --(X)1=single, 0=multiple
    signal CCM_ACM    : std_logic                     := '1';                          --(1)1=CCM, 0=ACM
    signal ISSYI      : std_logic                     := '0';                          --1=active, (X)0=not active
    signal NPD        : std_logic                     := '0';                          --1=active, (x)0=not-active
    signal RO         : std_logic_vector(1 downto 0)  := "01";                         --00=0.35, 01=0.25(X), 10=0.20, 11=reserved
    
  signal MATYPE_2     : std_logic_vector(7 downto 0)  := x"00";                        --Second Byte of BBHEADER(8 Bits):If SIS/MIS = Multiple Input Stream, then second byte = Input Stream Identifier (ISI); else second byte reserved.  
----------------------------------------------------------------------------------------------------------------------------------------------   
  signal UPL          : std_logic_vector(15 downto 0) := x"0000";                      --User Packet Length(UPL) in bits, in the range 0 to 65535
    
  signal DFL          : std_logic_vector(15 downto 0) := x"0000";                      --Data Field Length in bits, in the range 0 to 58112
    
  signal SYNC         : std_logic_vector(7  downto 0) := x"00";                        --Copy of the User Packet Sync-byte; for packetized Transport or Generic Streams: copy of the User Packet Sync byte; for Continuous Generic Streams: SYNC= 00 - B8 reserved for transport layer protocol signaling according to Reference [i.4]; SYNC= B9-FF user private).
    
  signal SYNCD        : std_logic_vector(15 downto 0) := x"0000";                      --This value is in our DVB-S2 Standard everytime 0 because we store only entire UPs in the Datafield form left to right
    
  signal CRC8         : std_logic_vector(7  downto 0) := x"00";                        --error detection code applied to the first 9 bytes of the BBHEADER.(Will be set by the CRC8_BBHeader)
----------------------------------------------------------------------------------------------------------------------------------------------
component CRC8_BBHeader
    Port (
          inData_BBHeader:  in      std_logic_vector(71 downto 0);                     -- Input the first 72(from left to right) Bits of the BBHeader
          CLK:              in      std_logic;                                         -- Clock
          outDataCRC:       out     std_logic_vector(7 downto 0)                       -- CRC error code with a length of 8 bit
          );
end component;
-----------------------------------------------------------------------------------------------------------------------------------------------
--Signals:
signal outDataCRC_s     :  std_logic_vector(7 downto 0);
-----------------------------------------------------------------------------------------------------------------------------------------------


begin
-----------------------------------------------------------------------------------------------------------------------------------------------
--Instatiation of CRC8_BBHeader
    comp_CRC8_BBHeader: CRC8_BBHeader 
    port map(
             CLK              => CLK, 
             inData_BBHeader  => BBHEADER_s(0 to 71),  
             outDataCRC       => outDataCRC_s
             );
------------------------------------------------------------------------------------------------------------------------------------------------    
    --Initialization BBHEADER
    BBHEADER                            <= BBHEADER_s;  
    
    BBHEADER_s(0  to 15)                <= MATYPE;     
    BBHEADER_s(16 to 31)                <= UPL;
    BBHEADER_s(32 to 47)                <= DFL;
    BBHEADER_s(48 to 55)                <= SYNC;
    BBHEADER_s(56 to 71)                <= SYNCD;
    BBHEADER_s(72 to 79)                <= CRC8;
    
    --Initialization MATTYPE
    MATYPE(7  downto 0)                <= MATYPE_2;
    MATYPE(15 downto 8)                <= MATYPE_1; 

    --Initialization MATTYPE_1
    MATYPE_1(0 to 1)                   <= TS_GS;
    MATYPE_1(2)                        <= SIS_MIS;   
    MATYPE_1(3)                        <= CCM_ACM;
    MATYPE_1(4)                        <= ISSYI;
    MATYPE_1(5)                        <= NPD;
    MATYPE_1(6 to 7)                   <= RO;
    
    --Initialization CRC8-Byte
    CRC8                               <= outDataCRC_s;
    
end Behavioral;
