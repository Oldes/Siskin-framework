Red/System [
	Title:   "Red/System libsndfile binding"
	Author:  "Oldes"
	File: 	 %sndfile.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
	Note: {Based on libSNDFILE source of version: 1.3.5 from www.xiph.org/SNDFILE/}
]


#switch OS [
	Windows   [	#define SNDFILE_LIBRARY "libsndfile-1.dll" ]
	macOS     [ #define SNDFILE_LIBRARY "libsndfile-1.dylib" ] ;@@ not tested!
	#default  [ #define SNDFILE_LIBRARY "libsndfile-1.so" ] ;@@ not tested!
]

/* The following file types can be read and written.
** A file type would consist of a major type (ie SF_FORMAT_WAV) bitwise
** ORed with a minor type (ie SF_FORMAT_PCM). SF_FORMAT_TYPEMASK and
** SF_FORMAT_SUBMASK can be used to separate the major and minor file
** types.
*/

#enum sf-format! [
    ; Major formats.
    SF_FORMAT_WAV:           00010000h      ;Microsoft WAV format (little endian default).
    SF_FORMAT_AIFF:          00020000h      ;Apple/SGI AIFF format (big endian).
    SF_FORMAT_AU:            00030000h      ;Sun/NeXT AU format (big endian).
    SF_FORMAT_RAW:           00040000h      ;RAW PCM data.
    SF_FORMAT_PAF:           00050000h      ;Ensoniq PARIS file format.
    SF_FORMAT_SVX:           00060000h      ;Amiga IFF / SVX8 / SV16 format.
    SF_FORMAT_NIST:          00070000h      ;Sphere NIST format.
    SF_FORMAT_VOC:           00080000h      ;VOC files.
    SF_FORMAT_IRCAM:         000A0000h      ;Berkeley/IRCAM/CARL
    SF_FORMAT_W64:           000B0000h      ;Sonic Foundry's 64 bit RIFF/WAV
    SF_FORMAT_MAT4:          000C0000h      ;Matlab (tm) V4.2 / GNU Octave 2.0
    SF_FORMAT_MAT5:          000D0000h      ;Matlab (tm) V5.0 / GNU Octave 2.1
    SF_FORMAT_PVF:           000E0000h      ;Portable Voice Format
    SF_FORMAT_XI:            000F0000h      ;Fasttracker 2 Extended Instrument
    SF_FORMAT_HTK:           00100000h      ;HMM Tool Kit format
    SF_FORMAT_SDS:           00110000h      ;Midi Sample Dump Standard
    SF_FORMAT_AVR:           00120000h      ;Audio Visual Research
    SF_FORMAT_WAVEX:         00130000h      ;MS WAVE with WAVEFORMATEX
    SF_FORMAT_SD2:           00160000h      ;Sound Designer 2
    SF_FORMAT_FLAC:          00170000h      ;FLAC lossless file format
    SF_FORMAT_CAF:           00180000h      ;Core Audio File format
    SF_FORMAT_WVE:           00190000h      ;Psion WVE format
    SF_FORMAT_OGG:           00200000h      ;Xiph OGG container
    SF_FORMAT_MPC2K:         00210000h      ;Akai MPC 2000 sampler
    SF_FORMAT_RF64:          00220000h      ;RF64 WAV file

    ; Subtypes from here on.

    SF_FORMAT_PCM_S8:        00000001h      ;Signed 8 bit data
    SF_FORMAT_PCM_16:        00000002h      ;Signed 16 bit data
    SF_FORMAT_PCM_24:        00000003h      ;Signed 24 bit data
    SF_FORMAT_PCM_32:        00000004h      ;Signed 32 bit data

    SF_FORMAT_PCM_U8:        00000005h      ;Unsigned 8 bit data (WAV and RAW only)

    SF_FORMAT_FLOAT:         00000006h      ;32 bit float data
    SF_FORMAT_DOUBLE:        00000007h      ;64 bit float data

    SF_FORMAT_ULAW:          00000010h      ;U-Law encoded.
    SF_FORMAT_ALAW:          00000011h      ;A-Law encoded.
    SF_FORMAT_IMA_ADPCM:     00000012h      ;IMA ADPCM.
    SF_FORMAT_MS_ADPCM:      00000013h      ;Microsoft ADPCM.

    SF_FORMAT_GSM610:        00000020h      ;GSM 6.10 encoding.
    SF_FORMAT_VOX_ADPCM:     00000021h      ;OKI / Dialogix ADPCM

    SF_FORMAT_G721_32:       00000030h      ;32kbs G721 ADPCM encoding.
    SF_FORMAT_G723_24:       00000031h      ;24kbs G723 ADPCM encoding.
    SF_FORMAT_G723_40:       00000032h      ;40kbs G723 ADPCM encoding.

    SF_FORMAT_DWVW_12:       00000040h      ;12 bit Delta Width Variable Word encoding.
    SF_FORMAT_DWVW_16:       00000041h      ;16 bit Delta Width Variable Word encoding.
    SF_FORMAT_DWVW_24:       00000042h      ;24 bit Delta Width Variable Word encoding.
    SF_FORMAT_DWVW_N:        00000043h      ;N bit Delta Width Variable Word encoding.

    SF_FORMAT_DPCM_8:        00000050h      ;8 bit differential PCM (XI only)
    SF_FORMAT_DPCM_16:       00000051h      ;16 bit differential PCM (XI only)

    SF_FORMAT_VORBIS:        00000060h      ;Xiph Vorbis encoding.

    SF_FORMAT_ALAC_16:       00000070h      ;Apple Lossless Audio Codec (16 bit).
    SF_FORMAT_ALAC_20:       00000071h      ;Apple Lossless Audio Codec (20 bit).
    SF_FORMAT_ALAC_24:       00000072h      ;Apple Lossless Audio Codec (24 bit).
    SF_FORMAT_ALAC_32:       00000073h      ;Apple Lossless Audio Codec (32 bit).

    ; Endian-ness options.

    SF_ENDIAN_FILE:          00000000h   ; Default file endian-ness.
    SF_ENDIAN_LITTLE:        10000000h   ; Force little endian-ness.
    SF_ENDIAN_BIG:           20000000h   ; Force big endian-ness.
    SF_ENDIAN_CPU:           30000000h   ; Force CPU endian-ness.

    SF_FORMAT_SUBMASK:       0000FFFFh
    SF_FORMAT_TYPEMASK:      0FFF0000h
    SF_FORMAT_ENDMASK:       30000000h
]


