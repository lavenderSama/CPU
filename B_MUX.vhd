LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY B_MUX IS
    PORT ( RY       :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_10   :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_7ZERO:  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_7SIGN:  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_4    :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_3    :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ADDR42   :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ALU      :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           DATA     :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           B        :  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           RB       :  IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           OUTPUT   :  OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));

END B_MUX;

ARCHITECTURE behavior OF B_MUX IS

BEGIN

PROCESS(RY, IMM_10, IMM_7ZERO, IMM_7SIGN, IMM_4, IMM_3, ADDR42, ALU, DATA, B, RB)
BEGIN
case RB is
    when "01" => OUTPUT <= ALU;
    when "10" => OUTPUT <= DATA;
    when "00" => case B is
                    when "0000" => OUTPUT<= "0000000000000001";
                    when "0001" => OUTPUT<= "0000000000000000";
                    when "0010" => OUTPUT<= RY;
                    when "0011" => OUTPUT<= IMM_10;
                    when "0100" => OUTPUT<= IMM_7ZERO;
                    when "0101" => OUTPUT<= IMM_7SIGN;
                    when "0110" => OUTPUT<= IMM_4;
                    when "0111" => OUTPUT<= IMM_3;
                    when "1000" => OUTPUT<= ADDR42;
						  when others => NULL;
                 end case;
    when others => OUTPUT <= "0000000000000000";
end case;
END PROCESS;

END behavior;
