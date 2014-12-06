----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_wdata 
-- Description:  
-- mux for wdata
-- when option="00" set out_wdata to X"0000"
-- when option="01" set out_wdata = rx
-- when option="10" set out_wdata = ry
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_wdata IS
    PORT ( rx : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ry : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC;
           out_wdata : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
END mux_wdata;

ARCHITECTURE behavioral OF mux_wdata IS

BEGIN
out_wdata <= rx WHEN (option='0') ELSE
			 ry WHEN (option='1') ElSE
			 X"0000";
END behavioral;
