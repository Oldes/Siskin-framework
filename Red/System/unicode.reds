Red/System [
	Title:   "Unicode codecs - Basic Red runtime independent version"
	Author:  "Nenad Rakocevic, Rudolf W. Meijer"
	File: 	 %unicode.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2015 Nenad Rakocevic. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

;use this code only when Red runtime is not embedded 
#if red-pass? = no [
unicode: context [
	verbose: 0

	#define U_REPLACEMENT 	FFFDh
	#define NOT_A_CHARACTER FFFEh
	;	choose one of the following options
	;	FFFDh			; U+FFFD = replacement character
	;	1Ah				; U+001A = control SUB (substitute)
	;	241Ah			; U+241A = symbol for substitute
	;	2426h			; U+2426 = symbol for substitute form two
	;	3Fh				; U+003F = question mark
	;	BFh				; U+00BF = inverted question mark
	;	DC00h + b1		; U+DCxx where xx = b1 (never a Unicode codepoint)

	utf8-char-size?: func [
		byte-1st	[integer!]
		return:		[integer!]
	][
		;@@ In function unicode/decode-utf8-char
		;@@ just support up to four bytes in a UTF-8 sequence
		;if byte-1st and FCh = FCh [return 6]
		;if byte-1st and F8h = F8h [return 5]
		if byte-1st and F0h = F0h [return 4]
		if byte-1st and E0h = E0h [return 3]
		if byte-1st and C0h = C0h [return 2]
		0
	]

	cp-to-utf8: func [
		cp		[integer!]
		buf		[byte-ptr!]
		return: [integer!]
	][
		case [
			cp <= 7Fh [
				buf/1: as-byte cp
				1
			]
			cp <= 07FFh [
				buf/1: as-byte cp >> 6 or C0h
				buf/2: as-byte cp and 3Fh or 80h
				2
			]
			cp < 0000FFFFh [
				buf/1: as-byte cp >> 12 or E0h
				buf/2: as-byte cp >> 6 and 3Fh or 80h
				buf/3: as-byte cp	   and 3Fh or 80h
				3
			]
			cp < 0010FFFFh [
				buf/1: as-byte cp >> 18 or F0h
				buf/2: as-byte cp >> 12 and 3Fh or 80h
				buf/3: as-byte cp >> 6  and 3Fh or 80h
				buf/4: as-byte cp 		and 3Fh or 80h
				4
			]
			true [
				fire [TO_ERROR(script invalid-char) char/push cp]
				0
			]
		]
	]


	scan-utf16: func [									;-- detect codepoint max storage size
		src		[c-string!]
		size	[integer!]
		return: [integer!]								;-- 1, 2 or 4 (bytes per codepoint)
		/local
			unit [integer!]
			c	 [byte!]
	][
		unit: 1
		src: src + 1
		while [size > 0][
			c: src/1									;-- UTF-16LE, high byte in 2nd position
			if all [#"^(D8)" <= c c <= #"^(DF)"][return 4]	;-- max
			if c <> null-byte [unit: 2]
			src: src + 2
			size: size - 1
		]
		unit
	]

	count-extras: func [								;-- count LF and extra bytes for cp > 00010000h
		p 		[byte-ptr!]
		tail 	[byte-ptr!]
		unit	[integer!]
		return: [integer!]
		/local
			p4	  [int-ptr!]
			extra [integer!]
			cp	  [integer!]
	][
		extra: 0
		while [p < tail][
			cp: switch unit [
				Latin1 [as-integer p/value]
				UCS-2  [(as-integer p/2) << 8 + p/1]
				UCS-4  [p4: as int-ptr! p p4/value]
			]
			if any [
				cp = as-integer LF						;-- account for extra CR
				cp > 00010000h							;-- account for surrrogate pair
			][
				extra: extra + 2
			]
			p: p + unit
		]
		extra
	]
	
	cp-to-utf16: func [
		cp		[integer!]
		buf		[byte-ptr!]
		return: [integer!]				;-- return number of utf16 codepoint
		/local
			unit [integer!]
	][
		case [
			cp < 00010000h [
				buf/1: as-byte cp
				buf/2: as-byte cp >> 8
				1
			]
			cp < 00110000h [
				cp: cp - 00010000h
				unit: cp >> 10 or D800h
				buf/1: as-byte unit
				buf/2: as-byte unit >> 8
				unit: cp and 03FFh or DC00h
				buf/3: as-byte unit
				buf/4: as-byte unit >> 8
				2
			]
			true [print "Error: to-utf16 codepoint overflow" 0]
		]
	]
]
]
