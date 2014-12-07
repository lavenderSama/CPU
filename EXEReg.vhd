LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EXEReg is
	port(
				clk: in std_logic;
				rst: in std_logic;
				
				Control_MEM_in: in std_logic_vector(1 downto 0);
				Control_RWData_in: in std_logic_vector(1 downto 0);
				Control_RF_in: in std_logic;
				ALU_in: in std_logic_vector(15 downto 0);
				MWD_in: in std_logic_vector(15 downto 0);
				RAddr_in: in std_logic_vector(2 downto 0);
				
				Control_MEM_out: out std_logic_vector(1 downto 0);
				Control_RWData_out: out std_logic_vector(1 downto 0);
				Control_RF_out: out std_logic;
				ALU_out: out std_logic_vector(15 downto 0);
				MWD_out: out std_logic_vector(15 downto 0);
				RAddr_out: out std_logic_vector(2 downto 0)
			);
end entity;

architecture Behavioral of EXEReg is
begin
	process (clk)
	begin
		if (rst = '0') then
			Control_MEM_out <= (others => '0');
			Control_RWData_out <= (others => '0');
			Control_RF_out <= '0';
			ALU_out <= (others => '0');
			MWD_out <= (others => '0');
			RAddr_out <= (others => '0');
		elsif (clk'event and clk = '1') then
			Control_MEM_out <= Control_MEM_in;
			Control_RWData_out <= Control_RWData_in;
			Control_RF_out <= Control_RF_in;
			ALU_out <= ALU_in;
			MWD_out <= MWD_in;
			RAddr_out <= RAddr_in;
		end if;
	end process;
end architecture;