; The following are the valid command numbers for the `sf_command`
; interface.  The use of these commands is documented in the file
; command.html in the doc directory of the source code distribution.
*/

#enum sf-command! [
    SFC_GET_LIB_VERSION:             1000h
    SFC_GET_LOG_INFO:                1001h
    SFC_GET_CURRENT_SF_INFO:         1002h


    SFC_GET_NORM_DOUBLE:             1010h
    SFC_GET_NORM_FLOAT:              1011h
    SFC_SET_NORM_DOUBLE:             1012h
    SFC_SET_NORM_FLOAT:              1013h
    SFC_SET_SCALE_FLOAT_INT_READ:    1014h
    SFC_SET_SCALE_INT_FLOAT_WRITE:   1015h

    SFC_GET_SIMPLE_FORMAT_COUNT:     1020h
    SFC_GET_SIMPLE_FORMAT:           1021h

    SFC_GET_FORMAT_INFO:             1028h

    SFC_GET_FORMAT_MAJOR_COUNT:      1030h
    SFC_GET_FORMAT_MAJOR:            1031h
    SFC_GET_FORMAT_SUBTYPE_COUNT:    1032h
    SFC_GET_FORMAT_SUBTYPE:          1033h

    SFC_CALC_SIGNAL_MAX:             1040h
    SFC_CALC_NORM_SIGNAL_MAX:        1041h
    SFC_CALC_MAX_ALL_CHANNELS:       1042h
    SFC_CALC_NORM_MAX_ALL_CHANNELS:  1043h
    SFC_GET_SIGNAL_MAX:              1044h
    SFC_GET_MAX_ALL_CHANNELS:        1045h

    SFC_SET_ADD_PEAK_CHUNK:          1050h
    SFC_SET_ADD_HEADER_PAD_CHUNK:    1051h

    SFC_UPDATE_HEADER_NOW:           1060h
    SFC_SET_UPDATE_HEADER_AUTO:      1061h

    SFC_FILE_TRUNCATE:               1080h

    SFC_SET_RAW_START_OFFSET:        1090h

    SFC_SET_DITHER_ON_WRITE:         10A0h
    SFC_SET_DITHER_ON_READ:          10A1h

    SFC_GET_DITHER_INFO_COUNT:       10A2h
    SFC_GET_DITHER_INFO:             10A3h

    SFC_GET_EMBED_FILE_INFO:         10B0h

    SFC_SET_CLIPPING:                10C0h
    SFC_GET_CLIPPING:                10C1h

    SFC_GET_CUE_COUNT:               10CDh
    SFC_GET_CUE:                     10CEh
    SFC_SET_CUE:                     10CFh

    SFC_SET_INSTRUMENT:              10D1h
    SFC_GET_INSTRUMENT:              10D0h

    SFC_GET_LOOP_INFO:               10E0h

    SFC_GET_BROADCAST_INFO:          10F0h
    SFC_SET_BROADCAST_INFO:          10F1h

    SFC_GET_CHANNEL_MAP_INFO:        1100h
    SFC_SET_CHANNEL_MAP_INFO:        1101h

    SFC_RAW_DATA_NEEDS_ENDSWAP:      1110h

    ;Support for Wavex Ambisonics Format
    SFC_WAVEX_SET_AMBISONIC:         1200h
    SFC_WAVEX_GET_AMBISONIC:         1201h

    ;RF64 files can be set so that on-close, writable files that have less
    ;than 4GB of data in them are converted to RIFF/WAV, as per EBU
    ;recommendations.

    SFC_RF64_AUTO_DOWNGRADE:         1210h

    SFC_SET_VBR_ENCODING_QUALITY:    1300h
    SFC_SET_COMPRESSION_LEVEL:       1301h

    ; Cart Chunk support
    SFC_SET_CART_INFO:               1400h
    SFC_GET_CART_INFO:               1401h

    ; Following commands for testing only.
    SFC_TEST_IEEE_FLOAT_REPLACE:     6001h

    ;SFC_SET_ADD_* values are deprecated and will disappear at some
    ;time in the future. They are guaranteed to be here up to and
    ;including version 1.0.8 to avoid breakage of existing software.
    ;They currently do nothing and will continue to do nothing.
    
    SFC_SET_ADD_DITHER_ON_WRITE:     1070h
    SFC_SET_ADD_DITHER_ON_READ:      1071h
]


