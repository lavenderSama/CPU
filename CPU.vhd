LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPU is
	port(
				clk_50: in std_logic;
				clk: in std_logic;
				rst: in std_logic;
				Ram1Addr : out  STD_LOGIC_VECTOR (17 downto 0);
				Ram1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
				Ram1OE : out  STD_LOGIC;
				Ram1WE : out  STD_LOGIC;
				Ram1EN : out  STD_LOGIC;
				wrn : inout std_logic := '1';
        rdn : inout std_logic := '1';
				Ram2Addr : buffer  STD_LOGIC_VECTOR (17 downto 0);
        Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
				Ram2OE : out  STD_LOGIC;
				Ram2WE : out  STD_LOGIC;
				Ram2EN : out  STD_LOGIC;
				data_ready: in std_logic;
				tbre: in std_logic;
				tsre: in std_logic;
				
				DYP0 : out  STD_LOGIC_VECTOR (6 downto 0):=(others => '0'); --7位数码管
        DYP1 : out  STD_LOGIC_VECTOR (6 downto 0):=(others => '0'); --7位数码管
        L : out  STD_LOGIC_VECTOR (15 downto 0):=(others => '0'); --led灯
        SW : in  STD_LOGIC_VECTOR (15 downto 0):=(others => '0') --拨码开关
			);
end entity;

