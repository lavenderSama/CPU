----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_rwdata
-- Description:  
--
-- mux for rwdata 
-- when option="000" set out_rwdata to X"0000"
-- when option="001" set out_rwdata = alu
-- when option="010" set out_rwdata = data
-- when option="011" set out_rwdata = b
-- when option="100" set out_rwdata = rx
-- when option="101" set out_rwdata = raddr
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_rwdata IS
    PORT ( in_alu : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_data : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_b : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_rx : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_raddr : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           out_rwdata : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
END mux_rwdata;

ARCHITECTURE behavioral OF mux_rwdata IS

BEGIN
out_rwdata <= in_alu WHEN (option="00") ELSE
			  in_data WHEN (option="01") ElSE
			  in_b WHEN (option="10") ELSE
			  in_rx WHEN (option="11") ElSE
			  X"0000";
END behavioral;
