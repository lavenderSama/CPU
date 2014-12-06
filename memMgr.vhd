LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memMgr is
	port(
				clk: in std_logic;
				MEM: in std_logic; --0 for read; 1 for write
				Ram1Addr : out  STD_LOGIC_VECTOR (17 downto 0);
				Ram1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
				Ram1OE : out  STD_LOGIC;
				Ram1WE : out  STD_LOGIC;
				Ram1EN : out  STD_LOGIC;
				wrn : out std_logic := '1';
        rdn : out std_logic := '1';
				Ram2Addr : buffer  STD_LOGIC_VECTOR (17 downto 0);
        Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
				Ram2OE : out  STD_LOGIC;
				Ram2WE : out  STD_LOGIC;
				Ram2EN : out  STD_LOGIC;
				PC: in std_logic_vector(15 downto 0);
				INS: out std_logic_vector(15 downto 0);
				Address: in std_logic_vector(15 downto 0);
				WriteData: in std_logic_vector(15 downto 0);
				Data: out std_logic_vector(15 downto 0):= (others => '0');
				data_ready: in std_logic;
				tbre: in std_logic;
				tsre: in std_logic
			);
end entity;
	
architecture Behavioral of memMgr is
	component IM is
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
	end component;
	component DM is
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
	end component;
	signal PC_18, Address_18: std_logic_vector(17 downto 0):= (others => '0');
begin
	PC_18 <= "00"&PC;
	Address_18 <= "00"&Address;
	IM_unit: IM port map
		(clk, '1', Ram2Addr, Ram2Data, Ram2OE, Ram2WE, Ram2EN, PC_18, INS);
	DM_unit: DM port map
		(clk, '1', MEM, Ram1Addr, Ram1Data, Ram1OE, Ram1WE, Ram1EN, wrn, rdn, Address_18, WriteData, Data, data_ready, tbre, tsre);
end architecture;