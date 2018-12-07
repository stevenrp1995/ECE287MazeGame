--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;




ENTITY hw_image_generator IS

	PORT(
		clk			:	IN		STD_LOGIC;
		disp_ena		:	IN		STD_LOGIC;	
		row			:	IN		INTEGER;		
		column		:	IN		INTEGER;
		moveup		:	IN		STD_LOGIC;	
		movedown		:	IN		STD_LOGIC;	
		moveleft		:	IN		STD_LOGIC;	
		moveright	:	IN		STD_LOGIC;	
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
		LEDRand     :  OUT   std_logic_vector(0 to 6) := (OTHERS => '0');
		you_winLED : OUT STD_LOGIC_VECTOR (0 to 7) := (OTHERS =>'0'));
	
		
		END hw_image_generator;
		
ARCHITECTURE behavior OF hw_image_generator IS

SIGNAL PlayLoc_x : INTEGER RANGE 1 to 1000 :=80 ;
SIGNAL PlayLoc_y : INTEGER RANGE 1 to 1000 :=50;

SIGNAL playerreset : STD_LOGIC := '0';
SIGNAL you_win: STD_LOGIC := '0';

SIGNAL startleftedge: INTEGER :=25;
SIGNAL startrightedge: INTEGER:=135;
SIGNAL starttopedge: INTEGER:=25;
SIGNAL startbottomedge: INTEGER:=75;

SIGNAL finishleftedge: INTEGER :=675;
SIGNAL finishrightedge: INTEGER:=785;
SIGNAL finishtopedge: INTEGER:=25;
SIGNAL finishbottomedge: INTEGER:=75;

SIGNAL obj1leftedge: INTEGER :=25;
SIGNAL obj1rightedge: INTEGER:=35;
SIGNAL obj1topedge: INTEGER:=75;
SIGNAL obj1bottomedge: INTEGER:=555;

SIGNAL obj2leftedge: INTEGER :=125;
SIGNAL obj2rightedge: INTEGER:=135;
SIGNAL obj2topedge: INTEGER:=75;
SIGNAL obj2bottomedge: INTEGER:=200;

SIGNAL obj3leftedge: INTEGER :=125;
SIGNAL obj3rightedge: INTEGER:=135;
SIGNAL obj3topedge: INTEGER:=390;
SIGNAL obj3bottomedge: INTEGER:=455;

SIGNAL obj4leftedge: INTEGER :=25;
SIGNAL obj4rightedge: INTEGER:=775;
SIGNAL obj4topedge: INTEGER:=545;
SIGNAL obj4bottomedge: INTEGER:=555;

SIGNAL obj5leftedge: INTEGER :=25;
SIGNAL obj5rightedge: INTEGER:=185;
SIGNAL obj5topedge: INTEGER:=295;
SIGNAL obj5bottomedge: INTEGER:=305;

SIGNAL obj6leftedge: INTEGER :=375;
SIGNAL obj6rightedge: INTEGER:=385;
SIGNAL obj6topedge: INTEGER:=145;
SIGNAL obj6bottomedge: INTEGER:=555;

SIGNAL obj7leftedge: INTEGER :=275;
SIGNAL obj7rightedge: INTEGER:=285;
SIGNAL obj7topedge: INTEGER:=45;
SIGNAL obj7bottomedge: INTEGER:=400;

SIGNAL obj8leftedge: INTEGER :=275;
SIGNAL obj8rightedge: INTEGER:=675;
SIGNAL obj8topedge: INTEGER:=45;
SIGNAL obj8bottomedge: INTEGER:=55;

SIGNAL obj9leftedge: INTEGER :=375;
SIGNAL obj9rightedge: INTEGER:=585;
SIGNAL obj9topedge: INTEGER:=145;
SIGNAL obj9bottomedge: INTEGER:=155;

SIGNAL obj10leftedge: INTEGER :=475;
SIGNAL obj10rightedge: INTEGER:=685;
SIGNAL obj10topedge: INTEGER:=245;
SIGNAL obj10bottomedge: INTEGER:=255;

