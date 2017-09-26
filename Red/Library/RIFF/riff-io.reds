Red/System [
	Title:	"RIFF (Resource Interchange File Format) related function"
	Purpose: "Provides RIFF related reading/writing functions"
	Author: "Oldes"
	File: 	%riff-io.reds
	Tabs: 	4
	Rights: "Copyright (C) 2017 Oldes. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

#include %../Stream-IO/Stream-IO-core.reds
#include %../Stream-IO/Stream-IO-read.reds
#include %../Stream-IO/Stream-IO-write.reds

riff-stream!: alias struct! [
	size        [integer!]
	type        [integer!]
	in          [sio-buffer!]
]

#define RIFF_ID        46464952h
#define RIFF_TYPE_WAVE 45564157h
#define RIFF_TYPE_AVI  20495641h
#define RIFF_TYPE_ACON 4E4F4341h

#define RIFF_CHUNK_FMT  20746D66h
#define RIFF_CHUNK_DATA 61746164h
#define RIFF_CHUNK_SMPL 6C706D73h
#define RIFF_CHUNK_LIST 5453494Ch
#define RIFF_CHUNK_JUNK 4B4E554Ah
#define RIFF_CHUNK_JUN  4E554A00h
#define RIFF_CHUNK_AVIH 68697661h
#define RIFF_CHUNK_STRN 6E727473h
#define RIFF_CHUNK_STRH 68727473h
#define RIFF_CHUNK_STRF 66727473h
#define RIFF_CHUNK_STRD 64727473h
#define RIFF_CHUNK_IDX1 31786469h
#define RIFF_CHUNK__PMX 584D505Fh
#define RIFF_CHUNK_INAM 4D414E49h

#define RIFF_TYPE_LIST_MOVI 69766F6Dh
#define RIFF_TYPE_LIST_HDRL 6C726468h
#define RIFF_TYPE_LIST_INFO 4F464E49h


#define RIFF_MAX_STREAM_COUNT 8 
#define riff-ptr! [struct! [value [riff-stream!]]]

#define IN_AS_FOURCC [in/pos/1 in/pos/2  in/pos/3 in/pos/4]

riff: context [
	streams-head: as riff-ptr! allocate RIFF_MAX_STREAM_COUNT * 4
	streams-tail: streams-head + RIFF_MAX_STREAM_COUNT
	streams-count: RIFF_MAX_STREAM_COUNT
	set-memory as byte-ptr! streams-head #"^@" (RIFF_MAX_STREAM_COUNT * 4)

	verbose: 1
	indent: 0

	print-indent: func[/local i][
		i: 0
		while [i < indent] [
			writeFormated "  "
			i: i + 1
		]
	]

	get-stream: func[
		index [integer!]
		return: [riff-stream!]
		/local p [riff-ptr!]
	][
		if any [index < 0 index >= streams-count][
			print-line ["Invalid RIFF stream index: " index]
			return null
		]
		p: streams-head + index
		p/value
	]
	get-free-stream: func[
		index   [int-ptr!]
		return: [riff-stream!]
		/local
			p [riff-ptr!]
			i [integer!]
			stream [riff-stream!]
	][
		p: streams-head
		while [p < streams-tail][
			stream: p/value
			if stream = null [
				stream: as riff-stream! allocate size? riff-stream!
				p/value: stream
				index/value: (as integer! (p - streams-head)) / 4
				return stream
			]
			print-line [stream " " stream/in " "]
			if all [stream/in <> null stream/in/head = null] [
				index/value: (as integer! (p - streams-head)) / 4
				return stream
			]
			p: p + 1
		]
		if verbose > 0 [print-line "RIFF_MAX_STREAM_COUNT reached!"]

		return null
	]
	close: func[
		index [integer!]
		/local
			stream [riff-stream!]
	][
		stream: get-stream index
		if all [stream <> null stream/in <> null] [
			;free-buffer stream/in
			print-line ["closed wav: " index]
		]
	]

	process-chunks: func[
		end [byte-ptr!]
		/local
			id [integer!]
			size [integer!]
			chunk-end  [byte-ptr!]
			list-chunk-end [byte-ptr!]
			type [integer!]
			str [c-string!]
	][
		indent: indent + 1
		while [in/pos < end][
			id:   readUI32
			size: readUI32
			;print-line ["id: " as int-ptr! id " size: " size]
			chunk-end: in/pos + size

			switch id [
				RIFF_CHUNK_FMT [
					print-indent writeFormated "\_ FMT^/"
					print-indent writeFormated ["   compression:   " readUI16 lf]
					print-indent writeFormated ["   channels:      " readUI16 lf]
					print-indent writeFormated ["   sampleRate:    " readUI32 lf]
					print-indent writeFormated ["   bytesPerSec:   " readUI32 lf]
					print-indent writeFormated ["   blockAlign:    " readUI16 lf]
					print-indent writeFormated ["   bitsPerSample: " readUI16 lf]
					print-indent writeFormated ["   extraBytes:    " readUI16 lf]
				]
				RIFF_CHUNK_DATA [
					print-indent writeFormated "\_ DATA^/"
				]
				RIFF_CHUNK_SMPL [
					print-indent writeFormated "\_ SMPL^/"
				]
				RIFF_CHUNK_LIST [
					id: readUI32
					print-indent writeFormated [{\_ LIST type: "} in/pos/-3 in/pos/-2  in/pos/-1 in/pos/0 {" } as int-ptr! id lf]
					process-chunks chunk-end
				]
				RIFF_CHUNK_AVIH [
					print-indent writeFormated "\_ avih (main AVI Header)"
					print-indent writeFormated ["   MicroSecPerFrame:    " readUI32 lf]
					print-indent writeFormated ["   MaxBytesPerSec:      " readUI32 lf]
					print-indent writeFormated ["   PaddingGranularity:  " readUI32 lf]
					print-indent writeFormated ["   Flags:               " readUI32 lf]
					print-indent writeFormated ["   TotalFrames:         " readUI32 lf]
					print-indent writeFormated ["   InitialFrames:       " readUI32 lf]
					print-indent writeFormated ["   Streams:             " readUI32 lf]
					print-indent writeFormated ["   SuggestedBufferSize: " readUI32 lf]
					print-indent writeFormated ["   Width:               " readUI32 lf]
					print-indent writeFormated ["   Height:              " readUI32 lf]
					;print-indent writeFormated ["   Reserved: " readUI32]
				]
				RIFF_CHUNK_STRH [
					print-indent writeFormated "\_ strh (Stream header)"
					print-indent writeFormated ["   Type:                " IN_AS_FOURCC lf] in/pos: in/pos + 4
					print-indent writeFormated ["   Handler:             " IN_AS_FOURCC lf] in/pos: in/pos + 4
					print-indent writeFormated ["   Flags:               " readUI32 lf]
					print-indent writeFormated ["   Priority:            " readUI16 lf]
					print-indent writeFormated ["   Language:            " readUI16 lf]
					print-indent writeFormated ["   InitialFrames:       " readUI32 lf]
					print-indent writeFormated ["   Scale:               " readUI32 lf]
					print-indent writeFormated ["   Rate:                " readUI32 lf]
					print-indent writeFormated ["   Start:               " readUI32 lf]
					print-indent writeFormated ["   Length:              " readUI32 lf]
					print-indent writeFormated ["   SuggestedBufferSize: " readUI32 lf]
					print-indent writeFormated ["   Quality:             " readUI32 lf]
					print-indent writeFormated ["   SampleSize:          " readUI32 lf]
					print-indent writeFormated ["   Frame:   [" readUI16 #" " readUI16 #" " readUI16 #" " readUI16 #"]" lf]

				]
				RIFF_CHUNK_STRF [
					print-indent writeFormated "\_ strf (Stream format)^/"
				]
				RIFF_CHUNK_STRD [
					print-indent writeFormated "\_ strd (Additional header data)^/"
				]
				RIFF_CHUNK_STRN [
					print-indent writeFormated "\_ strn (Stream name)^/"
				]
				RIFF_CHUNK_IDX1 [
					print-indent writeFormated "\_ idx1 (AVI Index)^/"
				]
				RIFF_CHUNK_JUNK
				RIFF_CHUNK_JUN [
					print-indent writeFormated "\_ JUNK^/"
				]
				RIFF_CHUNK__PMX [
					print-indent writeFormated "\_ _PMX (XMP Tags)^/"
					str: readAsString size
					writeFormated str
					free as byte-ptr! str ;@@ readAsString creates a new string so we must free it from memory once we don't need it!
				]
				RIFF_CHUNK_INAM [
					print-indent writeFormated "\_ INAM^/"
					;print-indent writeFormated [{   Name: "} as c-string! in/pos #"^""]
				]
				default [
					print-indent writeFormated [{\_ chunk: "} in/pos/-7 in/pos/-6  in/pos/-5 in/pos/-4 {" } as int-ptr! id lf ]
				]
			]
			in/pos: chunk-end
		]
		indent: indent - 1
	]
	open: func[
		name [c-string!]
		return: [integer!]
		/local
			in-buffer  [sio-buffer!]
			out-buffer [sio-buffer!]
			index [integer!]
			bytes [byte-ptr!]
			file-handle [integer!]
			stream [riff-stream!]
			id [integer!]
			size [integer!]
			chunk-end  [byte-ptr!]
	][
		index: -1
		stream: get-free-stream :index
		if stream = null [return -1]

		in-buffer: alloc-buffer null 0
		out-buffer: alloc-buffer null 32768

		out: out-buffer

		if 1 = init-in-from-file-name in-buffer name [
			in: in-buffer ;in is global variable for Stream-IO functions
			stream/in: in-buffer
			id: readUI32
			either RIFF_ID = id [
				writeFormated "IS RIFF^/"
				stream/size: readUI32
				stream/type: readUI32
				writeFormated ["size: " stream/size " type: " as int-ptr! stream/type lf]
				switch stream/type [
					RIFF_TYPE_WAVE [
						writeFormated "source is of type: WAVE^/"
						process-chunks in/end
					]
					RIFF_TYPE_AVI [
						writeFormated "source is of type: AVI^/"
						process-chunks in/end
					]
					RIFF_TYPE_ACON [
						writeFormated "source is of type: ANI (Animated cursor)^/"
						process-chunks in/end
					]
					default [
						writeFormated [{unknown RIFF type: "} in/pos/-3 in/pos/-2  in/pos/-1 in/pos/0 #"^"" lf]
					]
				]
			][
				writeFormated ["unknown id: " id lf]
			]
		]

		writeUI8 0 ;closing c-string
		print-line as c-string! out/head
		index
	]

	wav: open "jaguar.wav"
	print-line ["^/opened wav? " wav]
	wav2: open "zblunk_02.wav"
	print-line ["^/opened wav2? " wav2]
	close wav
	close wav2

	wav: open "cur28.ani"
	close wav

	

;	parse: func[
;		return: [c-string!]
;		/local
;			i     [integer!]
;			bytes [byte-ptr!]
;			id    [integer!]
;			format pos
;	][
;		out: alloc-buffer out 32768
;
;		;
;		writeUI8 0 ;closing c-string
;		as c-string! out/head
;	]
	
	
]


