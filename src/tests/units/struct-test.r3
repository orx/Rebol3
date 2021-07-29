Rebol [
	Title:   "Rebol struct test script"
	Author:  "Oldes"
	File: 	 %struct-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "STRUCT"

===start-group=== "Struct single value construction"
	--assert not error? try [
		i8:  make struct! [a [int8!]]
		i16: make struct! [a [int16!]]
		i32: make struct! [a [int32!]]
		i64: make struct! [a [int64!]]
		u8:  make struct! [a [uint8!]]
		u16: make struct! [a [uint16!]]
		u32: make struct! [a [uint32!]]
		u64: make struct! [a [uint64!]]
		f32: make struct! [a [float!]]
		f64: make struct! [a [double!]]
		w:   make struct! [a [word!]]
	]
	--assert 1 = length? i8
	--assert 2 = length? i16
	--assert 4 = length? i32
	--assert 8 = length? i64
	--assert 1 = length? u8
	--assert 2 = length? u16
	--assert 4 = length? u32
	--assert 8 = length? u64
	--assert 4 = length? f32
	--assert 8 = length? f64
	--assert 4 = length? w
	--assert (mold i8 ) = "make struct! [a: [int8!] 0]"
	--assert (mold i16) = "make struct! [a: [int16!] 0]"
	--assert (mold i32) = "make struct! [a: [int32!] 0]"
	--assert (mold i64) = "make struct! [a: [int64!] 0]"
	--assert (mold u8 ) = "make struct! [a: [uint8!] 0]"
	--assert (mold u16) = "make struct! [a: [uint16!] 0]"
	--assert (mold u32) = "make struct! [a: [uint32!] 0]"
	--assert (mold u64) = "make struct! [a: [uint64!] 0]"
	--assert (mold f32) = "make struct! [a: [float!] 0.0]"
	--assert (mold f64) = "make struct! [a: [double!] 0.0]"
	--assert (mold w)   = "make struct! [a: [word!] none]"
===end-group===


===start-group=== "Struct single value (dimensional) construction"
	--assert not error? try [
		i8x2:  make struct! [a [int8!   [2]]]
		i16x2: make struct! [a [int16!  [2]]]
		i32x2: make struct! [a [int32!  [2]]]
		i64x2: make struct! [a [int64!  [2]]]
		u8x2:  make struct! [a [uint8!  [2]]]
		u16x2: make struct! [a [uint16! [2]]]
		u32x2: make struct! [a [uint32! [2]]]
		u64x2: make struct! [a [uint64! [2]]]
		f32x2: make struct! [a [float!  [2]]]
		f64x2: make struct! [a [double! [2]]]
		wx2:   make struct! [a [word!   [2]]]
	]
	--assert [a [int8!   [2]]] = spec-of i8x2
	--assert [a [int16!  [2]]] = spec-of i16x2
	--assert [a [int32!  [2]]] = spec-of i32x2
	--assert [a [int64!  [2]]] = spec-of i64x2
	--assert [a [uint8!  [2]]] = spec-of u8x2
	--assert [a [uint16! [2]]] = spec-of u16x2
	--assert [a [uint32! [2]]] = spec-of u32x2
	--assert [a [uint64! [2]]] = spec-of u64x2
	--assert [a [float!  [2]]] = spec-of f32x2
	--assert [a [double! [2]]] = spec-of f64x2
	--assert [a [word!   [2]]] = spec-of wx2

	--assert 2  = length? i8x2
	--assert 4  = length? i16x2
	--assert 8  = length? i32x2
	--assert 16 = length? i64x2
	--assert 2  = length? u8x2
	--assert 4  = length? u16x2
	--assert 8  = length? u32x2
	--assert 16 = length? u64x2
	--assert 8  = length? f32x2
	--assert 16 = length? f64x2
	--assert 8  = length? wx2
	--assert (mold i8x2 ) = "make struct! [a: [int8! [2]] [0 0]]"
	--assert (mold i16x2) = "make struct! [a: [int16! [2]] [0 0]]"
	--assert (mold i32x2) = "make struct! [a: [int32! [2]] [0 0]]"
	--assert (mold i64x2) = "make struct! [a: [int64! [2]] [0 0]]"
	--assert (mold u8x2 ) = "make struct! [a: [uint8! [2]] [0 0]]"
	--assert (mold u16x2) = "make struct! [a: [uint16! [2]] [0 0]]"
	--assert (mold u32x2) = "make struct! [a: [uint32! [2]] [0 0]]"
	--assert (mold u64x2) = "make struct! [a: [uint64! [2]] [0 0]]"
	--assert (mold f32x2) = "make struct! [a: [float! [2]] [0.0 0.0]]"
	--assert (mold f64x2) = "make struct! [a: [double! [2]] [0.0 0.0]]"
	--assert (mold wx2)   = "make struct! [a: [word! [2]] [none none]]"
===end-group===

===start-group=== "Invalid struct construction"
--test-- "Missing struct init value"
;@@ https://github.com/zsx/r3/issues/50
	--assert all [
		error? e: try [make struct! [ c: [struct! [a [uint8!]]] ]]
		e/id = 'expect-val
	]
--test-- "Don't allow evaluation inside struct construction"
;@@ https://github.com/zsx/r3/issues/51
	--assert all [
		error? e: try [make struct! [ a: [uint8!] probe random 100 ]]
		e/id = 'invalid-type
	]
===end-group===



~~~end-file~~~