SIGNAL obj11leftedge: INTEGER :=375;
SIGNAL obj11rightedge: INTEGER:=585;
SIGNAL obj11topedge: INTEGER:=345;
SIGNAL obj11bottomedge: INTEGER:=355;

SIGNAL obj12leftedge: INTEGER :=475; ---fix me
SIGNAL obj12rightedge: INTEGER:=685;
SIGNAL obj12topedge: INTEGER:=445;
SIGNAL obj12bottomedge: INTEGER:=455;

SIGNAL obj13leftedge: INTEGER :=675;
SIGNAL obj13rightedge: INTEGER:=685;
SIGNAL obj13topedge: INTEGER:=75;
SIGNAL obj13bottomedge: INTEGER:=455;

SIGNAL obj14leftedge: INTEGER :=775;
SIGNAL obj14rightedge: INTEGER:=785;
SIGNAL obj14topedge: INTEGER:=75;
SIGNAL obj14bottomedge: INTEGER:=555;

SIGNAL obj15leftedge: INTEGER :=125;
SIGNAL obj15rightedge: INTEGER:=285;
SIGNAL obj15topedge: INTEGER:=390;
SIGNAL obj15bottomedge: INTEGER:=400;

SIGNAL obj16leftedge: INTEGER :=125;
SIGNAL obj16rightedge: INTEGER:=285;
SIGNAL obj16topedge: INTEGER:=190;
SIGNAL obj16bottomedge: INTEGER:=200;

SIGNAL Can_move_x : STD_LOGIC := '0';
SIGNAL downone: STD_LOGIC := '0';
SIGNAL leftone : STD_LOGIC := '0';
SIGNAL rightone : STD_LOGIC := '0';
SIGNAL last_moveup : STD_LOGIC := '1';
SIGNAL last_movedown : STD_LOGIC := '1';
SIGNAL last_moveleft : STD_LOGIC := '1';
SIGNAL last_moveright : STD_LOGIC := '1';

SIGNAL clockcounter: std_logic_vector (25 downto 0);
SIGNAL finishcounter: std_logic_vector (25 downto 0);
SIGNAL onehertzclock: std_logic:='0';
SIGNAL timepassed: INTEGER:=0;
SIGNAL timeleft: integer :=9;
SIGNAL timeleftdisplay: std_logic_vector(0 to 6);
signal player_won: STD_LOGIC := '1';

BEGIN

PROCESS(moveup,movedown,moveleft,moveright)   --moveup,movedown,moveleft,moveright

BEGIN
-------------------------------------------------------------------------
--										Player Movement:
-------------------------------------------------------------------------

	IF (rising_edge(clk)) THEN   
		IF (playerreset = '1') OR (you_win = '1') THEN
			playloc_x <= 80;
			playloc_y <= 50;
		ELSE
		END IF;
		IF ((moveup = '0') and (last_moveup = '1') and (playloc_y > 50))  THEN    --check to see if the button has been pressed
			playloc_y <= (playloc_y - 50);		--if so, then move the position
		END IF;
		last_moveup <= moveup;					--this thing makes sure that it only moves once per button press
		if (movedown = '0' and last_movedown = '1' and (playloc_y < 550)) THEN  --Down
				playloc_y <= (playloc_y + 50);
		end if;
			last_movedown <= movedown;
		if (moveright = '0' and last_moveright = '1' and (playloc_x < 750)) THEN   --Right
			playloc_x <= (playloc_x + 50);
		end if;
			last_moveright <= moveright;
		if (moveleft = '0' and last_moveleft = '1' and (playloc_x > 50)) THEN  --Left
			playloc_x <= (playloc_x - 50);
		end if;
			last_moveleft <= moveleft;	
	end if;
	END Process;	


	
