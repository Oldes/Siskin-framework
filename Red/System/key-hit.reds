Red/System [
	Title:   "Key-hit and key-hit-char"
	Purpose: "Red/System function to determine if a key has been pressed or not"
	Author:  "Oldes"
	File: 	 %key-hit.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https:;//github.com/red/red/blob/master/BSD-3-License.txt"
	Usage: [
		key: 0
		print-line "Press Q to quit."
		forever [
			if key-hit [
				key: key-hit-char
				switch key [
					#"q" #"Q" [ break ]
					default [
						print-line ["pressed key with code: " key]
					]
				]
			]
		]	
	]
]

#import [LIBC-file cdecl [
	#either OS = 'Windows [
		kbhit:   "_kbhit" [ return: [integer!] ]
		getchar: "_getch" [ return: [integer!] ]
	][
		kbhit:   "kbhit"   [ return: [integer!] ]
		getchar: "getchar" [ return: [integer!] ]
	]
]]

#define key-hit [0 <> kbhit]
#define key-hit-char getchar
		
	