;String types that can be set and read from files. Not all file types
;support this and even the file types which support one, may not support
;all string types.

#enum sf-string! [
    SF_STR_TITLE:                    01h
    SF_STR_COPYRIGHT:                02h
    SF_STR_SOFTWARE:                 03h
    SF_STR_ARTIST:                   04h
    SF_STR_COMMENT:                  05h
    SF_STR_DATE:                     06h
    SF_STR_ALBUM:                    07h
    SF_STR_LICENSE:                  08h
    SF_STR_TRACKNUMBER:              09h
    SF_STR_GENRE:                    10h
]

;Use the following as the start and end index when doing metadata
;transcoding.

#define SF_STR_FIRST    SF_STR_TITLE
#define SF_STR_LAST     SF_STR_GENRE
 
; True and false */
#define  SF_FALSE    0
#define  SF_TRUE     1

; Modes for opening files. */
#define  SFM_READ    10h
#define  SFM_WRITE   20h
#define  SFM_RDWR    30h

#define  SF_AMBISONIC_NONE     40h
#define  SF_AMBISONIC_B_FORMAT 41h

;Public error values. These are guaranteed to remain unchanged for the duration
;of the library major version number.
;There are also a large number of private error numbers which are internal to
;the library which can change at any time.

#enum sf-error! [
    SF_ERR_NO_ERROR:             0
    SF_ERR_UNRECOGNISED_FORMAT:  1
    SF_ERR_SYSTEM:               2
    SF_ERR_MALFORMED_FILE:       3
    SF_ERR_UNSUPPORTED_ENCODING: 4
]

; Channel map values (used with SFC_SET/GET_CHANNEL_MAP).

