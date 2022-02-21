--libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--entity------------------------------------------------------------------------------------------------------
entity BCDAddSub is
	port(
		a, b						: in	std_logic_vector(3 downto 0);
		KEY0, KEY1, SW9		: in  std_logic;
		sum0, sum10				: out	std_logic_vector(3 downto 0)

	);
	
end BCDAddSub;
--------------------------------------------------------------------------------------------------------------	
	
--architecture------------------------------------------------------------------------------------------------	
architecture a of BCDAddSub is
	signal sum_temp, temp1, temp2, temp3, temp4		:	std_logic_vector(4 downto 0);

	
begin
	
	process(a, temp1, temp2, sum_temp)
	begin
	if (SW9 = '0') then	-- addition
		if (KEY1 = '0') then --KEY1 assigns the first number to temp
			temp1 <= ('0' & a);
			temp2 <= ('0' & b);
		end if;
		
		if (KEY0 = '0') then
			temp3 <= ('0' & a);
			temp4 <= ('0' & b);
		end if;
		
		sum_temp(8 downto 0) <= temp1 + temp2 ;
		sum <= sum_temp(8 downto 0);
		
	else --subtraction
		if (KEY1 = '0') then --KEY0 assigns the first number to temp
			temp1 <= ('0' & a);
		end if;
		
		if (KEY0 = '0') then
			temp2 <= ('0' & a);
		end if;
		
		sum_temp(8 downto 0) <= temp1 - temp2 ;
		sum <= sum_temp(8 downto 0);
	end if;
	end process;


end a;
