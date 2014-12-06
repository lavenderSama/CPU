----------------------------------------------------------------------------------
-- Engineer: Heaven
-- 
-- Create Date:    11:23:20 12/03/2014 
-- Design Name: 
-- Module Name:    alu
--
-- Dependencies: 
-- when op=X"0" do nothing set c = X"0000"
-- when op=X"1" do c = a + b
-- when op=X"2" do c = a & b
-- when op=X"3" do c = a
-- when op=X"4" do c = (a==b)
-- when op=X"5" do c = a | b
-- when op=X"6" do c = a SLL b
-- when op=X"7" do c = a SRA b
-- when op=X"8" do c = a - b
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY ALU IS
    PORT ( option : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           a : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           b : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           zero : OUT  STD_LOGIC;
           c : BUFFER  STD_LOGIC_VECTOR (15 DOWNTO 0));	--i set c to INOUT because c is used to form SIGNAL zero
END ALU;

ARCHITECTURE behavioral OF ALU IS

FUNCTION to_stdlogic(L:BOOLEAN) RETURN STD_LOGIC IS
BEGIN
	IF L THEN
		RETURN('1');
	ELSE
		RETURN('0');
	END IF;
END FUNCTION to_stdlogic;

BEGIN

PROCESS (option, a, b)
BEGIN
		zero <= to_stdlogic(c = X"0000");
		CASE (option) IS
		WHEN "000" =>
			c <= X"0000";
		WHEN "001" =>
			c <= a + b;
		WHEN "010" =>
			c<=a AND b;
		WHEN "011" =>
			c <= a;
		WHEN "100" =>
			c <= a OR b;
		WHEN "101" =>
			c <= to_stdlogicvector(to_bitvector(a) sll conv_integer(b));
		WHEN "110" =>
			c <= to_stdlogicvector(to_bitvector(a) sra conv_integer(b));
		WHEN "111" =>
			c <= a - b;
		WHEN OTHERS =>
			c <= X"0000";
		END CASE;
END PROCESS;

END behavioral;
