--libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--entity------------------------------------------------------------------------------------------------------
entity lab2binaryadder is
	port(
		a							: in	std_logic_vector(7 downto 0);
		KEY0, KEY1, SW9		: in  std_logic;
		sum						: out	std_logic_vector(8 downto 0)
		--carry						: out	std_logic
	);
	
end lab2binaryadder;
--------------------------------------------------------------------------------------------------------------	
	
--architecture------------------------------------------------------------------------------------------------	
architecture a of lab2binaryadder is
	signal sum_temp, temp1, temp2		:	std_logic_vector(8 downto 0);

begin
	
	process(a, temp1, temp2, sum_temp)
	begin
	if (SW9 = '0') then	-- addition
		if (KEY1 = '0') then --KEY1 assigns the first number to temp
			temp1 <= ('0' & a);
		end if;
		
		if (KEY0 = '0') then
			temp2 <= ('0' & a);
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
--------------------------------------------------------------------------------------------------------------