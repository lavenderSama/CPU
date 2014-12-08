LIBRARY	IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_controller IS
	POrt (
		vga_clk	: OUT STD_LOGIC;
		hs,vs	: OUT STD_LOGIC;
		ored	: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		ogreen	: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		oblue	: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		reset	: IN  STD_LOGIC;
		clk_in	: IN  STD_LOGIC
	);		
END ENTITY vga_controller;

ARCHITECTURE behave OF vga_controller IS
	SIGNAL clk,clk_2 : STD_LOGIC;
	SIGNAL rt,gt,bt : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL hst,vst : STD_LOGIC;
	SIGNAL x : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL y : STD_LOGIC_VECTOR (8 DOWNTO 0);
BEGIN
	vga_clk	<= clk;
	clk<=clk_2;
 -----------------------------------------------------------------------
	PROCESS (clk_in)
	BEGIN
		IF clk_in'EVENT AND clk_in = '1' THEN
			clk_2 <= NOT clk_2;
		END IF;
	END PROCESS;	

 -----------------------------------------------------------------------
	PROCESS (clk, reset)
	BEGIN
		IF reset = '0' THEN
			x <= (OTHERS => '0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF x = 799 THEN
				x <= (OTHERS => '0');
			ELSE
				x <= x + 1;
			END IF;
		END IF;
	END PROCESS;

  -----------------------------------------------------------------------
	 PROCESS (clk, reset)
	 BEGIN
	  	IF reset = '0' THEN
	   		y <= (OTHERS => '0');
	  	ELSIF clk'EVENT AND clk = '1' THEN
	   		IF x = 799 THEN
	    		IF x = 524 THEN
	     			y <= (OTHERS => '0');
	    		ELSE
	     			y <= y + 1;
	    		END IF;
	   		END IF;
	  	END IF;
	 END PROCESS;
 
  -----------------------------------------------------------------------
	 PROCESS (clk, reset)
	 BEGIN
		  IF reset = '0' THEN
		   hst <= '1';
		  ELSIF clk'EVENT AND clk = '1' THEN
		   	IF x >= 656 AND x < 752 THEN
		    	hst <= '0';
		   	ELSE
		    	hst <= '1';
		   	END IF;
		  END IF;
	 END PROCESS;
 
 -----------------------------------------------------------------------
	 PROCESS (clk, reset)
	 BEGIN
	  	IF reset = '0' THEN
	   		vst <= '1';
	  	ELSIF clk'EVENT AND clk = '1' THEN
	   		IF y >= 490 AND y< 492 THEN
	    		vst <= '0';
	   		ELSE
	    		vst <= '1';
	   		END IF;
	  	END IF;
	 END PROCESS;
 -----------------------------------------------------------------------
	 PROCESS (clk, reset)
	 BEGIN
	  	IF reset = '0' THEN
	   		hs <= '0';
	  	ELSIF clk'EVENT AND clk = '1' THEN
	   		hs <=  hst;
	  	END IF;
	 END PROCESS;

 -----------------------------------------------------------------------
	 PROCESS (clk, reset)
	 BEGIN
	  	IF reset = '0' THEN
	   		vs <= '0';
	  	ELSIF clk'EVENT AND clk='1' THEN
	   		vs <=  vst;
	  	END IF;
	 END PROCESS;

------------------------------------------------------------------------
--	PROCESS (CLK, RESET) -- XY×Ø±Ê¶¨Î»¿ØÖÆ
--	BEGIN	  	
--		IF RESET = '1' THEN
--			rt		<=	(OTHERS => '0');
--			GT		<=	(OTHERS => '0');
--			bt		<=	(OTHERS => '0');
--			ADDR	<=	(OTHERS => '0');
--	  	ELSIF CLK'EVENT AND CLK='1' THEN
--			ADDR	<=	X&Y;
--			rt		<=	R;
--			GT		<=	G;
--			bt		<=	B;
--	  	END IF;
--	END PROCESS;
-----------------------------------------------------------------------	
-----------------------------------------------------------------------
-----------------------------------------------------------------------
	PROCESS(reset,clk,x,y)
	BEGIN  
		IF reset='0' THEN
			        rt   <= "000";
					gt	<= "000";
					bt	<= "000";	
		ELSIF(clk'EVENT AND clk='1')THEN 
			IF x>0 AND x<213 THEN
				rt <="000";				  	
				bt <="111";
			ELSIF X>=213 AND X<426 THEN
				rt <="111";
				bt <="000";
			ELSE
				rt <="111";
				bt <="111";
			END IF;
		    
			IF y<240 THEN
			    gt   <="111";
			ELSE
			    gt	<= "000";
			END IF;		
		END IF;		 
	    END PROCESS;	

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
	PROCESS (hst, vst, rt, gt, bt)
	BEGIN
		IF hst = '1' AND vst = '1' THEN
			ored	<= rt;
			ogreen	<= gt;
			oblue	<= bt;
		ELSE
			ored	<= (OTHERS => '0');
			ogreen	<= (OTHERS => '0');
			oblue	<= (OTHERS => '0');
		END IF;
	END PROCESS;

END behave;