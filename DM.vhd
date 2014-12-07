LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DM is
	port(
				clk: in std_logic;
				en: in std_logic; --0 for disable, 1 for enable
				MEM: in std_logic; --1 for write; others for read
				RamAddr : buffer  STD_LOGIC_VECTOR (17 downto 0);
				RamData : inout  STD_LOGIC_VECTOR (15 downto 0);
				RamOE : out  STD_LOGIC;
				RamWE : out  STD_LOGIC;
				RamEN : out  STD_LOGIC;
				wrn : out std_logic;
				rdn : out std_logic;
				Address: in std_logic_vector(17 downto 0);
				WriteData: in std_logic_vector(15 downto 0);
				Data: out std_logic_vector(15 downto 0):= (others => '0');
				data_ready: in std_logic;
				tbre: in std_logic;
				tsre: in std_logic
			);
end entity;
	
architecture Behavioral of DM is
	type state is (Start, Write, W_hold, R_ready, Read, comWrite1, comWrite2, comRead);
	signal cur_state, next_state: state:= Start;
begin
	process (en, clk)
	begin
		if (en = '0') then
			cur_state <= Start;
		elsif (clk'event and clk = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	process (clk)
	begin
		case cur_state is
			when Start =>
				case Address is
					when "00"&X"BF00" => --write/read to/from com
						if (MEM = '1') then
							next_state <= comWrite1 ; --write to com
							RamData <= WriteData;
	            RamEN <= '1';
	            RamOE <= '1';
	            RamWE <= '1';
	            wrn <= '1';
						else
							next_state <= comRead ; --read from com
              RamEN <= '1';
              RamOE <= '1';
              RamWE <= '1';
              wrn <= '1';
              rdn <= '1';
              RamData <= (others => 'Z');
						end if;
					when "00"&X"BF01" => --read com state
						Data <= "00000000000000"&data_ready&tsre;
						next_state <= Start;
					when others =>
            RamWE <= '1';
		        RamOE <= '1';
		        RamEN <= '0';
		        RamAddr <= Address;
		        RamData <= WriteData;
						wrn <= '1';
						rdn <= '1';
						if (MEM = '1') then
							next_state <= Write;
						else
							next_state <= R_ready;
						end if;
				end case;
			
			when Write =>
				wrn <= '1';
				rdn <= '1';
				RamOE <= '1';
				RamEN <= '0';
				RamWE <= '0';
				RamAddr <= Address;
				RamData <= WriteData;
				next_state <= W_hold;
			when W_hold =>
				wrn <= '1';
				rdn <= '1';
				RamOE <= '1';
				RamEN <= '0';
				RamWE <= '1';
				RamAddr <= Address;
				RamData <= WriteData;
				next_state <= Start;
			
			when R_ready =>
				wrn <= '1';
				rdn <= '1';
				RamWE <= '1';
				RamOE <= '1';
				RamEN <= '0';
				RamAddr <= Address;
				RamData <= (others=>'Z');
				next_state <= Read;
			when Read =>
				wrn <= '1';
				rdn <= '1';
				RamWE <= '1';
				RamEN <= '0';
				RamAddr <= Address;
				Data <= RamData;
				RamOE <= '0';
				next_state <= Start;
			
      when comWrite1 =>
        RamData <= WriteData;
        wrn <= '0';
        next_state <= comWrite2;
      when comWrite2 =>
        wrn <= '1';
        next_state <= Start;
      
      when comRead =>
        Data(7 downto 0) <= RamData(7 downto 0);
        next_state <= Start;
      
			when others =>
				next_state <= Start;
		end case;
	end process;

end architecture;
