----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_sp_s 
-- Description:  
-- mux for sp adder
-- when option="00" set out_sp to X"0000"
-- when option="01" set out_sp = sp_addr
-- when option="10" set out_sp = rx
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_sp_s IS
    PORT ( sp_adder : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ry : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC;
           out_sp : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
END mux_sp_s;

ARCHITECTURE behavioral OF mux_sp_s IS

BEGIN
out_sp <= sp_adder WHEN (option='0') ELSE
		ry WHEN (option='1') ElSE
		X"0000";
END behavioral;

