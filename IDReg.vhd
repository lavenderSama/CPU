LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDReg is
	port(
				clk: in std_logic;
				
				Control_PC_in: in std_logic_vector(2 downto 0);
				Control_A_in: in std_logic_vector(2 downto 0);
				Control_B_in: in std_logic_vector(3 downto 0);
				Control_ALU_in: in std_logic_vector(2 downto 0);
				Control_MEM_in: in std_logic;
				Control_WData_in: in std_logic;
				Control_Raddr_in: in std_logic_vector(1 downto 0);
				Control_RWData_in: in std_logic_vector(1 downto 0);
				Control_IH_in: in std_logic;
				Control_SP_in: in std_logic;
				Control_RA_in: in std_logic;
				Control_T_in: in std_logic;
				Control_RF_in: in std_logic;
				Control_SP_S_in: in std_logic;
				PC_1_in: in std_logic_vector(15 downto 0);
				IH_in: in std_logic_vector(15 downto 0);
				SP_in: in std_logic_vector(15 downto 0);
				RA_in: in std_logic_vector(15 downto 0);
				T_in: in std_logic_vector(15 downto 0);
				RX_in: in std_logic_vector(15 downto 0);
				RY_in: in std_logic_vector(15 downto 0);
				IM_10_0_in: in std_logic_vector(15 downto 0);
				IM_7_0_zero_in: in std_logic_vector(15 downto 0);
				IM_7_0_sign_in: in std_logic_vector(15 downto 0);
				IM_4_0_in: in std_logic_vector(15 downto 0);
				IM_3_0_in: in std_logic_vector(15 downto 0);
				IM_4_2_in: in std_logic_vector(15 downto 0);
				Addr_RX_in: in std_logic_vector(2 downto 0);
				Addr_RY_in: in std_logic_vector(2 downto 0);
				Addr_RZ_in: in std_logic_vector(2 downto 0);
				
				Control_PC_out: out std_logic_vector(2 downto 0);
				Control_A_out: out std_logic_vector(2 downto 0);
				Control_B_out: out std_logic_vector(3 downto 0);
				Control_ALU_out: out std_logic_vector(2 downto 0);
				Control_MEM_out: out std_logic;
				Control_WData_out: out std_logic;
				Control_Raddr_out: out std_logic_vector(1 downto 0);
				Control_RWData_out: out std_logic_vector(1 downto 0);
				Control_IH_out: out std_logic;
				Control_SP_out: out std_logic;
				Control_RA_out: out std_logic;
				Control_T_out: out std_logic;
				Control_RF_out: out std_logic;
				Control_SP_S_out: out std_logic;
				PC_1_out: out std_logic_vector(15 downto 0);
				IH_out: out std_logic_vector(15 downto 0);
				SP_out: out std_logic_vector(15 downto 0);
				RA_out: out std_logic_vector(15 downto 0);
				T_out: out std_logic_vector(15 downto 0);
				RX_out: out std_logic_vector(15 downto 0);
				RY_out: out std_logic_vector(15 downto 0);
				IM_10_0_out: out std_logic_vector(15 downto 0);
				IM_7_0_zero_out: out std_logic_vector(15 downto 0);
				IM_7_0_sign_out: out std_logic_vector(15 downto 0);
				IM_4_0_out: out std_logic_vector(15 downto 0);
				IM_3_0_out: out std_logic_vector(15 downto 0);
				IM_4_2_out: out std_logic_vector(15 downto 0);
				Addr_RX_out: out std_logic_vector(2 downto 0);
				Addr_RY_out: out std_logic_vector(2 downto 0);
				Addr_RZ_out: out std_logic_vector(2 downto 0)
			);
end entity;

architecture Behavioral of IDReg is
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			Control_PC_out <= Control_PC_in;
			Control_A_out <= Control_A_in;
			Control_B_out <= Control_B_in;
			Control_ALU_out <= Control_ALU_in;
			Control_MEM_out <= Control_MEM_in;
			Control_WData_out <= Control_WData_in;
			Control_RAddr_out <= Control_RAddr_in;
			Control_RWData_out <= Control_RWData_in;
			Control_IH_out <= Control_IH_in;
			Control_SP_out <= Control_SP_in;
			Control_RA_out <= Control_RA_in;
			Control_T_out <= Control_T_in;
			Control_RF_out <= Control_RF_in;
			Control_SP_S_out <= Control_SP_S_in;
			PC_1_out <= PC_1_in;
			IH_out <= IH_in;
			SP_out <= SP_in;
			RA_out <= RA_in;
			T_out <= T_in;
			RX_out <= RX_in;
			RY_out <= RY_in;
			IM_10_0_out <= IM_10_0_in;
			IM_7_0_zero_out <= IM_7_0_zero_in;
			IM_7_0_sign_out <= IM_7_0_sign_in;
			IM_4_0_out <= IM_4_0_in;
			IM_3_0_out <= IM_3_0_in;
			IM_4_2_out <= IM_4_2_in;
			Addr_RX_out <= Addr_RX_in;
			Addr_RY_out <= Addr_RY_in;
			Addr_RZ_out <= Addr_RZ_in;
		end if;
	end process;
end architecture;