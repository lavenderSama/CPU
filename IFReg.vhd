LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFReg is
	port(
				clk: in std_logic;
				
				PC_1_in: in std_logic_vector(15 downto 0);
				PC_in: in std_logic_vector(15 downto 0);
				INS_15_0_in: in std_logic_vector(15 downto 0);
				INS_10_8_in: in std_logic_vector(2 downto 0);
				INS_7_5_in: in std_logic_vector(2 downto 0);
				INS_10_0_in: in std_logic_vector(10 downto 0);
				INS_7_0_in: in std_logic_vector(7 downto 0);
				INS_4_0_in: in std_logic_vector(4 downto 0);
				INS_3_0_in: in std_logic_vector(3 downto 0);
				INS_4_2_in: in std_logic_vector(2 downto 0);
				
				PC_1_out: out std_logic_vector(15 downto 0);
				PC_out: out std_logic_vector(15 downto 0);
				INS_15_0_out: out std_logic_vector(15 downto 0);
				INS_10_8_out: out std_logic_vector(2 downto 0);
				INS_7_5_out: out std_logic_vector(2 downto 0);
				INS_10_0_out: out std_logic_vector(10 downto 0);
				INS_7_0_out: out std_logic_vector(7 downto 0);
				INS_4_0_out: out std_logic_vector(4 downto 0);
				INS_3_0_out: out std_logic_vector(3 downto 0);
				INS_4_2_out: out std_logic_vector(2 downto 0)
			);
end entity;

architecture Behavioral of IFReg is
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			PC_1_out <= PC_1_in;
			PC_out <= PC_in;
			INS_15_0_out <= INS_15_0_in;
			INS_10_8_out <= INS_10_8_in;
			INS_7_5_out <= INS_7_5_in;
			INS_10_0_out <= INS_10_0_in;
			INS_7_0_out <= INS_7_0_in;
			INS_4_0_out <= INS_4_0_in;
			INS_3_0_out <= INS_3_0_in;
			INS_4_2_out <= INS_4_2_in;
		end if;
	end process;
end architecture;