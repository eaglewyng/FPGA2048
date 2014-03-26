FPGA2048
========

2048 FPGA Version

2048 Game Specification
In this project, we are going to make a version of the game 2048. The specifications of this project are as follows:

Grid:
	The grid will be a 4x4 grid of boxes that has a brownish-gray background. The grid will contain a number of boxes, depending on the state of the game. The grid begins with two boxes, which are placed on randomly chosen coordinates on the board.  Each square will have a value assigned to it, and if two of squares with the same value collide, they will “combine” and make a new square with double the value. For more information about the gameplay, please go to http://gabrielecirulli.github.io/2048/ . 
	
	Due to the time limitations, we will not actually display the value of the boxes on the boxes for the initial implementation, but rather just a color. The colors will be made to mimic the colors of the game on the site above. The winning color will be pink. If the user wins, the board will turn green, and if the user loses, the board turns red. 
	
	To implement this, we will make a main Finite State Machine with three states: Start, Playing, and End Game. The description of these states is as follows:
	
	In the Start state, the game waits for Switch 0 to change its value to 1. Therefore, in all cases when switch 0 is ‘0’, we are in the Start state. The game accepts no other input from the user in this state, and displays a blank grid.
	
	In the Playing state, the switch 0 must be 1, and the game must not be over. That means that there are either available coordinates on the grid for the user to move the boxes or there are boxes that can be merged with their neighbors. The user can input up, down, left, or right using the buttons, and the boxes will "move" based on the user input. 
