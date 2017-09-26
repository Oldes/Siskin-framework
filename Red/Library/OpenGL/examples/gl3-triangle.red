Red [
	Title:   "Red OpenGL basic triangle example using new OpenGL"
	Author:  "Oldes"
	File:    %gl3-triangle.red
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
	Note: {
		This code is Red/System port of tutorial from:
		http://www.opengl-tutorial.org/beginners-tutorials/tutorial-1-opening-a-window/
		http://www.opengl-tutorial.org/beginners-tutorials/tutorial-2-the-first-triangle/
	}
	Needs: View
]

view/no-wait layout [size 300x200 button "Hello" [print now]]
#system [
	#include %gl3-triangle.reds
]