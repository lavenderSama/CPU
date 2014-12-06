LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY controller IS 
    PORT ( INSTRUCTION: IN STD_LOGIC_VECTOR (15 downto 0);
           PAUSE      : IN STD_LOGIC;
           PC:         OUT STD_LOGIC_VECTOR (2 downto 0);
           A:          OUT STD_LOGIC_VECTOR (2 downto 0);
           B:          OUT STD_LOGIC_VECTOR (3 downto 0);
           ALU:        OUT STD_LOGIC_VECTOR (2 downto 0);
           MEM:        OUT STD_LOGIC;
           WDATA:      OUT STD_LOGIC;
           RADDR:      OUT STD_LOGIC_VECTOR (1 downto 0);
           RWDATA:     OUT STD_LOGIC_VECTor (1 downto 0);
           IH:         OUT STD_LOGIC;
           SP:         OUT STD_LOGIC;
           RA:         OUT STD_LOGIC;
           T:          OUT STD_LOGIC;
           RF:         OUT STD_LOGIC;
           SP_S:       OUT STD_LOGIC);

END controller;

ARCHITECTURE behavior OF controller IS

BEGIN

PROCESS(PAUSE, INSTRUCTION)
BEGIN
case PAUSE is
  when '0' =>
    case INSTRUCTION(15 downto 11) is
        when "01001"=> --ADDIU
            PC <= "000";
            A  <= "101";
            B  <= "0101";
            ALU <= "001";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "01";
            RWDATA <= "00";
            IH     <= '0';
            SP     <= '0';
            RA     <= '0';
            T      <= '0';
            RF     <= '1';
            SP_S   <= 'Z';
        when "01000"=> --ADDIU3
            PC  <= "000";
            A   <= "101";
            B   <= "0111";
            ALU <= "001";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "10";
            RWDATA <= "00";
            IH     <= '0';
            SP     <= '0';
            RA     <= '0';
            T      <= '0';
            RF     <= '1';
            SP_S   <= 'Z';
        when "11100"=> --ADDU,SUBU
            PC    <= "000";
            A     <= "101";
            B     <= "0010";
            case INSTRUCTION(1 downto 0) is
                when "01" => ALU <= "001";     --ADDU
                when "11" => ALU <= "111";     --SUBU
                when others => ALU <= "000";
            end case;
            MEM   <= 'Z';
            WDATA   <= 'Z';
            RADDR   <= "11";
            RWDATA  <= "00";
            IH      <= '0';
            SP      <= '0';
            RA      <= '0';
            T       <= '0';
            RF      <= '1';
            SP_S    <= 'Z';
        when "11101"=> --AND,CMP,JR,MFPC,OR,JRRA,JALR
            case INSTRUCTION(4 downto 0) is
                when "00000" =>   --JR,MFPC,JRRA,JALR
                    case INSTRUCTION(7 downto 5) is
                        when "000" =>  --JR
                            PC <= "100";
                            A  <= "ZZZ";
                            B  <= "ZZZZ";
                            ALU <= "ZZZ";
                            MEM <= 'Z';
                            WDATA <= 'Z';
                            RADDR <= "ZZ";
                            RWDATA <= "ZZ";
                            IH  <= '0';
                            SP  <= '0';
                            RA  <= '0';
                            T   <= '0';
                            RF  <= '0';
                            SP_S <= 'Z';
                        when "010" =>  --MFPC
                            PC  <= "000";
                            A   <= "000";
                            B   <= "ZZZZ";
                            ALU <= "011";
                            MEM <= 'Z';
                            WDATA <= 'Z';
                            RADDR <= "01";
                            RWDATA  <= "10";
                            IH  <= '0';
                            SP  <= '0';
                            RA  <= '0';
                            T   <= '0';
                            RF  <= '1';
                            SP_S<= 'Z';
                        when "001" =>  --JRRA
                            PC <= "101";
                            A   <= "ZZZ";
                            B   <= "ZZZZ";
                            ALU <= "ZZZ";
                            MEM <= 'Z';
                            WDATA <= 'Z';
                            RADDR <= "ZZ";
                            RWDATA  <= "ZZ";
                            IH  <= '0';
                            SP  <= '0';
                            RA  <= '0';
                            T   <= '0';
                            RF  <= '0';
                            SP_S<= 'Z';
                        when "110" =>  --JALR
                            PC <= "100";
                            A  <= "ZZZ";
                            B  <= "0000";
                            ALU <= "ZZZ";
                            MEM <= 'Z';
                            WDATA <= 'Z';
                            RADDR <= "ZZ";
                            RWDATA  <= "ZZ";
                            IH  <= '0';
                            SP  <= '0';
                            RA  <= '1';
                            T   <= '0';
                            RF  <= '0';
                            SP_S<= 'Z';
								when others =>
									PC <= "000";
									A  <= "ZZZ";
									B  <= "ZZZZ";
									ALU <= "ZZZ";
									MEM <= 'Z';
									WDATA <= 'Z';
									RADDR <= "ZZ";
									RWDATA <= "ZZ";
									IH  <= 'Z';
									SP  <= 'Z';
									RA  <= 'Z';
									T   <= 'Z';
									RF  <= 'Z';
									SP_S <= 'Z';
                    end case;
                when "01010" =>   --CMP
                    PC <= "000";
                    A  <= "101";
                    B  <= "0010";
                    ALU<= "111";
                    MEM <= 'Z';
                    WDATA <= 'Z';
                    RADDR <= "ZZ";
                    RWDATA  <= "ZZ";
                    IH  <= '0';
                    SP  <= '0';
                    RA  <= '0';
                    T   <= '1';
                    RF  <= '0';
                    SP_S<= 'Z';
                when "01100"| "01101"  =>   
                    PC <= "000";
                    A  <= "101";
                    B  <= "0010";
                    case INSTRUCTION(4 downto 0) is
                        when "01100" => ALU <= "010";
                        when "01101" => ALU <= "100";
								when others => ALU <= "000";
                    end case;
                    MEM <= 'Z';
                    WDATA <= 'Z';
                    RADDR <= "01";
                    RWDATA <= "00";
                    IH  <= '0';
                    SP  <= '0';
                    RA  <= '0';
                    T   <= '0';
                    RF  <= '1';
                    SP_S<= 'Z';
					 when others =>
							PC <= "000";
							A  <= "ZZZ";
							B  <= "ZZZZ";
							ALU <= "ZZZ";
							MEM <= 'Z';
							WDATA <= 'Z';
							RADDR <= "ZZ";
							RWDATA <= "ZZ";
							IH  <= 'Z';
							SP  <= 'Z';
							RA  <= 'Z';
							T   <= 'Z';
							RF  <= 'Z';
							SP_S <= 'Z';
            end case;
        when "00010"=> --B
            PC <= "001";
            A  <= "ZZZ";
            B  <= "0011";
            ALU<= "ZZZ";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "ZZ";
            RWDATA  <= "ZZ";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '0';
            SP_S<= 'Z';
        when "00100"=> --BEQZ
            PC <= "010";
            A  <= "101";
            B  <= "0101"; -- edited by lfw
            ALU <= "011";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "ZZ";
            RWDATA  <= "ZZ";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '0';
            SP_S<= 'Z';
        when "00101"=> --BNEZ
            PC <= "011";
            A  <= "101";
            B  <= "0101";	-- edited by lfw
            ALU <= "011";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "ZZ";
            RWDATA  <= "ZZ";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '0';
            SP_S<= 'Z';

        when "01100"=> --BTEQZ,MTSP,BTNEZ,ADDSP
            case INSTRUCTION(10 downto 8) is
                when "000"|"001" =>     --BTEQZ,BTNEZ
                    case INSTRUCTION(10 downto 8) is
                       when "000" => 
                            PC <= "010";
                       when "001" =>
                            PC <= "011";
							  when others =>
									PC <= "000";
                    end case;
                    A <= "011";
                    B <= "0101";
                    ALU <= "011";
                    MEM <= 'Z';
                    WDATA <= 'Z';
                    RADDR <= "ZZ";
                    RWDATA  <= "ZZ";
                     IH  <= '0';
                     SP  <= '0';
                     RA  <= '0';
                     T   <= '0';
                     RF  <= '0';
                     SP_S<= 'Z';
                when "100" =>  --MTSP
                     PC <= "000";		--edited by lfw
                     A  <= "ZZZ";
                     B  <= "ZZZZ";
                     ALU <= "ZZZ";
                     MEM <= 'Z';
                     WDATA <= 'Z';
                     RADDR <= "ZZ";
                     RWDATA  <= "ZZ";
                     IH  <= '0';
                     SP  <= '1';
                     RA  <= '0';
                     T   <= '0';
                     RF  <= '0';
                     SP_S<= '1';
					when "011" =>  --ADDSP        --changed by lfw
						PC   <= "000";
		            A    <= "ZZZ";
		            B    <= "ZZZZ";
		            ALU  <= "ZZZ";
		            MEM  <= 'Z';
		            WDATA <= 'Z';
		            RADDR <= "ZZ";
		            IH    <= '0';
		            SP    <= '1';
		            RA    <= '0';
		            T     <= '0';
		            RF    <= '0';
		            SP_S  <= '0';
					when others =>
						PC <= "000";
						A  <= "ZZZ";
						B  <= "ZZZZ";
						ALU <= "ZZZ";
						MEM <= 'Z';
						WDATA <= 'Z';
						RADDR <= "ZZ";
						RWDATA <= "ZZ";
						IH  <= 'Z';
						SP  <= 'Z';
						RA  <= 'Z';
						T   <= 'Z';
						RF  <= 'Z';
						SP_S <= 'Z';
            end case;
        when "01101"=> --LI
            PC <= "000";
            A  <= "ZZZ";
            B  <= "0100";
            ALU <= "ZZZ";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "01";
            RWDATA <= "10";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '1';
            SP_S<= 'Z';
        when "10011"=> --LW
            PC <= "000";
            A  <= "101";
            B  <= "0110";
            ALU <= "001";
            MEM <= '0';
            WDATA <= 'Z';
            RADDR <= "10";
            RWDATA <= "01";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '1';
            SP_S <= 'Z';
        when "10010"=> --LW_SP
            PC <= "000";
            A  <= "010";
            B  <= "0101";
            ALU <= "001";
            MEM <= '0';
            WDATA <= 'Z';
            RADDR <= "01";
            RWDATA <= "01";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '1';
            SP_S <= 'Z';
        when "11110"=> --MFIH,MTIH
            PC <= "000";
            B <= "ZZZZ";
            MEM <= 'Z';
            WDATA <= 'Z';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            SP_S <= 'Z';
            case INSTRUCTION(0) is
                when '0' =>  --MFIH
                    A <= "001";
                    ALU <= "011";
                    RADDR <= "01";
                    RWDATA <= "00";
                    IH <= '0';
                    RF <= '1';
                when '1' =>  --MTIH
                    A <= "ZZZ";
                    ALU <= "ZZZ";
                    RADDR <= "ZZ";
                    RWDATA <= "ZZ";
                    IH <= '1';
                    RF <= '0';
					 when others =>
							A  <= "ZZZ";
							ALU <= "ZZZ";
							RADDR <= "ZZ";
							RWDATA <= "ZZ";
							IH  <= 'Z';
							RF  <= 'Z';
            end case;
        when "00001"=> --NOP
            PC <= "000";
            A  <= "ZZZ";
            B  <= "ZZZZ";
            ALU <= "ZZZ";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "ZZ";
            RWDATA <= "ZZ";
            IH  <= 'Z';
            SP  <= 'Z';
            RA  <= 'Z';
            T   <= 'Z';
            RF  <= 'Z';
            SP_S <= 'Z';
        when "00110"=> --SLL,SRA
            PC <= "000";
            A  <= "110";
            B  <= "1000";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "01";
            RWDATA <= "00";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '1';
            SP_S<= 'Z';
            case INSTRUCTION(1 downto 0) IS
                when "00" => --SLL
                    ALU <= "101";
                when "11" => --SRA
                    ALU <= "110";
					 when others => 
							ALU <= "000";
            end case;
        when "11011"=> --SW
            PC <= "000";
            A  <= "101";
            B  <= "0110";
            ALU <= "001";
            MEM <= '1';
            WDATA <= '1';
            RADDR <= "ZZ";
            RWDATA <= "ZZ";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '0';
            SP_S <= 'Z';
        when "11010"=> --SW_SP
            PC <= "000";
            A <= "010";
            B <= "0101";
            ALU <= "001";
            MEM <= '1';
            WDATA <= '0';
            RADDR <= "ZZ";
            RWDATA <= "ZZ";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '0';
            SP_S <= 'Z';
        when "01111"=> --MOVE
            PC <= "000";
            A <= "110";
            B <= "ZZZZ";
            ALU <= "011";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "01";
            RWDATA <= "00";
            IH  <= '0';
            SP  <= '0';
            RA  <= '0';
            T   <= '0';
            RF  <= '1';
            SP_S<= 'Z';
        when others =>
            PC <= "ZZZ";
            A  <= "ZZZ";
            B  <= "ZZZZ";
            ALU <= "ZZZ";
            MEM <= 'Z';
            WDATA <= 'Z';
            RADDR <= "ZZ";
            RWDATA <= "ZZ";
            IH  <= 'Z';
            SP  <= 'Z';
            RA  <= 'Z';
            T   <= 'Z';
            RF  <= 'Z';
            SP_S <= 'Z';
    end case;
  when '1' =>
        PC <= "ZZZ";
        A  <= "ZZZ";
        B  <= "ZZZZ";
        ALU <= "ZZZ";
        MEM <= 'Z';
        WDATA <= 'Z';
        RADDR <= "ZZ";
        RWDATA <= "ZZ";
        IH  <= 'Z';
        SP  <= 'Z';
        RA  <= 'Z';
        T   <= 'Z';
        RF  <= 'Z';
        SP_S <= 'Z';
	when others =>
			PC <= "000";
			A  <= "ZZZ";
			B  <= "ZZZZ";
			ALU <= "ZZZ";
			MEM <= 'Z';
			WDATA <= 'Z';
			RADDR <= "ZZ";
			RWDATA <= "ZZ";
			IH  <= 'Z';
			SP  <= 'Z';
			RA  <= 'Z';
			T   <= 'Z';
			RF  <= 'Z';
			SP_S <= 'Z';
end case;
END PROCESS;

END behavior;
