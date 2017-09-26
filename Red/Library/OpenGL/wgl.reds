Red/System [
	Title:   "Red/System interface between OpenGL and the windowing system of Windows"
	Author:  "Oldes"
	File: 	 %wgl.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
	Comment: {More info: https://msdn.microsoft.com/en-us/library/windows/desktop/dd374394(v=vs.85).aspx}
]

;--> content of this file makes sense only on Windows <--

#if OS = 'Windows  [
	#import [ "opengl32.dll" stdcall [
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
			hdc         [handle!]
			iLayerPlane [integer!]
			return:     [handle!]
		]
		wglDeleteContext: "wglDeleteContext" [
		;deletes a specified OpenGL rendering context.
			hglrc       [handle!]
			return:     [logic!]
		]
		wglDescribeLayerPlane: "wglDescribeLayerPlane" [
		;obtains information about the layer planes of a given pixel format.
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
	]] ;end of #import
]
