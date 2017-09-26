Red/System []


midi-message!: alias struct! [
	command [byte!] ;command byte of the MIDI message, for example: 0x90
	data1   [byte!] ;first data byte of the MIDI message, for example: 60
	data2   [byte!] ;second data byte of the MIDI message, for example 100
	pad     [byte!] ;not used for any MIDI messages, so set to 0
]

#define CALLBACK_NULL 0
#define MMSYSERR_NOERROR      0
#define MMSYSERR_ERROR        1
#define MMSYSERR_BADDEVICEID  2
#define MMSYSERR_NOTENABLED   3
#define MMSYSERR_ALLOCATED    4
#define MMSYSERR_INVALHANDLE  5
#define MMSYSERR_NODRIVER     6
#define MMSYSERR_NOMEM        7
#define MMSYSERR_NOTSUPPORTED 8
#define MMSYSERR_BADERRNUM    9
#define MMSYSERR_INVALFLAG    10
#define MMSYSERR_INVALPARAM   11
#define MMSYSERR_HANDLEBUSY   12
#define MMSYSERR_INVALIDALIAS 13
#define MMSYSERR_BADDB        14
#define MMSYSERR_KEYNOTFOUND  15
#define MMSYSERR_READERROR    16
#define MMSYSERR_WRITEERROR   17
#define MMSYSERR_DELETEERROR  18
#define MMSYSERR_VALNOTFOUND  19
#define MMSYSERR_NODRIVERCB   20
#define MMSYSERR_LASTERROR    20

#import [
	"kernel32.dll" stdcall [
		Sleep: "Sleep" [
			dwMilliseconds	[integer!]
		]
	]
	LIBC-file cdecl [
		_kbhit: "_kbhit" [ return: [integer!] ]
		_getch: "_getch" [ return: [integer!] ]
	]
	"Winmm.dll" stdcall [
		midiOutOpen: "midiOutOpen" [
			lphmo      [int-ptr!]         ;LPHMIDIOUT
			uDeviceID  [integer!]         ;UINT
			dwCallback [int-ptr!]         ;DWORD_PTR
			dwCallbackInstance [int-ptr!] ;DWORD_PTR
			dwFlags    [integer!]         ;DWORD
			return:    [integer!]         ;MMRESULT
		]
		midiOutShortMsg: "midiOutShortMsg" [
			hmo        [integer!]         ;HMIDIOUT
			dwMsg      [integer!]
			return:    [integer!]         ;MMRESULT
		]
		midiOutReset: "midiOutReset" [
			hmo        [integer!]         ;HMIDIOUT
			return:    [integer!]         ;MMRESULT
		]
		midiOutClose: "midiOutClose" [
			hmo        [integer!]         ;HMIDIOUT
			return:    [integer!]         ;MMRESULT
		]
	]
]

message:  0
msg: as midi-message! :message
msg/command: as byte! 90
msg/data1:   as byte! 60
msg/data2:   as byte! 100


notestate: 0   ;keeping track of when the note is on or off
velocity:  100 ;MIDI note velocity parameter value
midiport:  0   ;select which MIDI output port to open
flag:      0   ;monitor the status of returning functions
device:    0   ;MIDI device interface for sending MIDI output

flag: midiOutOpen :device midiport null null CALLBACK_NULL
if flag <> MMSYSERR_NOERROR [
	print-line "Error opening MIDI Output."
	quit 1
]

print-line ["MIDI device: " device]

ckey: 0
forever [
	if 0 <> _kbhit [
		ckey: _getch
		either notestate = 0 [
			msg/data2: as byte! velocity
            notestate: 1
            print-line "Note turned ON."
		][
			msg/data2: as byte! 0;  // 0 velocity = note off
            notestate: 0
            print-line "Note turned OFF."
		]
		flag: midiOutShortMsg device message
		print-line ["out: " as int-ptr! message " " flag]
		if ckey = as integer! #"q" [ break ]
	]
]

midiOutReset device ;turn any MIDI notes currently playing
midiOutClose device ;Remove any data in MIDI device and close the MIDI Output port