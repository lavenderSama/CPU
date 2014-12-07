LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DM is
	port(
				clk: in std_logic;
				clk_stage: in std_logic;
				en: in std_logic; --0 for disable, 1 for enable
				MEM: in std_logic_vector(1 downto 0); --11 for write; 10 for read; others for nothing
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
				tsre: in std_logic;
				
				DYP0: out std_logic_vector(6 downto 0)
			);
end entity;
	
architecture Behavioral of DM is
	type state is (Start, Write, W_hold, R_ready, R_hold, Read, comWrite1, comWrite2, comRead, Stop);
	signal cur_state, next_state: state:= Start;
	signal out_data: std_logic_vector(15 downto 0);
	signal clk_local: std_logic:= '1';
begin
	process (en, clk)
	begin
		if (en = '0') then
			cur_state <= Start;
		elsif (clk'event and clk = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	process (clk, clk_stage)
	begin
		if (clk'event and clk = '1') then
			clk_local <= clk_stage;
		end if;
	end process;
	
	process (cur_state)
	begin
		case cur_state is
			when Start =>
				case Address is
					when "00"&X"BF00" => --write/read to/from com
						Data <= out_data;
						case MEM is
							when "11" =>
								next_state <= comWrite1 ; --write to com
								RamData <= WriteData;
		            RamEN <= '1';
		            RamOE <= '1';
		            RamWE <= '1';
		            wrn <= '1';
		            rdn <= '1';
							when "10" =>
								next_state <= comRead ; --read from com
	              RamEN <= '1';
	              RamOE <= '1';
	              RamWE <= '1';
	              wrn <= '1';
	              rdn <= '1';
	              RamData <= (others => 'Z');
							when others =>
								next_state <= Start;
						end case;
					when "00"&X"BF01" => --read com state
						Data <= "00000000000000"&'1'&(tsre and tbre);
      			next_state <= Start;
					when others =>
						Data <= out_data;
            RamWE <= '1';
		        RamOE <= '1';
		        RamEN <= '0';
		        RamAddr <= Address;
						wrn <= '1';
						rdn <= '1';
						case MEM is
							when "11" =>
							when "10" =>
							when others =>
						end case;
						if (MEM = '1') then
							next_state <= Write;
							RamData <= WriteData;
						else
							next_state <= R_ready;
							RamData <= (others=>'Z');
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
				next_state <= Stop;
			
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
				RamData <= (others=>'Z');
				Data <= RamData;
				RamOE <= '0';
				next_state <= R_hold;
			when R_hold =>
				wrn <= '1';
				rdn <= '1';
				RamWE <= '1';
				RamEN <= '0';
				RamOE <= '0';
				RamAddr <= Address;
				RamData <= (others=>'Z');
				Data <= RamData;
				if (clk_local = '0' and clk_stage = '1') then
      		next_state <= Start;
      	else
      		next_state <= R_hold;
      	end if;
			
      when comWrite1 =>
      	RamEN <= '1';
        RamOE <= '1';
        RamWE <= '1';
        RamData <= WriteData;
        wrn <= '0';
        next_state <= comWrite2;
      when comWrite2 =>
      	RamEN <= '1';
        RamOE <= '1';
        RamWE <= '1';
        wrn <= '1';
        next_state <= Stop;
      
      when comRead =>
      	RamEN <= '1';
        RamOE <= '1';
        RamWE <= '1';
        wrn <= '1';
        rdn <= '0';
        Data(7 downto 0) <= RamData(7 downto 0);
        if (clk_local = '0' and clk_stage = '1') then
      		next_state <= Start;
      	else
      		next_state <= comRead;
      	end if;
      
      when Stop => 
      	wrn <= '1';
				rdn <= '1';
				RamWE <= '1';
				RamEN <= '1';
				RamOE <= '1';
      	if (clk_local = '0' and clk_stage = '1') then
      		next_state <= Start;
      	else
      		next_state <= Stop;
      	end if;
      
			when others =>
				next_state <= Stop;
		end case;
	end process;

	process (cur_state)
	begin
		case cur_state is
			when Start => DYP0 <= "0000001";
			when R_ready => DYP0 <= "0000011";
			when read => DYP0 <= "0000111";
			when Stop => DYP0 <= "0001111";
			when others => DYP0 <= "1111111";
		end case;
	end process;

end architecture;
