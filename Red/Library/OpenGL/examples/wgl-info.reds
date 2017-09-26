Red/System [
	Title:   "Red/System OpenGL info - Windows version without GLFW dependency"
	Purpose: "Prints some informations about supported OpenGL"
	Author:  "Oldes"
	File: 	 %gl-info.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
]

#if OS <> 'Windows [
	print-line "Wgl-info is Windows only!"
	quit 0
]

#include %../../../System/definitions.reds

#include %../wgl.reds
;#include %../gl.reds


#include %../../../System/windows/kernel32.reds
#include %../../../System/windows/ole32.reds



init: func[
	/local
		instance class msg wcex
][
	instance: GetModuleHandle null
	class: #u16 "Wgl-info"
	msg: declare MSG!

	if 0 = OleInitialize null [
		wcex: declare WNDCLASSEX!
		wcex/cbSize: 		size? WNDCLASSEX!
		wcex/hInstance:		instance
		wcex/lpszClassName: class
		wcex/lpfnWndProc:	:WndProc

		RegisterClassEx wcex

		;// Free the OLE library.
		OleUninitialize
	]
]
WndProc: func [
	hWnd	[handle!]
	msg		[integer!]
	wParam	[integer!]
	lParam	[integer!]
	return: [integer!]
][
	;TRACE( ["WinProc: " msg " hWnd: " hWnd] )
	switch msg [
		5 [;size
			print-line "resize"
			;return 0
		]
		1 [;create
			print-line "create"
			;return 0
		]
		2 [;destroy
			;PostQuitMessage 0
			print-line "destroy"
			return 1
		]
		default [
		]
	]
	DefWindowProc hWnd msg wParam lParam
]

;WndProc: func [
;	hWnd	[handle!]
;	msg		[integer!]
;	wParam	[integer!]
;	lParam	[integer!]
;	return: [integer!]
;][
;	;TRACE( ["WinProc: " msg " hWnd: " hWnd] )
;	switch msg [
;		5 [;size
;			ResizeBrowser hWnd WIN32_LOWORD(lParam) WIN32_HIWORD(lParam)
;			return 0
;		]
;		1 [;create
;			return either 0 <> EmbedBrowserObject hWnd [0][-1]
;		]
;		2 [;destroy
;			PostQuitMessage 0
;			return 1
;		]
;		default [
;		]
;	]
;	DefWindowProc hWnd msg wParam lParam
;]