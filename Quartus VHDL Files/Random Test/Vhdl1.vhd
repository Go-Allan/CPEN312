library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity orvhdl is
	port
	(
		-- Input ports
		PB1, PB2	: in  STD_LOGIC;

		-- Output ports
		LED		: out  STD_LOGIC
	);
end orvhdl;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture mytest of orvhdl is

	-- Declarations (optional)

begin
	LED <= NOT( (not PB1) OR (NOT PRB2) );

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end mytest;
