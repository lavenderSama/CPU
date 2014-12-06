----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Heaven
-- 
-- Create Date:    14:10:28 12/03/2014 
-- Design Name: 
-- Module Name:    mux_pc
-- Description:  
-- 
-- choose new_pc
-- when option="000" pc = normal
-- when option="001" pc = PCadder
-- when option="010" pc = PCadderZ
-- when option="011" pc = PCadderZ_N
-- when option="100" pc = PCadderT
-- when option="101" pc = PCadderT_N
-- when option="110" pc = rx
-- when option="111" pc = ra
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mux_pc IS
    PORT ( normal : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           PCadder : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           OLD_PC  : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           rx : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           ra : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           zero : IN STD_LOGIC;
           option : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           pc : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
END mux_pc;

ARCHITECTURE behavioral OF mux_pc IS

BEGIN

PROCESS(normal, PCadder, OLD_PC, rx, ra, zero, option)
BEGIN
case option is
    when "000" =>  --normal
        pc <= normal;
    when "001" =>  --B
        pc <= PCadder;
    when "010" =>  --BEQZ,BTNEZ
        case zero is
            when '0' => pc<=normal;
            when '1' => pc<=PCadder;
						when others => pc<=normal;
        end case;
    when "011" =>  --BNEZ,BTEQZ
        case zero is
            when '0' => pc<=PCadder;
            when '1' => pc<=normal;
						when others => pc<=normal;
        end case;
    when "100" =>  --JALR,JR
        pc <= rx;
    when "101" =>  --JRRA
        pc <= ra;
    when others => pc <= normal;
end case;
END PROCESS;
END behavioral;
