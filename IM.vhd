LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IM is
	port(
				clk: in std_logic;
				en: in std_logic; --0 for disable, 1 for enable
				RamAddr : buffer  STD_LOGIC_VECTOR (17 downto 0);
        RamData : inout  STD_LOGIC_VECTOR (15 downto 0);
				RamOE : out  STD_LOGIC;
				RamWE : out  STD_LOGIC;
				RamEN : out  STD_LOGIC;
				PC:in std_logic_vector(17 downto 0);
				INS:out std_logic_vector(15 downto 0)
			);
end entity;
	
architecture Behavioral of IM is
	type state is (Start, Read);
	signal cur_state, next_state: state:= Start;
begin
	process (en, clk)
	begin
		if (en = '0') then
			cur_state <= Start;
		elsif (clk'event and clk='1') then
			cur_state <= next_state;
		end if;
	end process;
	
	process (cur_state)
	begin
		case cur_state is
			when Start =>
				next_state <= Read;
				RamWE <= '1';
				RamOE <= '1';
				RamEN <= '0';
				RamAddr <= PC;
				RamData <= (others=>'Z');
			when Read =>
				RamWE <= '1';
				RamEN <= '0';
				next_state <= Start;
				RamAddr <= PC;
				INS <= RamData;
				RamOE <= '0';
			when others =>
				next_state <= Start;
		end case;
	end process;

end architecture;