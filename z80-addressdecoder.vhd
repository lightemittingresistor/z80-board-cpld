LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY z80addressdecoder IS 
	PORT
	(
		clk:in STD_LOGIC;
		address:in STD_LOGIC_VECTOR(15 downto 0);
		ioreq:in STD_LOGIC;
		mreq:in STD_LOGIC;
		rd:in STD_LOGIC;
		wr:in STD_LOGIC;
		cs:out STD_LOGIC_VECTOR(7 downto 0) := (others => '1')
	);
END z80addressdecoder;

ARCHITECTURE decoder OF z80addressdecoder IS
BEGIN
	p:PROCESS(address, mreq, ioreq)
	BEGIN
		IF((address(15 downto 13) = "000") AND mreq = '0')  then
			-- ROM in lower part of memory
			cs(7 downto 0) <= (0 => '0', others => '1');
		ELSIF(address(15) = '1' AND mreq = '0') THEN
			-- RAM in high half of memory
			cs(7 downto 0) <= (1 => '0', others => '1');
		ELSIF(address(7 downto 0) = "00000000" AND mreq = '1' AND ioreq = '0') THEN
			-- IO port in lower part of IO space
			cs(7 downto 0) <= (2 => '0', others => '1');
		ELSIF(address(7 downto 0) = "00000001" AND mreq = '1' AND ioreq = '0') THEN
			-- IO port in lower part of IO space
			cs(7 downto 0) <= (3 => '0', others => '1');
		ELSE
			cs(7 downto 0) <= (others => '1');
		END IF;
	END PROCESS;
END decoder;