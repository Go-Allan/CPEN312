LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

--------------------------------------------

ENTITY BCDCounter IS
	port(
	KEY0, CLK_50, KEY3, KEY2, KEY1	  : IN  STD_LOGIC;
	TIMESET									  : IN  STD_LOGIC_VECTOR(7 downto 0);	
	MSDS, LSDS, MSDM, LSDM, MSDH, LSDH : OUT STD_LOGIC_VECTOR (0 to 6) --(most sig fig seconds, least sig fig seconds)
	);
END BCDCounter;

--------------------------------------------

ARCHITECTURE a of BCDCounter is
	SIGNAL ClkFlag							: STD_LOGIC;
	SIGNAL rand								: STD_LOGIC := '0';
	SIGNAL Internal_Count				: STD_LOGIC_VECTOR(28 downto 0);
	SIGNAL HighDigit_S, LowDigit_S	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL MSD_7SEGS, LSD_7SEGS		: STD_LOGIC_VECTOR(0 to 6);
	SIGNAL HighDigit_M, LowDigit_M	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL MSD_7SEGM, LSD_7SEGM		: STD_LOGIC_VECTOR(0 to 6);
	SIGNAL HighDigit_H, LowDigit_H	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL MSD_7SEGH, LSD_7SEGH		: STD_LOGIC_VECTOR(0 to 6); 
	
BEGIN

	LSDS<=LSD_7SEGS; 
	MSDS<=MSD_7SEGS;
	LSDM<=LSD_7SEGM;
	MSDM<=MSD_7SEGM;
	LSDH<=LSD_7SEGH;
	MSDH<=MSD_7SEGH;
	
