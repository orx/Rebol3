Rebol [
	Title:   "Rebol BinCode (binary) test script"
	Author:  "Oldes"
	File: 	 %bincode-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "BinCode"

is-range-error?: func[code][
	true? all [
		error? err: try code
		err/id = 'out-of-range
	] 
]
is-protected-error?: func[code][
	true? all [
		error? err: try code
		[
			err/id = 'protected
			err/id = 'locked-word
		]
	] 
]

===start-group=== "BinCode initialization"
	--test-- "BinCode-0"
		--assert object? b: binary none ; create bincode with default size
		--assert b/type = 'bincode
		--assert empty? b/buffer
		--assert empty? b/buffer-write
	--test-- "BinCode-1"
		--assert object? b: binary 16 ; pre-allocate buffer for 16 bytes
		--assert b/type = 'bincode
		--assert empty? b/buffer
		--assert empty? b/buffer-write
	--test-- "BinCode-2"
		--assert object? b: binary #{0badCafe} ; init with data already
		--assert not empty? b/buffer
		--assert not empty? b/buffer-write
		--assert 4 = length? b/buffer
		--assert 4 = length? b/buffer-write
		--assert object? binary/init b 1024 ; reinitialize existing bincode
		--assert empty? b/buffer
		--assert empty? b/buffer-write
		--assert object? binary/init b #{0badCafe} ; reinitialize with data
		--assert not empty? b/buffer
		--assert not empty? b/buffer-write
		--assert object? binary/init b none ; just clear existing bincode
		--assert empty? b/buffer
		--assert empty? b/buffer-write

===end-group===

===start-group=== "BinCode basic read/write functions"

	--test-- "BinCode - write positive unsigned integers (big endian)"
		b: binary 64
		--assert object? binary/write b [ui64 1 ui32 1 ui24 1 ui16 1 ui8 1]
		--assert #{000000000000000100000001000001000101} = b/buffer
		binary/init b none
		--assert object? binary/write b [ui64 1  ui32BE 1  ui24BE 1  ui16BE 1 ui8 1]
		--assert #{000000000000000100000001000001000101} = b/buffer
		--assert "11111" = rejoin binary/read b [ui64 ui32 ui24 ui16 ui8]
		--assert "11111" = rejoin binary/read b [at 1 ui64be ui32be ui24be ui16be ui8]
		binary/init b none
		binary/write b [
			#{7FFFFFFFFFFFFFFF}
			#{7FFFFFFF}
			#{7FFFFFFFFFFFFFFF}
			#{7FFFFF}
			#{7FFFFFFFFFFFFFFF}
			#{7FFF}
			#{7FFFFFFFFFFFFFFF}
			#{7F}
		]
		--assert 9223372036854775807 = binary/read b 'UI64
		--assert 2147483647 = binary/read b 'UI32
		--assert 9223372036854775807 = binary/read b 'UI64
		--assert 8388607 = binary/read b 'UI24
		--assert 9223372036854775807 = binary/read b 'UI64
		--assert 32767 = binary/read b 'UI16
		--assert 9223372036854775807 = binary/read b 'UI64
		--assert 127 = binary/read b 'UI8
	--test-- "BinCode - write negative unsigned integers (big endian)"
		binary/write b [UI8 -1 UI16 -1 UI24 -1 UI32 -1 UI64 -1]
		--assert #{FF FFFF FFFFFF FFFFFFFF FFFFFFFFFFFFFFFF} = b/buffer
		--assert "255 65535 16777215 4294967295 -1" = reform binary/read b [ui8 ui16 ui24 ui32 ui64]
	--test-- "BinCode - unsigned integers (little endian)"
		binary/init b none
		--assert object? binary/write b [ui8 1  ui16LE 1  ui24LE 1  ui32LE 1]
		--assert #{01010001000001000000} = b/buffer
		--assert "1111" = rejoin binary/read b [at 1 ui8 ui16LE ui24LE ui32LE]
	--test-- "BinCode - write signed integers over range"
		binary/init b none
		; max values... should be ok
		--assert object? binary/write b [SI8  127]
		--assert object? binary/write b [SI8 -127]
		--assert object? binary/write b [SI16  32767]
		--assert object? binary/write b [SI16 -32767]
		--assert object? binary/write b [SI24  8388607]
		--assert object? binary/write b [SI24 -8388607]
		--assert object? binary/write b [SI32  2147483647]
		--assert object? binary/write b [SI32 -2147483647]
		; over range values.. should be "out of range" error
		--assert is-range-error? [binary/write b [SI8  128]]
		--assert is-range-error? [binary/write b [SI8 -128]]
		--assert is-range-error? [binary/write b [SI16  32768]]
		--assert is-range-error? [binary/write b [SI16 -32768]]
		--assert is-range-error? [binary/write b [SI24  8388608]]
		--assert is-range-error? [binary/write b [SI24 -8388608]]
		--assert is-range-error? [binary/write b [SI32  2147483648]]
		--assert is-range-error? [binary/write b [SI32 -2147483648]]
		; results:
		--assert [127 -127 32767 -32767 8388607 -8388607 2147483647 -2147483647]
		         = binary/read b [SI8 SI8 SI16 SI16 SI24 SI24 SI32 SI32]

	--test-- "BinCode - write unsigned integers over range"
		binary/init b none
		; max values... should be ok
		--assert object? binary/write b [UI8  255]
		--assert object? binary/write b [UI16 65535]
		--assert object? binary/write b [UI24 16777215]
		--assert object? binary/write b [UI32 4294967295]
		; --assert object? binary/write b [UI64 18446744073709551615.0] ;- not yet suported

		; over range values.. should be "out of range" error
		--assert is-range-error? [binary/write b [UI8  256]]
		--assert is-range-error? [binary/write b [UI16 65536]]
		--assert is-range-error? [binary/write b [UI24 16777216]]
		--assert is-range-error? [binary/write b [UI32 4294967296]]
		; results:
		--assert [255 65535 16777215 4294967295] = binary/read b [UI8 UI16 UI24 UI32]

	--test-- "BinCode - SI16LE, SI16BE"
	     --assert 1 = binary/read #{0100} 'SI16LE
	     --assert 1 = binary/read #{0001} 'SI16BE

	b: binary 32
	--test-- "BinCode - BYTES"
	     --assert object? binary/write b [#{cafe}]
	     --assert #{CAFE} = binary/read b 'bytes
	--test-- "BinCode - UI8BYTES"
		--assert object? binary/write b [UI8BYTES #{cafe}]
		--assert #{02CAFE} = binary/read b 'bytes
	--test-- "BinCode - UI16BYTES"
		--assert object? binary/write b [UI16BYTES #{cafe}]
		--assert #{0002CAFE} = binary/read b 'bytes
	--test-- "BinCode - UI24BYTES"
		--assert object? binary/write b [UI24BYTES #{cafe}]
		--assert #{000002CAFE} = binary/read b 'bytes
	--test-- "BinCode - UI32BYTES"
		--assert object? binary/write b [UI32BYTES #{cafe}]
		--assert #{00000002CAFE} = binary/read b 'bytes

	--test-- "BinCode - AT"
		;AT is using absolute positioning
		b: binary 8
		
		binary/write b [AT 4 UI8 4]
		binary/write b [AT 3 UI8 3]
		binary/write b [AT 2 UI8 2]
		binary/write b [AT 1 UI8 1]
		--assert is-range-error? [binary/write b [AT -1 UI8 1]]
		--assert #{01020304} = b/buffer
		i: 0
		binary/read b [AT 1 i: UI8] --assert i = 1
		binary/read b [AT 2 i: UI8] --assert i = 2
		binary/read b [AT 3 i: UI8] --assert i = 3
		binary/read b [AT 4 i: UI8] --assert i = 4
		--assert is-range-error? [binary/read b [AT  5 i: UI8]]
		--assert is-range-error? [binary/read b [AT -1 i: UI8]]

	--test-- "BinCode - SKIP"
		;SKIP is using relative positioning
		b: binary #{01020304}
		i: 0
		binary/read b [skip  1 i: UI8] --assert i = 2
		binary/read b [skip -1 i: UI8] --assert i = 2
		binary/read b [skip  0 i: UI8] --assert i = 3
		binary/read b [skip -2 i: UI8] --assert i = 2
		binary/read b [at 1 skip 3  i: UI8] --assert i = 4
		--assert is-range-error? [binary/read b [AT 1 SKIP  5 UI8]]
		--assert is-range-error? [binary/read b [AT 1 SKIP -1 UI8]]

	--test-- "BinCode - LENGTH?"
		;LENGTH? returns number of bytes remaining in the buffer
		b: binary #{01020304}
		i: 0
		binary/read b [     i: length?] --assert i = 4
		binary/read b [ui16 i: length?] --assert i = 2
		binary/read b [ui16 i: length?] --assert i = 0

	--test-- "BinCode - UNIXTIME-NOW"
		;Writes UNIX time as UI32 value
		b: binary 4
		binary/write b [UNIXTIME-NOW UNIXTIME-NOW-LE]
		--assert 8 = length? b/buffer
		binary/read b [t1: UI32 t2: UI32LE]
		time: now/utc
		--assert time/date   = (1-Jan-1970 + (to integer! t1 / 86400))
		--assert time/hour   = (to-integer t1 // 86400 / 3600)
		--assert time/minute = (to-integer t1 // 86400 // 3600 / 60)
		;lets say that seconds will be ok too:)
		--assert time/date   = (1-Jan-1970 + (to integer! t2 / 86400))
		--assert time/hour   = (to-integer t2 // 86400 / 3600)
		--assert time/minute = (to-integer t2 // 86400 // 3600 / 60)

	--test-- "BinCode - overwrite protected values"
		out: copy #{} ;not yet protected
		blk: copy []
		--assert object? binary/write out #{babe}
		--assert (binary/read out [at 1 i: ui8] i = 186)

		protect :out
		protect :blk
		protect/words [i]
		--assert is-protected-error? [binary/write out #{babe}]
		
		
		--assert is-protected-error? [binary/read out [at 1 i: ui8]]
		--assert is-protected-error? [binary/read/into out [at 1 ui8] blk]
		unprotect/words [blk out i]

	--test-- "BinCode - STRING"
		;@@ this is yet not fully implemented feature! So far only reading.
		b: binary #{74657374002A}
		binary/read b [str: STRING i: UI8]
		--assert str = "test"
		--assert   i = 42

	--test-- "BinCode - bits (SB, UB, FB, ALIGN)"
		b: binary 2#{01011011 10110011 11111111}
		--assert [2 -2 3 -5 255] = binary/read b [SB 3 SB 3 UB 2 SB 4 ALIGN UI8]
		--assert [-2 6] = binary/read 2#{1110 0110} [SB 4 SB 4]
		--assert 14  = binary/read/with 2#{1110 0000} 'UB 4
		--assert [2.5] = binary/read #{500000} [FB 19]

	--test-- "BinCode - bits (variant using sigle value access)"
		bin: binary #{438E9438}
		--assert 1080 = binary/read/with bin 'SB 12
		--assert binary/read bin 'BIT
		--assert binary/read bin 'BIT
		--assert 10 = binary/read/with bin 'UB 4
		--assert not binary/read bin 'BIT
		--assert binary/read bin 'BIT
		--assert 1080 = binary/read/with bin 'SB 12
		--assert 2.5  = binary/read/with #{500000} 'FB 19

		bin: binary #{438E9438}
		binary/read bin [a: SB 12 BIT BIT b: UB 4 BIT BIT c: SB 12]
		--assert all [a = 1080 b = 10 c = 1080]

	--test-- "BinCode - bits with zero skip"
		; shuld not throw range error when bits number is 0
		--assert [0 0 0] = binary/read #{00} [UI8 SB 0 UB 0]

	--test-- "BinCode - EncodedU32"
		b: binary/init none 16
		binary/write b [
			EncodedU32 0
			EncodedU32 1
			EncodedU32 128
			EncodedU32 129
			EncodedU32 130
			EncodedU32 2214768806
		]
		--assert b/buffer = #{0001800181018201A6E18AA008}
		--assert [0 1 128 129 130 2214768806] = binary/read b [
			EncodedU32 EncodedU32 EncodedU32 EncodedU32 EncodedU32 EncodedU32]

	--test-- "BinCode - BITSET8, BITSET16, BITSET32 (read)"
		binary/read #{81800180000001} [
			f8:  BITSET8
			f16: BITSET16
			f32: BITSET32
		]
		--assert all [
			all [f8/0 f8/7]
			not any [f8/1 f8/2 f8/3 f8/4 f8/5 f8/6]
		]
		--assert all [
			all [f16/0 f16/15]
			not any [f16/1 f16/2 f16/3 f16/4 f16/5 f16/6 f16/7]
		]
		--assert all [
			all [f32/0 f32/31]
			not any [f32/1 f32/2 f32/3 f32/4 f32/5 f32/6 f32/7 f32/15]
		]

	--test-- "BinCode - FIXED8 and FIXED16 (read)"
		binary/read #{800700800700} [
			f8:  FIXED8
			f16: FIXED16
		]
		--assert 7.5 = f8
		--assert 7.5 = f16

	--test-- "BinCode - TUPLE3 and TUPLE4 (read)"
		binary/read #{01020304050607} [
			rgb:  TUPLE3
			rgba: TUPLE4
		]
		--assert 1.2.3   = rgb
		--assert 4.5.6.7 = rgba

	--test-- "BinCode - SKIPBITS"
		--assert [2 3] = binary/read 2#{00000000 11000011} [
			SKIPBITS 9 UB 2
			SKIPBITS 3 UB 2
		]

	--test-- "BinCode - ALIGN"
		--assert [0 1 2] = binary/read #{008002} [
			UB 8 ALIGN ; align on byte boundary is noop
			UB 1 ALIGN ; this align should move input pointer
			UI8 ; and this read should return value 2
		]

	--test-- "BinCode - FLOAT16, FLOAT, DOUBLE (read)"
		--assert 1.0 = binary/read #{003C} 'FLOAT16
		--assert 1.0 = binary/read #{0000803F} 'FLOAT
		--assert 1.0 = binary/read #{000000000000F03F} 'DOUBLE

	--test-- "BinCode - MSDOS-DATETIME"
		;- old and not much precise format for storing date and time from MS-DOS times
		;- still used in some file formats, like ZIP

		--assert  4-Apr-2018/18:53:56  = binary/read #{BC96844C} 'msdos-datetime
		--assert [18:53:56 4-Apr-2018] = binary/read #{BC96844C} [msdos-time msdos-date]

		b: binary 64
		binary/write b [
			msdos-time 11:32:20
			msdos-time 21:23:55 ;<- will be stored as 21:23:54 (2sec resolution only)
			msdos-time 14-Mar-2019/15:29:52 ;<- only time is used
			msdos-time 14-Mar-2019 ;<- zero time is used

			msdos-date     14-Mar-2019/15:29:52 ;<- only date is used
			msdos-datetime 14-Mar-2019/15:29:52
			msdos-datetime 14-Mar-2019/15:33:18+1:00
		]
		--assert 11:32:20 = binary/read b 'msdos-time
		--assert 21:23:54 = binary/read b 'msdos-time
		--assert 15:29:52 = binary/read b 'msdos-time
		--assert 0:0:0    = binary/read b 'msdos-time
		--assert 14-Mar-2019 = binary/read b 'msdos-date
		--assert 14-Mar-2019/15:29:52 = binary/read b 'msdos-datetime
		--assert 14-Mar-2019/14:33:18 = binary/read b 'msdos-datetime

		--assert error? try [binary/write b [msdos-date 15:33:18]] ;<- date required

	--test-- "BinCode - STRING-BYTES (read)"
		;- used for fixed size strings (used for example in TAR files)
		--assert ["test" 1]= binary/read #{746573740000000001} [STRING-BYTES 8 UI8]

	--test-- "BinCode - OCTAL-BYTES (read)"
		;- used for fixed size octal numbers (used for example in TAR files)
		--assert 8 = binary/read/with #{3130} 'OCTAL-BYTES 2

===end-group===



~~~end-file~~~