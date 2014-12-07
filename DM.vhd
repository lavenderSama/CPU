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
begin
	process (clk)
	begin
		if (en = '0') then
			Data <= (others => '0');
		elsif (clk'event and clk = '0') then
			Data <= RamData;
			case Address is
				when "00"&X"BF00" => --write/read to/from com
					RamEN <= '1';
          RamOE <= '1';
          RamWE <= '1';
					if (MEM = '1') then --write to com
						wrn <= '0';
						RamData <= WriteData;
					else --read from com
						wrn <= '1';
            rdn <= '1';
            RamData <= (others => 'Z');
					end if;
				when "00"&X"BF01" => --read com state
					Data <= "00000000000000"&data_ready&tsre;
				when others =>
	        RamEN <= '0';
	        RamData <= WriteData;
					wrn <= '1';
					rdn <= '1';
					if (MEM = '1') then
						RamWE <= '0';
						RamOE <= '1';
					else
						RamWE <= '1';
						RamOE <= '0';
					end if;
			end case;
		end if;
		if (clk = '1') then
			RamEN <= '1';
			RamWE <= '1';
			RamOE <= '1';
			rdn <= '1';
			wrn <= '1';
			RamAddr <= Address;
		end if;
	end process;

end architecture;
