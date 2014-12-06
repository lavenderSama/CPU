LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Pause IS
    PORT ( MEM      : IN STD_LOGIC;
           LAST_TO_WRITE: IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT10_8 : IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT7_5  : IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT15_0 : IN STD_LOGIC_VECTOR(15 downto 0);
           PAUSE_SIGNAL: OUT STD_LOGIC);
END Pause;

ARCHITECTURE behavior of Pause IS
BEGIN
	process (MEM, LAST_TO_WRITE, NEXT10_8, NEXT7_5, NEXT15_0)
	begin
    case MEM is
        when '0' => if (LAST_TO_WRITE = NEXT10_8) then
                        case NEXT15_0(15 downto 11) is
                            when "01001" => PAUSE_SIGNAL <='1';
                            when "01000" => PAUSE_SIGNAL <='1';
                            when "11100" => PAUSE_SIGNAL <='1';
                            when "11101" => case NEXT15_0(4 downto 0) is
                                                 when "01011" => PAUSE_SIGNAL <='0';
                                                 when "01111" => PAUSE_SIGNAL <='0';
                                                 when others => PAUSE_SIGNAL <='1';
                                            end case;
                            when "00100" => PAUSE_SIGNAL <='1';
                            when "00101" => PAUSE_SIGNAL <='1';
                            when "10011" => PAUSE_SIGNAL <='1';
                            when "11110" => case NEXT15_0(4 downto 0) is
                                                when "00001" => PAUSE_SIGNAL <='1';
                                                when others => PAUSE_SIGNAL <='0';
                                            end case;
                            when "11011" => PAUSE_SIGNAL <='1';
                            when others => PAUSE_SIGNAL <='0';
                        end case;
                    elsif (LAST_TO_WRITE = NEXT7_5) then
                        case NEXT15_0(15 downto 11) is
                            when "11100" => PAUSE_SIGNAL <= '1';
                            when "11101" => case NEXT15_0(4 downto 0) is
                                                when "01100" => PAUSE_SIGNAL <='1';
                                                when "01010" => PAUSE_SIGNAL <='1';
                                                when "01011" => PAUSE_SIGNAL <='1';
                                                when "01111" => PAUSE_SIGNAL <='1';
                                                when "01101" => PAUSE_SIGNAL <='1';
                                                when "00100" => PAUSE_SIGNAL <='1';
                                                when "00010" => PAUSE_SIGNAL <='1';
                                                when "00111" => PAUSE_SIGNAL <='1';
                                                when "00110" => PAUSE_SIGNAL <='1';
                                                when "01110" => PAUSE_SIGNAL <='1';
                                                when others  => PAUSE_SIGNAL <='0';
                                            end case;
                            when "01111" => PAUSE_SIGNAL <= '1';
                            when "00110" => PAUSE_SIGNAL <= '1';
                            when others => PAUSE_SIGNAL <='0';
                        end case;
                    else
                        PAUSE_SIGNAL<='0';
                    end if;
        when '1' => PAUSE_SIGNAL<='0';
		  when others => PAUSE_SIGNAL<='0';
    end case;
	end process;
END behavior;
