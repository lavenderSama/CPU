----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_raddr
-- Description:  
-- mux for raddr
-- when option="00" set out_raddr to "000"
-- when option="01" set out_raddr = 10-8
-- when option="10" set out_raddr = 7-5
-- when option="11" set out_raddr = 4-2
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_raddr IS
    PORT ( addr10_8 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           addr7_5 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           addr4_2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
           option : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           out_raddr : OUT  STD_LOGIC_VECTOR (2 DOWNTO 0));
END mux_raddr;

ARCHITECTURE behavioral OF mux_raddr IS

BEGIN
out_raddr <= addr10_8 WHEN (option="01") ELSE
			 addr7_5 WHEN (option="10") ElSE
			 addr4_2 WHEN (option="11") ELSE
			 "000";
END behavioral;