--seconds counter
	PROCESS(CLK_50)
	BEGIN
			if(CLK_50'event and CLK_50='1') then
				if Internal_Count < 25000000 then
					Internal_Count <= Internal_Count+1;
				else
					Internal_Count <= (others => '0'); 
					ClkFlag <= not ClkFlag;
				end if;
			end if;
	END PROCESS;

	PROCESS(ClkFlag, KEY0)
	BEGIN
			
		
		-- reset time
		if(KEY0 = '0') then 
			LowDigit_S <= "0000";
			HighDigit_S <= "0000";
			LowDigit_M <= "0000";
			HighDigit_M <= "0000";
			LowDigit_H <= "0010";
			HighDigit_H <= "0001";
			
		--set time
		elsif(KEY3 = '0') then
			HighDigit_H <= TIMESET(7 downto 4);
			LowDigit_H <= TIMESET(3 downto 0);
		
		elsif(KEY2 = '0') then
			HighDigit_M <= TIMESET(7 downto 4);
			LowDigit_M <= TIMESET(3 downto 0);
	
		elsif(KEY1 = '0') then
			HighDigit_S <= TIMESET(7 downto 4);
			LowDigit_S <= TIMESET(3 downto 0);

		
		--main counting 	
		elsif(ClkFlag'event and ClkFlag = '1') then
			
		--startup time
		if (rand = '0') then
		LowDigit_S <= "0101";
		HighDigit_S <= "0101";
		LowDigit_M <= "1001";
		HighDigit_M <= "0101";
		LowDigit_H <= "0010";
		HighDigit_H <= "0001";
		rand <= '1';
		end if;
		
		--seconds start
			if (LowDigit_S = 9) then
				LowDigit_S <= "0000";
				if (HighDigit_S = 5) then
					HighDigit_S <= "0000";
					--minutes start
					if (LowDigit_M = 9) then
						LowDigit_M <= "0000";
						if(HighDigit_M = 5) then
							HighDigit_M <= "0000";
						   --hours start
							if (LowDigit_H = 2) then
								LowDigit_H <= "0001";
								if(HighDigit_H = 1) then
									HighDigit_H <= "0000";
									
								else HighDigit_H <= HighDigit_H + '1';
								end if;
							else
								LowDigit_H <= LowDigit_H +'1';
							end if;
							--hours end		
						else HighDigit_M <= HighDigit_M + '1';
						end if;
					else
						LowDigit_M <= LowDigit_M +'1';
					end if;
				--minutes end		
				else HighDigit_S <= HighDigit_S + '1';
				end if;
			else
				LowDigit_S<=LowDigit_S+'1';
			end if;
		--seconds end
		end if;
	END PROCESS;

	PROCESS(LowDigit_S, HighDigit_S, LowDigit_M, HighDigit_M, LowDigit_H, HighDigit_H)
	BEGIN
		--seconds
		case LowDigit_S is
			when "0000" => LSD_7SEGS <= "0000001";
			when "0001" => LSD_7SEGS <= "1001111";
			when "0010" => LSD_7SEGS <= "0010010";
			when "0011" => LSD_7SEGS <= "0000110";
			when "0100" => LSD_7SEGS <= "1001100";
			when "0101" => LSD_7SEGS <= "0100100";
			when "0110" => LSD_7SEGS <= "0100000";
			when "0111" => LSD_7SEGS <= "0001111";
			when "1000" => LSD_7SEGS <= "0000000";
			when "1001" => LSD_7SEGS <= "0000100";
			when others => LSD_7SEGS <= "1111111";
		end case;

		case HighDigit_S is
			when "0000" => MSD_7SEGS <= "0000001";
			when "0001" => MSD_7SEGS <= "1001111";
			when "0010" => MSD_7SEGS <= "0010010";
			when "0011" => MSD_7SEGS <= "0000110";
			when "0100" => MSD_7SEGS <= "1001100";
			when "0101" => MSD_7SEGS <= "0100100";
			when "0110" => MSD_7SEGS <= "0100000";
			when "0111" => MSD_7SEGS <= "0001111";
			when "1000" => MSD_7SEGS <= "0000000";
			when "1001" => MSD_7SEGS <= "0000100";
			when others => MSD_7SEGS <= "1111111";
		end case;
		--minutes
		case LowDigit_M is
			when "0000" => LSD_7SEGM <= "0000001";
			when "0001" => LSD_7SEGM <= "1001111";
			when "0010" => LSD_7SEGM <= "0010010";
			when "0011" => LSD_7SEGM <= "0000110";
			when "0100" => LSD_7SEGM <= "1001100";
			when "0101" => LSD_7SEGM <= "0100100";
			when "0110" => LSD_7SEGM <= "0100000";
			when "0111" => LSD_7SEGM <= "0001111";
			when "1000" => LSD_7SEGM <= "0000000";
			when "1001" => LSD_7SEGM <= "0000100";
			when others => LSD_7SEGM <= "1111111";
		end case;

		case HighDigit_M is
			when "0000" => MSD_7SEGM <= "0000001";
			when "0001" => MSD_7SEGM <= "1001111";
			when "0010" => MSD_7SEGM <= "0010010";
			when "0011" => MSD_7SEGM <= "0000110";
			when "0100" => MSD_7SEGM <= "1001100";
			when "0101" => MSD_7SEGM <= "0100100";
			when "0110" => MSD_7SEGM <= "0100000";
			when "0111" => MSD_7SEGM <= "0001111";
			when "1000" => MSD_7SEGM <= "0000000";
			when "1001" => MSD_7SEGM <= "0000100";
			when others => MSD_7SEGM <= "1111111";
		end case;
		--hours
		case LowDigit_H is
			when "0000" => LSD_7SEGH <= "0000001";
			when "0001" => LSD_7SEGH <= "1001111";
			when "0010" => LSD_7SEGH <= "0010010";
			when "0011" => LSD_7SEGH <= "0000110";
			when "0100" => LSD_7SEGH <= "1001100";
			when "0101" => LSD_7SEGH <= "0100100";
			when "0110" => LSD_7SEGH <= "0100000";
			when "0111" => LSD_7SEGH <= "0001111";
			when "1000" => LSD_7SEGH <= "0000000";
			when "1001" => LSD_7SEGH <= "0000100";
			when others => LSD_7SEGH <= "1111111";
		end case;

		case HighDigit_H is
			when "0000" => MSD_7SEGH <= "0000001";
			when "0001" => MSD_7SEGH <= "1001111";
			when "0010" => MSD_7SEGH <= "0010010";
			when "0011" => MSD_7SEGH <= "0000110";
			when "0100" => MSD_7SEGH <= "1001100";
			when "0101" => MSD_7SEGH <= "0100100";
			when "0110" => MSD_7SEGH <= "0100000";
			when "0111" => MSD_7SEGH <= "0001111";
			when "1000" => MSD_7SEGH <= "0000000";
			when "1001" => MSD_7SEGH <= "0000100";
			when others => MSD_7SEGH <= "1111111";
		end case;
		
	END PROCESS;

end a;

	
