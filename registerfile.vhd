--------------------------------------------------------------
-- Project          : VHDL description of ARC processor (chapter 5)
--                    "Computer Architecture and Organisation" (ISBN 978-0-471-73388-1) by Murdocca and Heuring
-- 
-- File             : registerfile.vhd
--
-- Related File(s)  : utilities.vhd
--
-- Author           : E. Molenkamp, University of Twente, the Netherlands
-- Email            : e.molenkamp@utwente.nl
-- 
-- Project          : Computer Organization
-- Creation Date    : 27 June 2008
-- 
-- Contents         : registerfile
--
-- Change Log 
--   Author         : 
--   Email          : 
--   Date           :  
--   Changes        :
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.utilities.ALL;
ENTITY registerfile IS
  PORT (
    Clk : IN std_logic;

    BusA : OUT std_logic_vector(31 DOWNTO 0);
    SelA : IN  std_logic_vector( 5 DOWNTO 0);  
    BusB : OUT std_logic_vector(31 DOWNTO 0);
    SelB : IN  std_logic_vector( 5 DOWNTO 0);  
    BusC : IN  std_logic_vector(31 DOWNTO 0);
    SelC : IN  std_logic_vector( 5 DOWNTO 0);
    IR   : OUT std_logic_vector(31 DOWNTO 0)
  );
END ENTITY registerfile;

ARCHITECTURE three_port OF registerfile IS

  TYPE reg_file_type IS ARRAY (181 DOWNTO 0) OF std_logic_vector(31 DOWNTO 0);
  SIGNAL reg_file : reg_file_type := (OTHERS=>(OTHERS=>'0'));
  SIGNAL windows_ov : std_logic := '0';
  SIGNAL windows_un : std_logic := '0';
  ATTRIBUTE ram_block: boolean;
  ATTRIBUTE ram_block OF reg_file: SIGNAL IS true;  
 
BEGIN

  -- check that register file does not have enable in signals
  registers:PROCESS(clk)
    VARIABLE index : natural;
  BEGIN
    IF falling_edge(clk) THEN  
        IF to_integer(signed(reg_file(7))) > 8 THEN
            REPORT "window pointer overflow" SEVERITY error; 
            windows_ov <= '1';
            -- set overflow bit
        ELSIF to_integer(signed(reg_file(7))) < 0 THEN
            REPORT "window pointer underflow" SEVERITY error;
            windows_un <= '1';
            -- set underflow bit
        END IF;
        reg_file(0) <= (OTHERS=>'0');  --%r0 constant zero
        index := decoder(SelC,reg_file(7));
        IF index>0 THEN
            reg_file(index)<= BusC;
        END IF;
    END IF;
  END PROCESS registers;

  BusA <= reg_file(decoder(SelA,reg_file(7)));
  BusB <= reg_file(decoder(SelB,reg_file(7)));  
 
  IR  <= reg_file(13);
    
END ARCHITECTURE three_port;