#enum sf-channel! [
    SF_CHANNEL_MAP_INVALID: 0
    SF_CHANNEL_MAP_MONO:    1
    SF_CHANNEL_MAP_LEFT                    ;Apple calls this 'Left'
    SF_CHANNEL_MAP_RIGHT                   ;Apple calls this 'Right'
    SF_CHANNEL_MAP_CENTER                  ;Apple calls this 'Center'
    SF_CHANNEL_MAP_FRONT_LEFT
    SF_CHANNEL_MAP_FRONT_RIGHT
    SF_CHANNEL_MAP_FRONT_CENTER
    SF_CHANNEL_MAP_REAR_CENTER             ;Apple calls this 'Center Surround', Msft calls this 'Back Center'
    SF_CHANNEL_MAP_REAR_LEFT               ;Apple calls this 'Left Surround', Msft calls this 'Back Left'
    SF_CHANNEL_MAP_REAR_RIGHT              ;Apple calls this 'Right Surround', Msft calls this 'Back Right'
    SF_CHANNEL_MAP_LFE                     ;Apple calls this 'LFEScreen', Msft calls this 'Low Frequency' 
    SF_CHANNEL_MAP_FRONT_LEFT_OF_CENTER    ;Apple calls this 'Left Center'
    SF_CHANNEL_MAP_FRONT_RIGHT_OF_CENTER   ;Apple calls this 'Right Center
    SF_CHANNEL_MAP_SIDE_LEFT               ;Apple calls this 'Left Surround Direct'
    SF_CHANNEL_MAP_SIDE_RIGHT              ;Apple calls this 'Right Surround Direct'
    SF_CHANNEL_MAP_TOP_CENTER              ;Apple calls this 'Top Center Surround'
    SF_CHANNEL_MAP_TOP_FRONT_LEFT          ;Apple calls this 'Vertical Height Left'
    SF_CHANNEL_MAP_TOP_FRONT_RIGHT         ;Apple calls this 'Vertical Height Right'
    SF_CHANNEL_MAP_TOP_FRONT_CENTER        ;Apple calls this 'Vertical Height Center'
    SF_CHANNEL_MAP_TOP_REAR_LEFT           ;Apple and MS call this 'Top Back Left'
    SF_CHANNEL_MAP_TOP_REAR_RIGHT          ;Apple and MS call this 'Top Back Right'
    SF_CHANNEL_MAP_TOP_REAR_CENTER         ;Apple and MS call this 'Top Back Center'

    SF_CHANNEL_MAP_AMBISONIC_B_W
    SF_CHANNEL_MAP_AMBISONIC_B_X
    SF_CHANNEL_MAP_AMBISONIC_B_Y
    SF_CHANNEL_MAP_AMBISONIC_B_Z

    SF_CHANNEL_MAP_MAX
]

#define sndfile! integer!

sf_count_t!: alias struct! [lo [integer!] hi [integer!]] ;@@ TODO change once we have int64 in Red

; A pointer to a SF_INFO structure is passed to `sf_open` and filled in.
; On write, the SF_INFO structure is filled in by the user and passed into `sf_open`.

sf-info!: alias struct! [
    frames      [sf_count_t! value]
    samplerate  [integer!]
    channels    [integer!]
    format      [integer!]
    sections    [integer!]
    seekable    [integer!]
]

; The sf-format-info! struct is used to retrieve information about the sound
; file formats libsndfile supports using the `sf_command` interface.
;
; Using this interface will allow applications to support new file formats
; and encoding types when libsndfile is upgraded, without requiring
; re-compilation of the application.
;
; Please consult the libsndfile documentation (particularly the information
; on the `sf_command` interface) for examples of its use.

sf-format-info!: alias struct! [
    format      [integer!]
    name        [c-string!]
    extension   [c-string!]
]

; definitions for adding dither on read and write.

#define SFD_DEFAULT_LEVEL   0
#define SFD_CUSTOM_LEVEL    40000000h

#define SFD_NO_DITHER       500
#define SFD_WHITE           501
#define SFD_TRIANGULAR_PDF  502

sf-dither-info!: alias struct! [
    type    [integer!]
    level   [float!]
    name    [c-string!]
]

; Struct used to retrieve information about a file embedded within a
; larger file. See SFC_GET_EMBED_FILE_INFO.

sf-embed-file-info!: alias struct! [
    offset [sf_count_t! value]
    length [sf_count_t! value]
]


#import [
	SNDFILE_LIBRARY cdecl [
        sf_version_string: "sf_version_string" [
            ;Return the library version string
            return: [c-string!]
        ]

        sf_open: "sf_open" [
            ; Open the specified file for read, write or both. On error, this will
            ; return a NULL pointer. To find the error number, pass a NULL SNDFILE
            ; to `sf_strerror`.
            ; All calls to `sf_open` should be matched with a call to `sf_close`.
            path    [c-string!]
            mode    [integer!]
            sfinfo  [sf-info!]
            return: [sndfile!]
        ]

        sf_open_fd: "sf_open_fd" [
            fd      [integer!]
            mode    [integer!]
            sfinfo  [sf-info!]
            close_desc [integer!]
            return: [sndfile!]
        ]

        sf_open_virtual: "sf_open_virtual" [
            sfvirtual  []
        ]
SNDFILE*    sf_open_virtual (SF_VIRTUAL_IO *sfvirtual, int mode, SF_INFO *sfinfo, void *user_data) ;
    ]
]


print-line ["sf_version_string: " sf_version_string]