-----This is the image Processing:---------------------------
PROCESS(disp_ena, row, column)
BEGIN
	IF(disp_ena = '1') THEN		
							----This is the player image/block
			IF((column > (playLoc_y - 15) AND (row > (PlayLoc_x - 15))) AND (row < (PlayLoc_x + 15)) AND (column < (playloc_y + 15) )) THEN  --display the player box
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF((column > (starttopedge)) AND (column < (startbottomedge)) AND (row > (startleftedge)) AND (row < (startrightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');	
			ELSIF((column > (finishtopedge)) AND (column < (finishbottomedge)) AND (row > (finishleftedge)) AND (row < (finishrightedge))) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');		
			ELSIF((column > (obj1topedge)) AND (column < (obj1bottomedge)) AND (row > (obj1leftedge)) AND (row < (obj1rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj2topedge)) AND (column < (obj2bottomedge)) AND (row > (obj2leftedge)) AND (row < (obj2rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj3topedge)) AND (column < (obj3bottomedge)) AND (row > (obj3leftedge)) AND (row < (obj3rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj4topedge)) AND (column < (obj4bottomedge)) AND (row > (obj4leftedge)) AND (row < (obj4rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj5topedge)) AND (column < (obj5bottomedge)) AND (row > (obj5leftedge)) AND (row < (obj5rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj6topedge)) AND (column < (obj6bottomedge)) AND (row > (obj6leftedge)) AND (row < (obj6rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj7topedge)) AND (column < (obj7bottomedge)) AND (row > (obj7leftedge)) AND (row < (obj7rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj8topedge)) AND (column < (obj8bottomedge)) AND (row > (obj8leftedge)) AND (row < (obj8rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj9topedge)) AND (column < (obj9bottomedge)) AND (row > (obj9leftedge)) AND (row < (obj9rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj10topedge)) AND (column < (obj10bottomedge)) AND (row > (obj10leftedge)) AND (row < (obj10rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj11topedge)) AND (column < (obj11bottomedge)) AND (row > (obj11leftedge)) AND (row < (obj11rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj12topedge)) AND (column < (obj12bottomedge)) AND (row > (obj12leftedge)) AND (row < (obj12rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj13topedge)) AND (column < (obj13bottomedge)) AND (row > (obj13leftedge)) AND (row < (obj13rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj14topedge)) AND (column < (obj14bottomedge)) AND (row > (obj14leftedge)) AND (row < (obj14rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF((column > (obj15topedge)) AND (column < (obj15bottomedge)) AND (row > (obj15leftedge)) AND (row < (obj15rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');	
			ELSIF((column > (obj16topedge)) AND (column < (obj16bottomedge)) AND (row > (obj16leftedge)) AND (row < (obj16rightedge))) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');		
			ELSE
				red <= (OTHERS => '1');    ----This is the background
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			END IF;
		ELSE								
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
			
		END IF;

END PROCESS;

---------------------------------------------------------------
--						This is the timer code
---------------------------------------------------------------
process (clk)

BEGIN
--timeleft <= 1;
if (rising_edge(clk)) then 
	if clockcounter < "10111110101111000010000000" then -- Binary Value 50,000,000
						clockcounter <= clockcounter + 1;
						elsif (timeleft > 0) then
						timeleft <= timeleft - 1;
						clockcounter <= (others => '0');
						end if;
end if;
	
	if timeleft = 0 then
		timeleftdisplay <= "0000001";
		
		elsif	timeleft = 1 then
		timeleftdisplay <= "1001111";
		
		elsif	timeleft = 2 then
		timeleftdisplay <= "0010010";
		
		elsif	timeleft = 3 then
		timeleftdisplay <= "0000110";
		
		elsif	timeleft = 4 then
		timeleftdisplay <= "1001100";
		
		elsif	timeleft = 5 then
		timeleftdisplay <= "0100100";
		
		elsif	timeleft = 6 then
		timeleftdisplay <= "0100000";
		
		elsif	timeleft = 7 then
		timeleftdisplay <= "0001111";
		
		elsif	timeleft = 8 then
		timeleftdisplay <= "0000000";
		
		elsif	timeleft = 9 then
		timeleftdisplay <= "0001100";
		
		end if;

LEDRand <= timeleftdisplay; 

END PROCESS;

-------------------------------------------------------------
--					The "You're Dead to me" Code:

-------------------------------------------------------------

process (clk)

BEGIN

	if ((Playloc_x < obj1rightedge) and (Playloc_x > obj1leftedge) and (playloc_y > obj1topedge) and (playloc_y < obj1bottomedge)) then
		playerreset <= '1';
	elsif (Playloc_x < obj2rightedge) and (Playloc_x > obj2leftedge) and (playloc_y > obj2topedge) and (playloc_y < obj2bottomedge) then
		playerreset <= '1';	
	elsif (Playloc_x < obj3rightedge) and (Playloc_x > obj3leftedge) and (playloc_y > obj3topedge) and (playloc_y < obj3bottomedge) then
		playerreset <= '1';	
	elsif (Playloc_x < obj4rightedge) and (Playloc_x > obj4leftedge) and (playloc_y > obj4topedge) and (playloc_y < obj4bottomedge) then
		playerreset <= '1';	
	elsif (Playloc_x < obj5rightedge) and (Playloc_x > obj5leftedge) and (playloc_y > obj5topedge) and (playloc_y < obj5bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj6rightedge) and (Playloc_x > obj6leftedge) and (playloc_y > obj6topedge) and (playloc_y < obj6bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj7rightedge) and (Playloc_x > obj7leftedge) and (playloc_y > obj7topedge) and (playloc_y < obj7bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj8rightedge) and (Playloc_x > obj8leftedge) and (playloc_y > obj8topedge) and (playloc_y < obj8bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj9rightedge) and (Playloc_x > obj9leftedge) and (playloc_y > obj9topedge) and (playloc_y < obj9bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj10rightedge) and (Playloc_x > obj10leftedge) and (playloc_y > obj10topedge) and (playloc_y < obj10bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj11rightedge) and (Playloc_x > obj11leftedge) and (playloc_y > obj11topedge) and (playloc_y < obj11bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj12rightedge) and (Playloc_x > obj12leftedge) and (playloc_y > obj12topedge) and (playloc_y < obj12bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj13rightedge) and (Playloc_x > obj13leftedge) and (playloc_y > obj13topedge) and (playloc_y < obj13bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj14rightedge) and (Playloc_x > obj14leftedge) and (playloc_y > obj14topedge) and (playloc_y < obj14bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj15rightedge) and (Playloc_x > obj15leftedge) and (playloc_y > obj15topedge) and (playloc_y < obj15bottomedge) then
		playerreset <= '1';
	elsif (Playloc_x < obj16rightedge) and (Playloc_x > obj16leftedge) and (playloc_y > obj16topedge) and (playloc_y < obj16bottomedge) then
		playerreset <= '1';
	else
		playerreset <= '0';

	
END IF;	


END PROCESS;
	
---------------------------------------------------------------
--							This is the Finish-line Logic
---------------------------------------------------------------
	
process(clk)
Begin

if (Playloc_x < finishrightedge) and (Playloc_x > finishleftedge) and (playloc_y > finishtopedge) and (playloc_y < finishbottomedge) then
		you_winLED <= (OTHERS => '1');
		you_win <='1';
		else
		you_win <= '0';
		--playerReset <= '0';
		--delay for a bit
		
--		if (rising_edge(clk)) then 
--				if finishCounter < "10111110101111000010000000" then -- Binary Value 50,000,000
--						finishCounter <= finishCounter + 1;
--						else
--						timepassed <= timePassed + 1;
--						finishCounter <= (others => '0');
--				end if;
--			if ((timepassed = 5) and (playerReset = '0')) then
--				--player_won = '1';		
--			end if;
--		end if;
--		you_win <= '0';
end if;

--if (you_win = '1') then
--	--delay for a bit
--	--reset
--else
--	

end process;

End behavior;