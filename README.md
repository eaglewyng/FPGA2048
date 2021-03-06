FPGA2048
========

2048 FPGA Version

2048 Game Specification
This repository contains a game of 2048.

The specifications of this project are as follows:

Grid:
	The grid is a 4x4 grid of boxes that has a brownish-gray background. The grid contains a number of boxes, depending on the state of the game. The grid begins with two boxes, which are placed on randomly chosen coordinates on the board.  Each square has a value assigned to it, and if two of squares with the same value collide, they “combine” and make a new square with double the value. For more information about the gameplay, please go to http://gabrielecirulli.github.io/2048/. 
	
	We built our own font to display the numbers on the grid. The colors are made to mimic the colors of the game on the site above. The winning color is blue. If the user loses, the board turns red. 
	
	To implement this, we made a main Finite State Machine with three states: Start, Playing, and End Game. The description of these states is as follows:
	
	In the Start state, the game waits for Switch 0 to change its value to 1. Therefore, in all cases when switch 0 is ‘0’, we are in the Start state. The game accepts no other input from the user in this state and the VGA is blank.
	
	In the Playing state, the switch 0 must be 1, and the game must not be over. That means that there are either available coordinates on the grid for the user to move the boxes or there are boxes that can be merged with their neighbors. The user can input up, down, left, or right using the buttons, and the boxes will "move" based on the user input. 

When two boxes are next to each other and they have the same value, the boxes will merge into another box with twice the value.

We use the VGA display to show the score. The score is currently the total number of times a user has pressed a button without losing.
