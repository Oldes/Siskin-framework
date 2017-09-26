Red/System [
	Title:   "Red/System C library binding - math"
	Author:  "Oldes"
	File:    %math.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
	Note:    "Red and Red/System runtime already define most of these functions!"
]

#define M_E         2.7182818284590452354   ; e 
#define M_LOG2E     1.4426950408889634074   ; log 2e 
#define M_LOG10E    0.43429448190325182765  ; log 10e 
#define M_LN2       0.69314718055994530942  ; log e2 
#define M_LN10      2.30258509299404568402  ; log e10 
#define M_PI        3.14159265358979323846  ; pi 
#define M_PI_2      1.57079632679489661923  ; pi/2 
#define M_PI_4      0.78539816339744830962  ; pi/4 
#define M_1_PI      0.31830988618379067154  ; 1/pi 
#define M_2_PI      0.63661977236758134308  ; 2/pi 
#define M_2_SQRTPI  1.12837916709551257390  ; 2/sqrt(pi) 
#define M_SQRT2     1.41421356237309504880  ; sqrt(2) 
#define M_SQRT1_2   0.70710678118654752440  ; 1/sqrt(2) 
#define MAXFLOAT    [as float32! 3.40282346638528860e+38]

#import [
	LIBM-file cdecl [
		acos:   "acos" [
			;Returns the arc cosine of x in radians.
			x        [float!] ;This is the floating point value in the interval [-1,+1].
			return:  [float!] ;The principal arc cosine of x, in the interval [0, pi] radians.
		]
		acos:   "acos" [
			;Returns the arc cosine of x in radians.
			x        [float!] ;This is the floating point value in the interval [-1,+1].
			return:  [float!] ;The principal arc cosine of x, in the interval [0, pi] radians.
		]
		asin:   "asin" [
			;Returns the arc sine of x in radians.
			x        [float!] ;This is the floating point value in the interval [-1,+1].
			return:  [float!] ;The arc sine of x, in the interval [-pi/2,+pi/2] radians.
		]
		atan:   "atan" [
			;Returns the arc tangent of x in radians.
			x        [float!]
			return:  [float!] ;The principal arc tangent of x, in the interval [-pi/2,+pi/2] radians.
		]
		atan2:  "atan2" [
			;Returns the arc tangent in radians of y/x based on the signs of both values to determine the correct quadrant.
			y        [float!] ;This is the floating point value representing a y-coordinate.
			x        [float!] ;This is the floating point value representing an x-coordinate.
			return:  [float!] ;The principal arc tangent of y/x, in the interval [-pi,+pi] radians.
		]
		cos:    "cos" [
			;Returns the cosine of a radian angle x.
			x        [float!] ;This is the floating point value representing an angle expressed in radians.
			return:  [float!]
		]
		cosh:   "cosh" [
			;Returns the hyperbolic cosine of x.
			x        [float!]
			return:  [float!]
		]
		sin:    "sin" [
			;Returns the sine of a radian angle x.
			x        [float!] ;This is the floating point value representing an angle expressed in radians.
			return:  [float!]
		]
		sinh:   "sinh" [
			;Returns the hyperbolic sine of x.
			x        [float!]
			return:  [float!]
		]
		tan:    "tan" [
			;Returns the tangent of x.
			x        [float!]
			return:  [float!]
		]
		tanh:   "tanh" [
			;Returns the hyperbolic tangent of x.
			x        [float!]
			return:  [float!]
		]
		exp:    "exp" [
			;Returns the value of e raised to the xth power.
			x        [float!]
			return:  [float!]
		]
		frexp:  "frexp" [
			;The returned value is the mantissa and the integer pointed to by exponent is the exponent.
			;The resultant value is x = mantissa * 2 ^ exponent.
			x        [float!]
			exponent [int-ptr!]
			return:  [float!]
		]
		ldexp:  "ldexp" [
			;Returns x multiplied by 2 raised to the power of exponent.
			value    [float!]
			exponent [integer!]
			return:  [float!]
		]
		log:    "log" [
			;Returns the natural logarithm (base-e logarithm)
			value    [float!]
			return:  [float!]
		]
		log-10: "log10" [
			;Returns the common logarithm (base-10 logarithm)
			value    [float!]
			return:  [float!]
		]
		modf:   "modf" [
			;The returned value is the fraction component (part after the decimal), and sets integer to the integer component.
			value    [float!]
			integer  [int-ptr!]
			return:  [float!]
		]
		pow:    "pow" [
			;Returns x raised to the power of y.
			x        [float!]
			y        [float!]
			return:  [float!]
		]
		sqrt:   "sqrt" [
			;Returns the square root of x.
			x        [float!]
			return:  [float!]
		]
		ceil:   "ceil" [
			;Returns the smallest integer value greater than or equal to x.
			x        [float!]
			return:  [float!]
		]
		fabs:   "fabs" [
			;Returns the absolute value of x.
			x        [float!]
			return:  [float!]
		]
		floor:  "floor" [
			;Returns the largest integer value less than or equal to x.
			x        [float!]
			return:  [float!]
		]
		fmod:   "fmod" [
			;Returns the remainder of x divided by y.
			x        [float!]
			y        [float!]
			return:  [float!]
		]
		;- float32! versions:
		acosf:  "acosf" [
			;Returns the arc cosine of x in radians.
			x        [float32!] ;This is the floating point value in the interval [-1,+1].
			return:  [float32!] ;The principal arc cosine of x, in the interval [0, pi] radians.
		]
		acosf:  "acosf" [
			;Returns the arc cosine of x in radians.
			x        [float32!] ;This is the floating point value in the interval [-1,+1].
			return:  [float32!] ;The principal arc cosine of x, in the interval [0, pi] radians.
		]
		asinf:  "asinf" [
			;Returns the arc sine of x in radians.
			x        [float32!] ;This is the floating point value in the interval [-1,+1].
			return:  [float32!] ;The arc sine of x, in the interval [-pi/2,+pi/2] radians.
		]
		atanf:  "atanf" [
			;Returns the arc tangent of x in radians.
			x        [float32!]
			return:  [float32!] ;The principal arc tangent of x, in the interval [-pi/2,+pi/2] radians.
		]
		atan2f: "atan2f" [
			;Returns the arc tangent in radians of y/x based on the signs of both values to determine the correct quadrant.
			y        [float32!] ;This is the floating point value representing a y-coordinate.
			x        [float32!] ;This is the floating point value representing an x-coordinate.
			return:  [float32!] ;The principal arc tangent of y/x, in the interval [-pi,+pi] radians.
		]
		cosf:   "cosf" [
			;Returns the cosine of a radian angle x.
			x        [float32!] ;This is the floating point value representing an angle expressed in radians.
			return:  [float32!]
		]
		coshf:  "coshf" [
			;Returns the hyperbolic cosine of x.
			x        [float32!]
			return:  [float32!]
		]
		sinf:   "sinf" [
			;Returns the sine of a radian angle x.
			x        [float32!] ;This is the floating point value representing an angle expressed in radians.
			return:  [float32!]
		]
		sinhf:  "sinhf" [
			;Returns the hyperbolic sine of x.
			x        [float32!]
			return:  [float32!]
		]
		tanf:   "tanf" [
			;Returns the tangent of x.
			x        [float32!]
			return:  [float32!]
		]
		tanhf:  "tanhf" [
			;Returns the hyperbolic tangent of x.
			x        [float32!]
			return:  [float32!]
		]
		expf:   "expf" [
			;Returns the value of e raised to the xth power.
			x        [float32!]
			return:  [float32!]
		]
		logf:   "logf" [
			;Returns the natural logarithm (base-e logarithm)
			value    [float32!]
			return:  [float32!]
		]
		log10f: "log10f" [
			;Returns the common logarithm (base-10 logarithm)
			value    [float32!]
			return:  [float32!]
		]
		modff:  "modff" [
			;The returned value is the fraction component (part after the decimal), and sets integer to the integer component.
			value    [float32!]
			integer  [int-ptr!]
			return:  [float32!]
		]
		powf:   "powf" [
			;Returns x raised to the power of y.
			x        [float32!]
			y        [float32!]
			return:  [float32!]
		]
		sqrtf:  "sqrtf" [
			;Returns the square root of x.
			x        [float32!]
			return:  [float32!]
		]
		ceilf:  "ceilf" [
			;Returns the smallest integer value greater than or equal to x.
			x        [float32!]
			return:  [float32!]
		]
		floorf: "floorf" [
			;Returns the largest integer value less than or equal to x.
			x        [float32!]
			return:  [float32!]
		]
		fmodf:  "fmodf" [
			;Returns the remainder of x divided by y.
			x        [float32!]
			y        [float32!]
			return:  [float32!]
		]
	]
]

#define log-2 log 