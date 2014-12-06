LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RF is
	port(
				clk: in std_logic;
				rst: in std_logic; --0 for reset, others for normal function
				Control_RF: in std_logic; --1 for write, others for not write
				
				INS_10_8: in std_logic_vector(2 downto 0);
				INS_7_5: in std_logic_vector(2 downto 0);
				RX: out std_logic_vector(15 downto 0);
				RY: out std_logic_vector(15 downto 0);
				
				RAddr: in std_logic_vector(2 downto 0);
				WD: in std_logic_vector(15 downto 0);
				
				Debug_Addr: in std_logic_vector(2 downto 0);
				Debug_Data: out std_logic_vector(15 downto 0)
			);
end entity;

architecture Behavioral of RF is
	component QReg_16 is
		port(
					clk: in std_logic;
					rst: in std_logic; --0 for reset, others for normal function
					D_in: in std_logic_vector(15 downto 0); --input data
					D_out: out std_logic_vector(15 downto 0) --output data
				);
	end component;
	signal R0 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R1 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R2 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R3 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R4 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R5 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R6 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal R7 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
	process (clk, rst)
	begin
		if (rst = '0') then
			R0 <= (others => '0');
			R1 <= (others => '0');
			R2 <= (others => '0');
			R3 <= (others => '0');
			R4 <= (others => '0');
			R5 <= (others => '0');
			R6 <= (others => '0');
			R7 <= (others => '0');
		elsif (Control_RF = '1' and clk'event and clk = '1') then
			case RAddr is
				when "000" => R0 <= WD;
				when "001" => R1 <= WD;
				when "010" => R2 <= WD;
				when "011" => R3 <= WD;
				when "100" => R4 <= WD;
				when "101" => R5 <= WD;
				when "110" => R6 <= WD;
				when "111" => R7 <= WD;
				when others =>
			end case;
		end if;
	end process;
	
	process (INS_10_8)
	begin
		case INS_10_8 is
			when "000" => RX <= R0;
			when "001" => RX <= R1;
			when "010" => RX <= R2;
			when "011" => RX <= R3;
			when "100" => RX <= R4;
			when "101" => RX <= R5;
			when "110" => RX <= R6;
			when "111" => RX <= R7;
			when others => RX <= (others => '0');
		end case;
	end process;
	
	process (INS_7_5)
	begin
		case INS_7_5 is
			when "000" => RY <= R0;
			when "001" => RY <= R1;
			when "010" => RY <= R2;
			when "011" => RY <= R3;
			when "100" => RY <= R4;
			when "101" => RY <= R5;
			when "110" => RY <= R6;
			when "111" => RY <= R7;
			when others => RY <= (others => '0');
		end case;
	end process;
	
	process (Debug_Addr)
	begin
		case Debug_Addr is
			when "000" => Debug_Data <= R0;
			when "001" => Debug_Data <= R1;
			when "010" => Debug_Data <= R2;
			when "011" => Debug_Data <= R3;
			when "100" => Debug_Data <= R4;
			when "101" => Debug_Data <= R5;
			when "110" => Debug_Data <= R6;
			when "111" => Debug_Data <= R7;
			when others => Debug_Data <= (others => '0');
		end case;
	end process;
end architecture;