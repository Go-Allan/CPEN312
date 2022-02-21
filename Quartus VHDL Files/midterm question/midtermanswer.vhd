LIBRARY ieee;
USE ieee.std_logic_1164.all; 
 
ENTITY midtermanswer IS     
PORT (  		 Clock   : IN        STD_LOGIC ;
             M       : IN        STD_LOGIC ;
             Rn      : IN        STD_LOGIC ;
             D0      : IN        STD_LOGIC_VECTOR(3 DOWNTO 0) ;
             D1      : IN        STD_LOGIC_VECTOR(3 DOWNTO 0) ;
             Q       : OUT       STD_LOGIC_VECTOR(3 DOWNTO 0) )
;
END midtermanswer; 
 
ARCHITECTURE a OF midtermanswer IS   
BEGIN
     PROCESS(M, D0, D1, Rn)
	  BEGIN
			if Rn = '0' then
				Q <="0000";
			else 
	  if falling_edge(Clock) then
	  if M = '0' then
	  Q <= D0;
	  else
	  Q <= D1;
	  end if;
	  end if;
	  end if;
     END PROCESS;
	  END a; 