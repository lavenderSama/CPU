----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_wdata 
-- Description:  
-- mux for wdata
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_wdata IS
    PORT ( in_rx : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_ry : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_alu : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_rwdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC;
           out_wdata : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
           rmwd : IN STD_LOGIC_VECTOR (1 DOWNTO 0));
END mux_wdata;

ARCHITECTURE behavioral OF mux_wdata IS

BEGIN

PROCESS (in_rx, in_ry, in_alu, in_rwdata, option)
BEGIN
	CASE rmwd IS
		when "01" =>
			out_wdata <= in_rwdata;
		when "10" =>
			out_wdata <= in_alu;
		when others =>
			IF option='0' THEN
				out_wdata <= in_rx;
			ElSIF option='1' THEN
				out_wdata <= in_ry;
			ElSE
				out_wdata<=X"0000";
			END IF;
	END CASE;
END PROCESS;

END behavioral;
