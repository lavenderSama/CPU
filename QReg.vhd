LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity QReg is
	port(
				clk: in std_logic;
				rst: in std_logic; --0 for reset, others for normal function
				en: in std_logic; --1 for write, others for not write
				D_in: in std_logic_vector(15 downto 0); --input data
				D_out: out std_logic_vector(15 downto 0):= (others => '0') --output data
			);
end entity;

architecture Behavioral of QReg is
	signal data: std_logic_vector(15 downto 0):= (others => '0');
begin
	D_out <= data;
	
	process (clk, rst)
	begin
		if (rst = '0') then
			data <= (others => '0');
		elsif (en = '1' and clk'event and clk = '1') then
			data <= D_in;
		end if;
	end process;
end architecture;