architecture Behavioral of CPU is
	signal IF_PC_Data_Out: std_logic_vector(15 downto 0);
	signal IF_PC_1_in: std_logic_vector(15 downto 0);
	signal IF_PC_in: std_logic_vector(15 downto 0);
	signal IF_INS_15_0_in: std_logic_vector(15 downto 0);
	signal IF_INS_10_8_in: std_logic_vector(2 downto 0);
	signal IF_INS_7_5_in: std_logic_vector(2 downto 0);
	signal IF_INS_10_0_in: std_logic_vector(10 downto 0);
	signal IF_INS_7_0_in: std_logic_vector(7 downto 0);
	signal IF_INS_4_0_in: std_logic_vector(4 downto 0);
	signal IF_INS_3_0_in: std_logic_vector(3 downto 0);
	signal IF_INS_4_2_in: std_logic_vector(2 downto 0);
	
	signal ID_Control_Pause: std_logic;
	signal ID_RF_WD: std_logic_vector(15 downto 0);
	signal ID_Control_PC_in: std_logic_vector(2 downto 0);
	signal ID_Control_A_in: std_logic_vector(2 downto 0);
	signal ID_Control_B_in: std_logic_vector(3 downto 0);
	signal ID_Control_ALU_in: std_logic_vector(2 downto 0);
	signal ID_Control_MEM_in: std_logic_vector(1 downto 0);
	signal ID_Control_WData_in: std_logic;
	signal ID_Control_Raddr_in: std_logic_vector(1 downto 0);
	signal ID_Control_RWData_in: std_logic_vector(1 downto 0);
	signal ID_Control_IH_in: std_logic;
	signal ID_Control_SP_in: std_logic;
	signal ID_Control_RA_in: std_logic;
	signal ID_Control_T_in: std_logic;
	signal ID_Control_RF_in: std_logic;
	signal ID_Control_SP_S_in: std_logic;
	signal ID_PC_1_in: std_logic_vector(15 downto 0);
	signal ID_IH_in: std_logic_vector(15 downto 0);
	signal ID_SP_in: std_logic_vector(15 downto 0);
	signal ID_RA_in: std_logic_vector(15 downto 0);
	signal ID_T_in: std_logic_vector(15 downto 0);
	signal ID_RX_in: std_logic_vector(15 downto 0);
	signal ID_RY_in: std_logic_vector(15 downto 0);
	signal ID_IM_10_0_in: std_logic_vector(15 downto 0);
	signal ID_IM_7_0_zero_in: std_logic_vector(15 downto 0);
	signal ID_IM_7_0_sign_in: std_logic_vector(15 downto 0);
	signal ID_IM_4_0_in: std_logic_vector(15 downto 0);
	signal ID_IM_3_0_in: std_logic_vector(15 downto 0);
	signal ID_IM_4_2_in: std_logic_vector(15 downto 0);
	signal ID_Addr_RZ_in: std_logic_vector(2 downto 0);
	signal ID_Addr_RY_in: std_logic_vector(2 downto 0);
	signal ID_Addr_RX_in: std_logic_vector(2 downto 0);
	
	signal EXE_Control_RA: std_logic_vector(1 downto 0);
	signal EXE_Control_RB: std_logic_vector(1 downto 0);
	signal EXE_Control_RMWD: std_logic_vector(1 downto 0);
	signal EXE_A_MUX_Out: std_logic_vector(15 downto 0);
	signal EXE_B_MUX_Out: std_logic_vector(15 downto 0);
	signal EXE_PCAdder_Out: std_logic_vector(15 downto 0);
	signal EXE_SPAdder_Out: std_logic_vector(15 downto 0);
	signal EXE_SP_S_Out: std_logic_vector(15 downto 0);
	signal EXE_ALU_FLAG_ZERO: std_logic;
	signal EXE_ALU_FLAG_ZERO_extend: std_logic_vector(15 downto 0);
	signal EXE_Control_MEM_in: std_logic_vector(1 downto 0);
	signal EXE_Control_RWData_in: std_logic_vector(1 downto 0);
	signal EXE_Control_RF_in: std_logic;
	signal EXE_ALU_in: std_logic_vector(15 downto 0);
	signal EXE_MWD_in: std_logic_vector(15 downto 0);
	signal EXE_RAddr_in: std_logic_vector(2 downto 0);
	
	signal MEM_Control_RWData_in: std_logic_vector(1 downto 0);
	signal MEM_Control_RF_in: std_logic;
	signal MEM_ALU_in: std_logic_vector(15 downto 0);
	signal MEM_Data_in: std_logic_vector(15 downto 0);
	signal MEM_RAddr_in: std_logic_vector(2 downto 0);
	
	
	signal IF_PC_1_out: std_logic_vector(15 downto 0);
	signal IF_PC_out: std_logic_vector(15 downto 0);
	signal IF_INS_15_0_out: std_logic_vector(15 downto 0);
	signal IF_INS_10_8_out: std_logic_vector(2 downto 0);
	signal IF_INS_7_5_out: std_logic_vector(2 downto 0);
	signal IF_INS_10_0_out: std_logic_vector(10 downto 0);
	signal IF_INS_7_0_out: std_logic_vector(7 downto 0);
	signal IF_INS_4_0_out: std_logic_vector(4 downto 0);
	signal IF_INS_3_0_out: std_logic_vector(3 downto 0);
	signal IF_INS_4_2_out: std_logic_vector(2 downto 0);
	
	signal ID_Control_PC_out: std_logic_vector(2 downto 0);
	signal ID_Control_A_out: std_logic_vector(2 downto 0);
	signal ID_Control_B_out: std_logic_vector(3 downto 0);
	signal ID_Control_ALU_out: std_logic_vector(2 downto 0);
	signal ID_Control_MEM_out: std_logic_vector(1 downto 0);
	signal ID_Control_WData_out: std_logic;
	signal ID_Control_Raddr_out: std_logic_vector(1 downto 0);
	signal ID_Control_RWData_out: std_logic_vector(1 downto 0);
	signal ID_Control_IH_out: std_logic;
	signal ID_Control_SP_out: std_logic;
	signal ID_Control_RA_out: std_logic;
	signal ID_Control_T_out: std_logic;
	signal ID_Control_RF_out: std_logic;
	signal ID_Control_SP_S_out: std_logic;
	signal ID_PC_1_out: std_logic_vector(15 downto 0);
	signal ID_IH_out: std_logic_vector(15 downto 0);
	signal ID_SP_out: std_logic_vector(15 downto 0);
	signal ID_RA_out: std_logic_vector(15 downto 0);
	signal ID_T_out: std_logic_vector(15 downto 0);
	signal ID_RX_out: std_logic_vector(15 downto 0);
	signal ID_RY_out: std_logic_vector(15 downto 0);
	signal ID_IM_10_0_out: std_logic_vector(15 downto 0);
	signal ID_IM_7_0_zero_out: std_logic_vector(15 downto 0);
	signal ID_IM_7_0_sign_out: std_logic_vector(15 downto 0);
	signal ID_IM_4_0_out: std_logic_vector(15 downto 0);
	signal ID_IM_3_0_out: std_logic_vector(15 downto 0);
	signal ID_IM_4_2_out: std_logic_vector(15 downto 0);
	signal ID_Addr_RZ_out: std_logic_vector(2 downto 0);
	signal ID_Addr_RY_out: std_logic_vector(2 downto 0);
	signal ID_Addr_RX_out: std_logic_vector(2 downto 0);
	
	signal EXE_Control_MEM_out: std_logic_vector(1 downto 0);
	signal EXE_Control_RWData_out: std_logic_vector(1 downto 0);
	signal EXE_Control_RF_out: std_logic;
	signal EXE_ALU_out: std_logic_vector(15 downto 0);
	signal EXE_MWD_out: std_logic_vector(15 downto 0);
	signal EXE_RAddr_out: std_logic_vector(2 downto 0);
	
	signal MEM_Control_RWData_out: std_logic_vector(1 downto 0);
	signal MEM_Control_RF_out: std_logic;
	signal MEM_ALU_out: std_logic_vector(15 downto 0);
	signal MEM_Data_out: std_logic_vector(15 downto 0);
	signal MEM_RAddr_out: std_logic_vector(2 downto 0);
	
	component QReg is
		port(
					clk: in std_logic;
					rst: in std_logic; --0 for reset, others for normal function
					en: in std_logic; --1 for write, others for not write
					D_in: in std_logic_vector(15 downto 0); --input data
					D_out: out std_logic_vector(15 downto 0):= (others => '0') --output data
				);
	end component;
	
	component IFReg is
		port(
					clk: in std_logic;
					rst: in std_logic;
					
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
	end component;
	
	component IDReg is
		port(
					clk: in std_logic;
					rst: in std_logic;
					
					Control_PC_in: in std_logic_vector(2 downto 0);
					Control_A_in: in std_logic_vector(2 downto 0);
					Control_B_in: in std_logic_vector(3 downto 0);
					Control_ALU_in: in std_logic_vector(2 downto 0);
					Control_MEM_in: in std_logic_vector(1 downto 0);
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
					Control_MEM_out: out std_logic_vector(1 downto 0);
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
	end component;
	
	component EXEReg is
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
	end component;
	
	component MEMReg is
		port(
					clk: in std_logic;
					rst: in std_logic;
					
					Control_RWData_in: in std_logic_vector(1 downto 0);
					Control_RF_in: in std_logic;
					ALU_in: in std_logic_vector(15 downto 0);
					Data_in: in std_logic_vector(15 downto 0);
					RAddr_in: in std_logic_vector(2 downto 0);
					
					Control_RWData_out: out std_logic_vector(1 downto 0);
					Control_RF_out: out std_logic;
					ALU_out: out std_logic_vector(15 downto 0);
					Data_out: out std_logic_vector(15 downto 0);
					RAddr_out: out std_logic_vector(2 downto 0)
				);
	end component;
	
	component RF is
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
	end component;
	
	component memMgr is
		port(
					clk: in std_logic;
					clk_stage: in std_logic;
					rst: in std_logic;
					MEM: in std_logic_vector(1 downto 0); --11 for write; 10 for read; others for nothing
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
					PC:in std_logic_vector(15 downto 0);
					INS:out std_logic_vector(15 downto 0);
					Address: in std_logic_vector(15 downto 0);
					WriteData: in std_logic_vector(15 downto 0);
					Data: out std_logic_vector(15 downto 0):= (others => '0');
					data_ready: in std_logic;
					tbre: in std_logic;
					tsre: in std_logic;
					
					DYP0: out std_logic_vector(6 downto 0);
					DYP1: out std_logic_vector(6 downto 0)
				);
	end component;
	
	component Adder is
		port (
						input_0, input_1 : in std_logic_vector(15 downto 0);
						output : out std_logic_vector(15 downto 0)
					);
	end component;
	
	component ALU is
    PORT (
    				option : in  STD_LOGIC_VECTOR (2 DOWNTO 0);
    				a : in  STD_LOGIC_VECTOR (15 DOWNTO 0);
    				b : in  STD_LOGIC_VECTOR (15 DOWNTO 0);
						zero : out  STD_LOGIC;
						c : buffer  STD_LOGIC_VECTOR (15 DOWNTO 0)
          );
	end component;
	
	component controller IS 
    PORT (
    				INSTRUCTION: IN STD_LOGIC_VECTOR (15 downto 0);
						PAUSE      : IN STD_LOGIC;
						PC:         OUT STD_LOGIC_VECTOR (2 downto 0);
						A:          OUT STD_LOGIC_VECTOR (2 downto 0);
						B:          OUT STD_LOGIC_VECTOR (3 downto 0);
						ALU:        OUT STD_LOGIC_VECTOR (2 downto 0);
						MEM:        OUT STD_LOGIC_VECTOR(1 downto 0);
						WDATA:      OUT STD_LOGIC;
						RADDR:      OUT STD_LOGIC_VECTOR (1 downto 0);
						RWDATA:     OUT STD_LOGIC_VECTor (1 downto 0);
						IH:         OUT STD_LOGIC;
						SP:         OUT STD_LOGIC;
						RA:         OUT STD_LOGIC;
						T:          OUT STD_LOGIC;
						RF:         OUT STD_LOGIC;
						SP_S:       OUT STD_LOGIC
					);
	end component;
	
	component extension IS
  PORT ( imed10 : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
         imed7 : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         imed4 : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         imed3 : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
         imed4_2 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         exten10 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
         exten7 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
				 exten7zero : OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0);
         exten4 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
         exten3 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
         exten4_2 : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	component Foward IS
    PORT (
						A :  IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          B :  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
          WDATA	 : IN STD_LOGIC;
          ADDR7_5: IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          ADDR10_8: IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
          RF1   : IN STD_LOGIC;
          RF2   : IN STD_LOGIC;
			 		RAddr1 : IN STD_LOGIC_VECTOR(2 downto 0);
					RAddr2 : IN STD_LOGIC_VECTOR(2 downto 0);
          RA    : OUT STD_LOGIC_VECTOR(1 downto 0);
          RB    : OUT STD_LOGIC_VECTOR(1 downto 0);
          RMWD	: OUT STD_LOGIC_VECTOR(1 downto 0)
	       );
	end component;
	
	component Pause IS
    PORT ( MEM      : IN STD_LOGIC_VECTOR(1 downto 0);
           LAST_TO_WRITE: IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT10_8 : IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT7_5  : IN STD_LOGIC_VECTOR(2 downto 0);
           NEXT15_0 : IN STD_LOGIC_VECTOR(15 downto 0);
           PAUSE_SIGNAL: OUT STD_LOGIC);
	end component;
	
	component mux_pc IS
    PORT ( normal : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           PCadder : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           OLD_PC  : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           rx : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           ra : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           zero : IN STD_LOGIC;
           option : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           pc : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	component A_MUX IS
    PORT ( PC: IN STD_LOGIC_VECTOR(15 downto 0);
           IH: IN STD_LOGIC_VECTOR(15 downto 0);
           SP: IN STD_LOGIC_VECTOR(15 downto 0);
           T:  IN STD_LOGIC_VECTOR(15 downto 0);
           RX: IN STD_LOGIC_VECTOR(15 downto 0);
           RY: IN STD_LOGIC_VECTOR(15 downto 0);
           ALU:IN STD_LOGIC_VECTOR(15 downto 0);
           DATA:IN STD_LOGIC_VECTOR(15 downto 0);
           OUTPUT: OUT STD_LOGIC_VECTOR(15 downto 0);
           A:  IN STD_LOGIC_VECTOR(2 downto 0);
           RA: IN STD_LOGIC_VECTOR(1 downto 0));
	end component;
	
	component B_MUX IS
    PORT ( RY       :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_10   :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_7ZERO:  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_7SIGN:  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_4    :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           IMM_3    :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ADDR42   :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ALU      :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           DATA     :  IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           B        :  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
           RB       :  IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           OUTPUT   :  OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	component mux_raddr IS
    PORT ( addr10_8 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           addr7_5 : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
           addr4_2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
           option : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           out_raddr : OUT  STD_LOGIC_VECTOR (2 DOWNTO 0));
	end component;
	
	component mux_wdata IS
    PORT ( in_rx : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_ry : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_alu : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_rwdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC;
           out_wdata : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
           rmwd : IN STD_LOGIC_VECTOR (1 DOWNTO 0));
	end component;
	
	component mux_sp_s IS
    PORT ( sp_adder : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           ry : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC;
           out_sp : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	component mux_rwdata IS
    PORT ( in_alu : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           in_data : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
           option : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
           out_rwdata : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	signal clk_overall: std_logic_vector(24 downto 0):= (others => '0');
	signal clk_stage: std_logic_vector(1 downto 0):= (others => '0');
	signal clk_local, clk_down: std_logic:= '0';
	
	signal debug_data: std_logic_vector(15 downto 0);
begin
	process (SW)
	begin
		case SW(15 downto 12) is
			when "0000" => L <= debug_data;
			when "0001" => L <= ID_T_in;
			when "0010" => L <= IF_PC_in;
			when "0011" => L <= IF_INS_15_0_in;
			when "0100" => L <= EXE_A_MUX_Out;
			when "0101" => L <= EXE_B_MUX_Out;
			when "0110" => L <= ID_T_out;
			when "0111" => L <= MEM_Control_RF_out&"00"&MEM_Control_RWData_out&"00"&EXE_Control_RF_out&"00"&ID_Control_SP_S_out&"00"&MEM_RAddr_out;
			when "1000" => L <= ID_Control_RAddr_out&"00"&ID_Control_ALU_out&"0"&EXE_ALU_FLAG_ZERO&"000"&EXE_Control_MEM_out&"00";
			when "1001" => L <= EXE_Control_RA&"00"&EXE_Control_RB&"00"&ID_Control_A_out&"0"&ID_Control_B_out;
			when "1010" => L <= ID_Control_Pause&"000"&ID_Control_MEM_out&"00"&ID_Control_PC_out&"0"&EXE_ALU_FLAG_ZERO&"000";
			when "1011" => L <= ID_RF_WD;
			when "1100" => L <= EXE_MWD_in;
			when "1101" => L <= "0"&rdn&wrn&"0"&"0000"&"0000"&EXE_RAddr_in&"0";
			when "1110" => L <= ID_Control_RAddr_in&"00"&ID_Control_ALU_in&"0"&IF_INS_15_0_out(7 downto 0);
			when "1111" => L <= MEM_Data_in;
			when others => L <= (others => '0');
		end case;
	end process;
	
	process (clk_50)
	begin
		if (clk_50'event and clk_50 = '1') then
			clk_overall <= clk_overall+1;
		end if;
	end process;
	
	clk_local <= clk_50;
	
	process (clk_local)
	begin
		if (clk_local'event and clk_local = '1') then
			clk_stage <= clk_stage + 1;
		end if;
	end process;
	
	clk_down <= clk_stage(1);
	
	PC_Reg: QReg port map
		(clk_down,	rst, '1', IF_PC_1_in, IF_PC_Data_Out);

	IH_Reg: QReg port map
		(clk_local,	rst, ID_Control_IH_out, ID_RY_out, ID_IH_in);

	SP_Reg: QReg port map
		(clk_local,	rst, ID_Control_SP_S_out, EXE_SP_S_Out, ID_SP_in);

	RA_Reg: QReg port map
		(clk_local,	rst, ID_Control_RA_out, EXE_PCAdder_Out, ID_RA_in);

	EXE_ALU_FLAG_ZERO_extend <= "000000000000000"&(not EXE_ALU_FLAG_ZERO);

	T_Reg: QReg port map
		(clk_local,	rst, ID_Control_T_out, EXE_ALU_FLAG_ZERO_extend, ID_T_in);

	IF_ID_Reg: IFReg port map
		(clk_down, rst,
		 IF_PC_1_in, IF_PC_in, IF_INS_15_0_in, IF_INS_10_8_in, IF_INS_7_5_in, IF_INS_10_0_in, IF_INS_7_0_in, IF_INS_4_0_in, IF_INS_3_0_in, IF_INS_4_2_in,
		 IF_PC_1_out, IF_PC_out, IF_INS_15_0_out, IF_INS_10_8_out, IF_INS_7_5_out, IF_INS_10_0_out, IF_INS_7_0_out, IF_INS_4_0_out, IF_INS_3_0_out, IF_INS_4_2_out);

	ID_EXE_Reg: IDReg port map
		(clk_down, rst,
		 ID_Control_PC_in, ID_Control_A_in, ID_Control_B_in, ID_Control_ALU_in, ID_Control_MEM_in, ID_Control_WData_in, ID_Control_Raddr_in, ID_Control_RWData_in, ID_Control_IH_in, ID_Control_SP_in, ID_Control_RA_in, ID_Control_T_in, ID_Control_RF_in, ID_Control_SP_S_in, ID_PC_1_in, ID_IH_in, ID_SP_in, ID_RA_in, ID_T_in, ID_RX_in, ID_RY_in, ID_IM_10_0_in, ID_IM_7_0_zero_in, ID_IM_7_0_sign_in, ID_IM_4_0_in, ID_IM_3_0_in, ID_IM_4_2_in, ID_Addr_RX_in, ID_Addr_RY_in, ID_Addr_RZ_in,
		 ID_Control_PC_out, ID_Control_A_out, ID_Control_B_out, ID_Control_ALU_out, ID_Control_MEM_out, ID_Control_WData_out, ID_Control_Raddr_out, ID_Control_RWData_out, ID_Control_IH_out, ID_Control_SP_out, ID_Control_RA_out, ID_Control_T_out, ID_Control_RF_out, ID_Control_SP_S_out, ID_PC_1_out, ID_IH_out, ID_SP_out, ID_RA_out, ID_T_out, ID_RX_out, ID_RY_out, ID_IM_10_0_out, ID_IM_7_0_zero_out, ID_IM_7_0_sign_out, ID_IM_4_0_out, ID_IM_3_0_out, ID_IM_4_2_out, ID_Addr_RX_out, ID_Addr_RY_out, ID_Addr_RZ_out);
	
	EXE_MEM_Reg: EXEReg port map
		(clk_down,  rst,
		 EXE_Control_MEM_in, EXE_Control_RWData_in, EXE_Control_RF_in, EXE_ALU_in, EXE_MWD_in, EXE_RAddr_in,
		 EXE_Control_MEM_out, EXE_Control_RWData_out, EXE_Control_RF_out, EXE_ALU_out, EXE_MWD_out, EXE_RAddr_out);
	
	MEM_WB_Reg: MEMReg port map
		(clk_down, rst,
		 MEM_Control_RWData_in, MEM_Control_RF_in, MEM_ALU_in, MEM_Data_in, MEM_RAddr_in,
		 MEM_Control_RWData_out, MEM_Control_RF_out, MEM_ALU_out, MEM_Data_out, MEM_RAddr_out);

	ID_RF: RF port map
		(clk_local, rst,
		 MEM_Control_RF_out, IF_INS_10_8_out, IF_INS_7_5_out, ID_RX_in, ID_RY_in,
		 MEM_RAddr_out, ID_RF_WD,
		 SW(2 downto 0), debug_data);

	IF_MEM_MEMMgr: memMgr port map
		(clk_local, clk_down, rst, EXE_Control_MEM_out, Ram1Addr, Ram1Data, Ram1OE, Ram1WE, Ram1EN, wrn, rdn, Ram2Addr, Ram2Data, Ram2OE, Ram2WE, Ram2EN, IF_PC_in, IF_INS_15_0_in, EXE_ALU_out, EXE_MWD_out, MEM_Data_in, data_ready, tbre, tsre, DYP0, DYP1);
	
	IF_PC_Adder: Adder port map
		(IF_PC_in, X"0001", IF_PC_1_in);
  
	EXE_PC_Adder: Adder port map
		(ID_PC_1_out, EXE_B_MUX_out, EXE_PCAdder_Out);
	
	EXE_SP_Adder: Adder port map
		(ID_SP_out, EXE_SPAdder_Out, ID_IM_7_0_sign_out);
	
	EXE_ALU: ALU port map
		(ID_Control_ALU_out, EXE_A_MUX_Out, EXE_B_MUX_Out, EXE_ALU_FLAG_ZERO, EXE_ALU_in);
  
	ID_Controller: controller port map
		(IF_INS_15_0_out, ID_Control_Pause, ID_Control_PC_in,  ID_Control_A_in, ID_Control_B_in, ID_Control_ALU_in, ID_Control_MEM_in, ID_Control_WDATA_in, ID_Control_RADDR_in, ID_Control_RWDATA_in, ID_Control_IH_in, ID_Control_SP_in, ID_Control_RA_in, ID_Control_T_in, ID_Control_RF_in, ID_Control_SP_S_in);

	ID_Extension: extension port map
		(IF_INS_10_0_out, IF_INS_7_0_out, IF_INS_4_0_out, IF_INS_3_0_out, IF_INS_4_2_out,
		 ID_IM_10_0_in, ID_IM_7_0_sign_in, ID_IM_7_0_zero_in, ID_IM_4_0_in, ID_IM_3_0_in, ID_IM_4_2_in);

	Forward_unit: Foward port map
		(ID_Control_A_out, ID_Control_B_out, ID_Control_WData_out, ID_Addr_RY_out, ID_Addr_RX_out, EXE_Control_RF_out, MEM_Control_RF_out, EXE_RAddr_out, MEM_RAddr_out, EXE_Control_RA, EXE_Control_RB, EXE_Control_RMWD);
	
	Pause_unit: Pause port map
		(ID_Control_MEM_out, EXE_RAddr_out, IF_INS_10_8_out, IF_INS_7_5_out, IF_INS_15_0_out, ID_Control_Pause);

	IF_PC_MUX: mux_pc port map
		(IF_PC_Data_Out, EXE_PCAdder_Out, IF_PC_out, ID_RX_out, ID_RA_out, EXE_ALU_FLAG_ZERO, ID_Control_PC_out, IF_PC_in);

	EXE_A_MUX: A_MUX port map
		(ID_PC_1_out, ID_IH_out, ID_SP_out, ID_T_out, ID_RX_out, ID_RY_out, EXE_ALU_out, ID_RF_WD, EXE_A_MUX_Out, ID_Control_A_out, EXE_Control_RA);
	
	EXE_B_MUX: B_MUX port map
		(ID_RY_out, ID_IM_10_0_out, ID_IM_7_0_zero_out, ID_IM_7_0_sign_out, ID_IM_4_0_out, ID_IM_3_0_out, ID_IM_4_2_out, EXE_ALU_out, ID_RF_WD, ID_Control_B_out, EXE_Control_RB, EXE_B_MUX_Out);
	
	EXE_RAddr_MUX: mux_raddr port map
		(ID_Addr_RX_out, ID_Addr_RY_out, ID_Addr_RZ_out, ID_Control_Raddr_out, EXE_RAddr_in);
	
	EXE_WData_MUX: mux_wdata port map
		(ID_RX_out, ID_RY_out, EXE_ALU_out, ID_RF_WD, ID_Control_WData_out, EXE_MWD_in, EXE_Control_RMWD);
	
	EXE_SP_S_MUX: mux_sp_s port map
		(EXE_SPAdder_Out, ID_RY_out, ID_Control_SP_out, EXE_SP_S_Out);
	
	WB_RWData: mux_rwdata port map
		(MEM_ALU_out, MEM_Data_out, MEM_Control_RWData_out, ID_RF_WD);
	
	IF_INS_10_8_in <= IF_INS_15_0_in(10 downto 8);
	IF_INS_7_5_in <= IF_INS_15_0_in(7 downto 5);
	IF_INS_10_0_in <= IF_INS_15_0_in(10 downto 0);
	IF_INS_7_0_in <= IF_INS_15_0_in(7 downto 0);
	IF_INS_4_0_in <= IF_INS_15_0_in(4 downto 0);
	IF_INS_3_0_in <= IF_INS_15_0_in(3 downto 0);
	IF_INS_4_2_in <= IF_INS_15_0_in(4 downto 2);
	
	ID_PC_1_in <= IF_PC_1_out;
	ID_Addr_RZ_in <= IF_INS_4_2_out;
	ID_Addr_RY_in <= IF_INS_7_5_out;
	ID_Addr_RX_in <= IF_INS_10_8_out;

	EXE_Control_MEM_in <= ID_Control_MEM_out;
  EXE_Control_RWData_in <= ID_Control_RWData_out;
  EXE_Control_RF_in <= ID_Control_RF_out;
  
  MEM_Control_RWData_in <= EXE_Control_RWData_out;
  MEM_Control_RF_in     <= EXE_Control_RF_out;
  MEM_ALU_in            <= EXE_ALU_out;
  MEM_RAddr_in          <= EXE_RAddr_out;

end architecture;
