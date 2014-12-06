----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    13:31:48 12/03/2014 
-- Design Name: 
-- Module Name:    extension
--
-- Dependencies: 
-- extence all signa to 16bits
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY extension IS
    PORT ( imed10 : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
           imed7 : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
           imed4 : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
           imed3 : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           imed4_2 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           exten10 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
           exten7 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
	   exten7zero : OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0);
           exten4 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
           exten3 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
           exten4_2 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
END extension;

ARCHITECTURE behavioral OF extension IS

BEGIN
    exten10(15 DOWNTO 11) <= (OTHERS=>imed10(10));
    exten10(10 DOWNTO 0) <= imed10;

    exten7(15 DOWNTO 8) <= (OTHERS=>imed7(7));
    exten7(7 DOWNTO 0) <= imed7;

    exten7zero(15 DOWNTO 8) <= (OTHERS => '0');
    exten7zero(7 DOWNTO 0) <= imed7;

    exten4(15 DOWNTO 5) <= (OTHERS=>imed4(4));
    exten4(4 DOWNTO 0) <= imed4;

    exten3(15 DOWNTO 4) <= (OTHERS=>imed3(3));
    exten3(3 DOWNTO 0) <= imed3;

    exten4_2(15 DOWNTO 3) <= (OTHERS=>imed4_2(2));
    exten4_2(2 DOWNTO 0) <= imed4_2;

END behavioral;

