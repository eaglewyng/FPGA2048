----------------------------------------------------------------------------------
-- Engineers: Parker Ridd and Travis Chambers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Game is
	port	(
				clk : in std_logic;
				sw0 : in std_logic;
				btn : in std_logic_vector(3 downto 0)			
	
			);

end Game;

architecture Behavioral of Game is

--GAME SIGNALS
signal score : natural;
type state is (start, playing, endGame);
signal state_reg, state_next : state; 

--INPUTS to GRID
signal grid_color : std_logic_vector(7 downto 0);

--outputs from GRID
signal isVictory : std_logic;
signal game_over : std_logic;

begin

--state register
process(clk)
begin
	if sw0 = '0' then
		state_reg <= start;
	elsif rising_edge(clk) then
		state_reg <= state_next;
	end if;
end process;

--FSM
process(state_reg, sw0)
begin
	case state_reg is 
		when start =>
			--display blank grid (no boxes)
			grid_color <= "11101011";
			if (sw0 = '1') then
				state_next <= playing;
			else
				state_next <= start;
			end if;
		when playing =>
			--generate 2 boxes of value 2 at random squares in the grid
			--each button press will generate a new box and merge/move existing boxes
			grid_color <= "10001110";
			if (game_over = '1') then
				state_next <= endGame;
			else
				state_next <= playing;
			end if;
		when endGame =>
			--move back to start when sw0 = 0;
			if (sw0 = '1') then
				state_next <= endGame;
				if (isVictory = '1') then
					grid_color <= "11000100";
				else
					grid_color <= "11101001";
				end if;
			else
				state_next <= start;
			end if;

		end case;
end process;

--grid_color <= "11101011" when state_reg = start else
--				  "11110000" when state_reg = playing else
--				  "11101001" when (state_reg = endGame and isVictory = '0') else
--				  "11000100" when (state_reg = endGame and isVictory = '1');

end Behavioral;

