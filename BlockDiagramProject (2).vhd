
LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY gamelogic IS

	PORT(
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END gamelogic;


ARCHITECTURE behavior OF gamelogic IS

SIGNAL PlayLoc_x : INTEGER ;
SIGNAL PlayLoc_y : INTEGER ;



BEGIN

PROCESS(disp_ena, row, column)
Variable Play_Ht := 10 ;
Variable Play_wt := 10 ;
BEGIN
	IF(disp_ena = '1') THEN		
			IF((row > (playLoc_y - 5) AND (column > (PlayLoc_x - 5))) AND (column < (PlayLoc_x + 5)) AND (row < (player_loc_y + 5) AND (column < (Player_loc_x + 5)))) THEN  --display the player box
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSE
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			END IF;
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;






END Process;


End behavior;