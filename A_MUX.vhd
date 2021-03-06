LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY A_MUX IS
    PORT ( PC: IN STD_LOGIC_VECTOR(15 downto 0);
           IH: IN STD_LOGIC_VECTOR(15 downto 0);
           SP: IN STD_LOGIC_VECTOR(15 downto 0);
           T:  IN STD_LOGIC_VECTOR(15 downto 0);
           RX: IN STD_LOGIC_VECTOR(15 downto 0);
           RY: IN STD_LOGIC_VECTOR(15 downto 0);
           ALU:IN STD_LOGIC_VECTOR(15 downto 0);
           DATA:IN STD_LOGIC_VECTOR(15 downto 0);
           OUTPUT: OUT STD_LOGIC_VECTOR(15 downto 0);
           A:  IN STD_LOGIC_VECTOR(2 downto 0);
           RA: IN STD_LOGIC_VECTOR(1 downto 0));
END A_MUX;

ARCHITECTURE behavior OF A_MUX IS

BEGIN
process(RA,A)
BEGIN
    case RA is
        when "01" => OUTPUT<= ALU;
        when "10" => OUTPUT<= DATA;
        when "00" => case A is
                        when "000" => OUTPUT<=PC;
                        when "001" => OUTPUT<=IH;
                        when "010" => OUTPUT<=SP;
                        when "011" => OUTPUT<=T;
                        when "100" => OUTPUT<="0000000000000000";
                        when "101" => OUTPUT<=RX;
                        when "110" => OUTPUT<=RY;
								when others => OUTPUT<=X"0000";
							end case;
        when others => OUTPUT<= "0000000000000000";
    end case;
end process;

END behavior;
