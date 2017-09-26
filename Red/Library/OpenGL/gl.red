Red [
	Title:   "Red OpenGL binding"
	Author:  "Oldes"
	File:    %gl.red
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
	Needs:   View
]
#system [
	#either modules contains 'View [

		;#define WM_CREATE                       0001h
		;#define WM_DESTROY                      0002h
		;#define WM_MOVE                         0003h
		;#define WM_SIZE                         0005h
		#define WM_QUIT                         0012h
		;#define WM_ERASEBKGND                   0014h
		#define WM_SYSCOLORCHANGE               0015h
		#define WM_SHOWWINDOW                   0018h
		#define WM_WININICHANGE                 001Ah

		; PIXELFORMATDESCRIPTOR flags
		#define PFD_DOUBLEBUFFER            00000001h
		#define PFD_STEREO                  00000002h
		#define PFD_DRAW_TO_WINDOW          00000004h
		#define PFD_DRAW_TO_BITMAP          00000008h
		#define PFD_SUPPORT_GDI             00000010h
		#define PFD_SUPPORT_OPENGL          00000020h
		#define PFD_GENERIC_FORMAT          00000040h
		#define PFD_NEED_PALETTE            00000080h
		#define PFD_NEED_SYSTEM_PALETTE     00000100h
		#define PFD_SWAP_EXCHANGE           00000200h
		#define PFD_SWAP_COPY               00000400h
		#define PFD_SWAP_LAYER_BUFFERS      00000800h
		#define PFD_GENERIC_ACCELERATED     00001000h
		#define PFD_SUPPORT_DIRECTDRAW      00002000h
		#define PFD_DIRECT3D_ACCELERATED    00004000h
		#define PFD_SUPPORT_COMPOSITION     00008000h

		; pixel types
		#define PFD_TYPE_RGBA        0
		#define PFD_TYPE_COLORINDEX  1

		; layer types 
		#define PFD_MAIN_PLANE       0
		#define PFD_OVERLAY_PLANE    1
		#define PFD_UNDERLAY_PLANE  -1

		#define COLORREF! integer!

		PIXELFORMATDESCRIPTOR!: alias struct! [
			nSize-nVersion   [integer!]  ;WORD + WORD
			dwFlags          [integer!]  ;DWORD 
			iPixelType       [byte!]  
			cColorBits       [byte!]  
			cRedBits         [byte!]  
			cRedShift        [byte!]  
			cGreenBits       [byte!]  
			cGreenShift      [byte!]  
			cBlueBits        [byte!]  
			cBlueShift       [byte!]  
			cAlphaBits       [byte!]  
			cAlphaShift      [byte!]  
			cAccumBits       [byte!]  
			cAccumRedBits    [byte!]  
			cAccumGreenBits  [byte!]  
			cAccumBlueBits   [byte!]  
			cAccumAlphaBits  [byte!]  
			cDepthBits       [byte!]  
			cStencilBits     [byte!]  
			cAuxBuffers      [byte!]  
			iLayerType       [byte!]  
			bReserved        [byte!]  
			dwLayerMask      [integer!]  ;DWORD 
			dwVisibleMask    [integer!]  ;DWORD 
			dwDamageMask     [integer!]  ;DWORD
		]

		LAYERPLANEDESCRIPTOR!: alias struct! [
			nSize-nVersion   [integer!]  ;WORD + WORD
			dwFlags          [integer!]  ;DWORD 
			iPixelType       [byte!]  
			cColorBits       [byte!]  
			cRedBits         [byte!]  
			cRedShift        [byte!]  
			cGreenBits       [byte!]  
			cGreenShift      [byte!]  
			cBlueBits        [byte!]  
			cBlueShift       [byte!]  
			cAlphaBits       [byte!]  
			cAlphaShift      [byte!]  
			cAccumBits       [byte!]  
			cAccumRedBits    [byte!]  
			cAccumGreenBits  [byte!]  
			cAccumBlueBits   [byte!]  
			cAccumAlphaBits  [byte!]  
			cDepthBits       [byte!]  
			cStencilBits     [byte!]  
			cAuxBuffers      [byte!]  
			iLayerType       [byte!]  
			bReserved        [byte!]  
			crTransparent    [COLORREF!]
		]

		POINTFLOAT!: alias struct! [
			x [float32!]
			y [float32!]
		]

		GLYPHMETRICSFLOAT!: alias struct! [
			gmfBlackBoxX     [float32!]
			gmfBlackBoxY     [float32!]
			gmfptGlyphOrigin [POINTFLOAT!]
			gmfCellIncX      [float32!]
			gmfCellIncY      [float32!]
		]

		wndproc-cb!: alias function! [
			hWnd    [handle!]
			msg     [integer!]
			wParam  [integer!]
			lParam  [integer!]
			return: [integer!]
		]
		WNDCLASSEX: alias struct! [
			cbSize        [integer!]
			style         [integer!]
			lpfnWndProc   [wndproc-cb!]
			cbClsExtra    [integer!]
			cbWndExtra    [integer!]
			hInstance     [handle!]
			hIcon         [handle!]
			hCursor       [handle!]
			hbrBackground [integer!]
			lpszMenuName  [c-string!]
			lpszClassName [c-string!]
			hIconSm       [integer!]
		]
		#import [
			"user32.dll" stdcall [
				RegisterClassEx: "RegisterClassExW" [
					lpwcx       [WNDCLASSEX]
					return:     [integer!]
				]
				DefWindowProc: "DefWindowProcW" [
					hWnd        [handle!]
					msg         [integer!]
					wParam      [integer!]
					lParam      [integer!]
					return:     [integer!]
				]
				GetDC: "GetDC" [
					hWnd    [handle!]
					return: [handle!]
				]
			]
			"gdi32.dll" stdcall [
				ChoosePixelFormat: "ChoosePixelFormat" [
					hdc     [handle!]
					ppfd    [PIXELFORMATDESCRIPTOR!]
					return: [integer!]
				]
				SetPixelFormat: "SetPixelFormat" [
					hdc     [handle!]
					iPixelFormat [integer!]
					ppfd    [PIXELFORMATDESCRIPTOR!]
					return: [logic!]
				]
				SwapBuffers: "SwapBuffers" [
					hdc     [handle!]
					return: [logic!]
				]
			]
			"opengl32.dll" stdcall [
				wglCopyContext: "wglCopyContext" [
				;copies selected groups of rendering states from one OpenGL rendering context to another.
					src         [handle!]
					dst         [handle!]
					mask        [integer!]
					return:     [logic!]
				]
				wglCreateContext: "wglCreateContext" [
				;creates a new OpenGL rendering context, which is suitable for drawing on the device referenced by hdc. The rendering context has the same pixel format as the device context.
					hdc         [handle!]
					return:     [handle!]
				]
				wglCreateLayerContext: "wglCreateLayerContext" [
				;creates a new OpenGL rendering context for drawing to a specified layer plane on a device context.
				;https://msdn.microsoft.com/en-us/library/windows/desktop/dd374380(v=vs.85).aspx
					hdc         [handle!]
					iLayerPlane [integer!]
					return:     [handle!]
				]
				wglDeleteContext: "wglDeleteContext" [
				;deletes a specified OpenGL rendering context.
				;https://msdn.microsoft.com/en-us/library/windows/desktop/dd374381(v=vs.85).aspx
					hglrc       [handle!]
					return:     [logic!]
				]
				wglDescribeLayerPlane: "wglDescribeLayerPlane" [
				;obtains information about the layer planes of a given pixel format.
				;https://msdn.microsoft.com/en-us/library/windows/desktop/dd374382(v=vs.85).aspx
					hdc          [handle!]
					iPixelFormat [integer!]
					iLayerPlane  [integer!]
					return:      [LAYERPLANEDESCRIPTOR!]
				]
				wglGetCurrentContext: "wglGetCurrentContext" [
				;obtains a handle to the current OpenGL rendering context of the calling thread.
					return:      [handle!]
				]
				wglGetCurrentDC: "wglGetCurrentDC" [
				;obtains a handle to the device context that is associated with the current OpenGL rendering context of the calling thread.
					return:      [handle!]
				]
				wglGetLayerPaletteEntries: "wglGetLayerPaletteEntries" [
				;Retrieves the palette entries from a given color-index layer plane for a specified device context.
					hdc          [handle!]
					iLayerPlane  [integer!]
					iStart       [integer!]
					cEntries     [integer!]
					pcr          [COLORREF!]
					return:      [integer!] ;f the function succeeds, the return value is the number of entries that were set in the palette in the specified layer plane of the window
				]
				wglGetProcAddress: "wglGetProcAddress" [
				;returns the address of an OpenGL extension function for use with the current OpenGL rendering context.
					procname     [c-string!]
					return:      [pointer! [integer!]]
				]
				wglMakeCurrent: "wglMakeCurrent" [
				;makes a specified OpenGL rendering context the calling thread's current rendering context.
					hdc          [handle!]
					hglrc        [handle!]
					return:      [logic!]
				]
				wglRealizeLayerPalette: "wglRealizeLayerPalette" [
				;maps palette entries from a given color-index layer plane into the physical palette or initializes the palette of an RGBA layer plane.
					hdc          [handle!]
					iLayerPlane  [integer!]
					bRealize     [logic!]
					return:      [logic!]
				]
				wglSetLayerPaletteEntries: "wglSetLayerPaletteEntries" [
				;Sets the palette entries in a given color-index layer plane for a specified device context.
					hdc          [handle!]
					iLayerPlane  [integer!]
					iStart       [integer!]
					cEntries     [integer!]
					pcr          [COLORREF!]
					return:      [integer!] 
				]
				wglShareLists: "wglShareLists" [
				;enables multiple OpenGL rendering contexts to share a single display-list space.
					hglrc1       [handle!]
					hglrc2       [handle!]
					return:      [logic!]
				]
				wglSwapLayerBuffers: "wglSwapLayerBuffers" [
				;swaps the front and back buffers in the overlay, underlay, and main planes of the window referenced by a specified device context.
					hdc          [handle!]
					fuPlanes     [integer!]
					return:      [logic!]
				]
				wglUseFontBitmaps: "wglUseFontBitmaps" [
				;creates a set of bitmap display lists for use in the current OpenGL rendering context.
					hdc          [handle!]
					first        [integer!]
					count        [integer!]
					listBase     [integer!]
					return:      [logic!]
				]
				wglUseFontOutlines: "wglUseFontOutlines" [
					hdc          [handle!]
					first        [integer!]
					count        [integer!]
					listBase     [integer!]
					deviation    [float32!]
					extrusion    [float32!]
					format       [integer!]
					lpgmf        [GLYPHMETRICSFLOAT!]
					return:      [logic!]
				]
				
				

				glViewport: "glViewport"[
					x           [ integer! ]
					y           [ integer! ]
					width       [ integer! ]
					height      [ integer! ]
				]
				glGetString: "glGetString" [ name [integer!] return: [c-string!] ]
				glClearColor: "glClearColor"[
					red         [ float32! ]
					green       [ float32! ]
					blue        [ float32! ]
					alpha       [ float32! ]
				]
			]
		]

		OpenGLWndProc: func [
			hWnd        [handle!]
			msg         [integer!]
			wParam      [integer!]
			lParam      [integer!]
			return: [integer!]
			/local hdc pf pfd hglrc
		] [
			hglrc: wglGetCurrentContext
			
			switch msg [
				5 [;WM_SIZE
					print-line ["GL: resize: " wParam " " WIN32_LOWORD(lParam) "x" WIN32_HIWORD(lParam)]
					;if hglrc <> null [
						glViewport 0 0 WIN32_LOWORD(lParam) WIN32_HIWORD(lParam)
					;]
					return 0
				]
				WM_SHOWWINDOW [
					print-line ["GL: Show: " wParam]
				]
				WM_MOVE [
					print-line ["GL: Move: " WIN32_LOWORD(lParam) "x" WIN32_HIWORD(lParam)]
				]
				1 [;create

					hdc: GetDC hWnd
					print-line ["CREATE CONTEXT " hdc]
					pfd: declare PIXELFORMATDESCRIPTOR!

					set-memory as byte-ptr! pfd #"^@" size? PIXELFORMATDESCRIPTOR!
					pfd/nSize-nVersion: 00280001h
					pfd/dwFlags:        PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER
					pfd/iPixelType:     as byte! PFD_TYPE_RGBA
					pfd/cColorBits:     as byte! 32
					pfd/cDepthBits:     as byte! 24
					pfd/cStencilBits:   as byte! 8

					pf: ChoosePixelFormat hdc pfd

					print-line ["pf: " pf] 
					if pf = 0 [
						print-line "Could not find a pixel format.. OpenGL cannot create its context."
						return 0
					]

					print-line SetPixelFormat   hdc pf pfd
					hglrc: wglCreateContext hdc
					either hglrc <> null [
						print-line wglMakeCurrent hdc hglrc
					][
						print-line "Failed to create OpenGL context!"
					]

					print-line "OPENGL CONTEXT CREATED!"
					print-line ["Version: " glGetString 1F02h]

					;background color:
					glClearColor .0 .0 .6 .0

					;;Enable depth test
					;glEnable GL_DEPTH_TEST
					;;Accept fragment if it closer to the camera than the former one
					;glDepthFunc GL_LESS 

					return 0
				]
				WM_DESTROY [
					hglrc: wglGetCurrentContext
					print-line ["destroy GL context: " hglrc]
					print-line wglDeleteContext hglrc
				]
				15  [
					print-line "GL: WM_PAINT"
					glClearColor .5 .0 .6 .0
					print-line SwapBuffers GetDC hWnd
				]
				20  [ print-line "GL: WM_ERASEBKGND"]
				32  [ print-line "GL: WM_SETCURSOR"]
				34  [ print-line "GL: WM_CHILDACTIVATE"]
				48  [ print-line "GL: WM_SETFONT"]
				
				70  [ print-line "GL: WM_WINDOWPOSCHANGING"]
				71  [ print-line "GL: WM_WINDOWPOSCHANGED"]
				132 [ print-line "GL: WM_NCHITTEST"]
				133 [ print-line "GL: WM_NCPAINT"]
				512 [ print-line "GL: WM_MOUSEFIRST"]
				default [
					print-line ["GLWndProc: " msg " hWnd: " hWnd " hglrc: " hglrc]
				]
			]
			DefWindowProc hWnd msg wParam lParam
		]

		wcex: declare WNDCLASSEX
		hInstance:  as handle! 0

		wcex/cbSize:        size? WNDCLASSEX
		wcex/hInstance:     hInstance
		wcex/lpszClassName: #u16 "RedOpenGL"
		wcex/lpfnWndProc:   :OpenGLWndProc
		
		RegisterClassEx wcex

		gui/register-class [                    ;-- returns old events handler
			#u16 "RedOpenGL"                    ;-- widget original name
			null                                ;-- new internal name
			symbol/make "OpenGL"                ;-- Red-level style name
			0                                   ;-- exStyle flags
			0                                   ;-- style flags
			0                                   ;-- base ID for instances
			null                                ;-- style custom event handler
			null                                ;-- parent custom event handler
		]



	][
		print "missing view"
	]
]


system/view/vid/styles/OpenGL: [
	default-actor: on-change 
	template: [
		type: 'OpenGL size: 320x240 url: none
		on-change*: function [word old new][
			;print ["change" word old new mold state]
		]
	]
]

g: none
view layout [button "Hello OpenGL!" return g: opengl ]
