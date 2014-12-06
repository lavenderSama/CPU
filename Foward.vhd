LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Foward IS
    PORT (A :  IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          B :  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
          ADDR7_5: IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          ADDR10_8: IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          RF1   : IN STD_LOGIC;
          RF2   : IN STD_LOGIC;
			 RAddr1 : IN STD_LOGIC_VECTOR(2 downto 0);
			 RAddr2 : IN STD_LOGIC_VECTOR(2 downto 0);
          RA    : OUT STD_LOGIC_VECTOR(1 downto 0);
          RB    : OUT STD_LOGIC_VECTOR(1 downto 0));
END Foward;

ARCHITECTURE behavior OF Foward IS

BEGIN
PROCESS (A, B, ADDR7_5, ADDR10_8, RF1, RF2)
BEGIN
    case RF1 is
        when '0' => case RF2 is
                        when '0' => RA<="00";
                                    RB<="00";
                        when '1' => if (RAddr2=ADDR10_8 and A="101") then
                                        RA<="10";
                                        RB<="00";
                                    elsif (RAddr2=ADDR7_5 and B="0010") then
                                        RA<="00";
                                        RB<="10";
                                    else
                                        RA<="00";
                                        RB<="00";
                                    end if;
								when others => RA<="00";
													RB<="00";
                    end case;
        when '1' => case RF2 is
                        when '0'=>  if (RAddr1=ADDR10_8 and A="101") then
                                        RA<="01";
                                        RB<="00";
                                    elsif (RAddr1=ADDR7_5 and B="0010") then
                                        RA<="00";
                                        RB<="01";
                                    else
                                        RA<="00";
                                        RB<="00";
                                    end if;
                        when '1'=>  if (RAddr1=ADDR10_8 and A="101") then
                                        if (RAddr2=ADDR7_5 and B="0010") then
                                            RA<="01";
                                            RB<="10";
                                        else
                                            RA<="01";
                                            RB<="00";
                                        end if;
                                    elsif (RAddr1=ADDR7_5 and B="0010") then
                                        if (RAddr2=ADDR10_8 and A="101") then
                                            RA<="10";
                                            RB<="01";
                                        else
                                            RA<="00";
                                            RB<="01";
                                        end if;
                                    else
                                        if (RAddr1=ADDR10_8 and A="101") then
                                            RA<="01";
                                            RB<="00";
                                        elsif (RAddr1=ADDR7_5 and B="0010") then
                                            RA<="00";
                                            RB<="01";
                                        else
                                            RA<="00";
                                            RB<="00";
                                        end if;
                                    end if;
								when others => RA<="00";
													RB<="00";
                    end case;
				  when others => RA<="00";
                             RB<="00";
			END CASE;
END PROCESS;
END behavior;
