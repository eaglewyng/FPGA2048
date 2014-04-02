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
				btn : in std_logic_vector(3 downto 0);		
				seg : out std_logic_vector(6 downto 0);
				dp : out std_logic_vector;
				an : out std_logic_vector(32 downto 0)
			);

end Game;

architecture Behavioral of Game is

--GAME SIGNALS
signal rst : std_logic;
signal score : natural;
type state is (start, playing, endGame);
signal state_reg, state_next : state; 

--INPUTS to GRID
signal grid_color : std_logic_vector(7 downto 0);

--outputs from GRID
signal isVictory : std_logic;
signal game_over : std_logic;
signal draw_grid : std_logic;

--debouncing signals
	signal btn_debounced: STD_LOGIC_VECTOR(3 downto 0);
	signal btn_debounced_next: STD_LOGIC_VECTOR(3 downto 0);
	signal btn_intDebounced, btn_intDebounced_next : STD_LOGIC_VECTOR(3 downto 0);
	signal deb_counter_set : STD_LOGIC;                    --sync reset to zero
   signal deb_counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output
begin

rst <= sw0;

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

Grid1 : entity work.Grid
port map( 
			clk => clk,
			rst => rst,
			grid_color =>grid_color,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			btn => btn,
			draw_grid => draw_grid
			);

SevenSeg : entity work.seven_segment_display
port map(
			clk => clk,
			data_in => "11111111", 
			dp_in => "1111",
			blank => open,
			seg => seg,
			dp => dp,
			an => an
		   );

VGA : entity work.vga_timing
port map (
				clk => clk,
				rst => rst,
				HS => HS,
				VS => VS,
				pixel_x => pixel_x,
				pixel_y => pixel_y,
				last_column => open,
				last_row => open,
				blank => blank
			 );
			 
	--============================================================================
	------------------Debouncer Circuit-------------------------------------------
	--============================================================================



end Behavioral;
