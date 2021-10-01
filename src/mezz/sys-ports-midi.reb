REBOL [
	System: "REBOL [R3] Language Interpreter and Run-time Environment"
	Title: "REBOL 3 Boot Sys: Port and Scheme Functions"
	Rights: {
		Copyright 2012 REBOL Technologies
		REBOL is a trademark of REBOL Technologies
	}
	License: {
		Licensed under the Apache License, Version 2.0
		See: http://www.apache.org/licenses/LICENSE-2.0
	}
	Context: sys
	Note: {
		The boot binding of this module is SYS then LIB deep.
		Any non-local words not found in those contexts WILL BE
		UNBOUND and will error out at runtime!
	}
]

append/only system/schemes [
	title: "MIDI"
	name: 'midi
	spec: system/standard/port-spec-midi
	init: func [port /local spec inp out] [
		spec: port/spec
		if url? spec/ref [
			parse spec/ref [
				thru #":" 0 2 slash
				opt "device:"
				copy inp *parse-url/digits
				opt [#"/" copy out *parse-url/digits]
				end
			]
			if inp [ spec/device-in:  to integer! inp]
			if out [ spec/device-out: to integer! out]
		]
		; make port/spec to be only with midi related keys
		set port/spec: make copy system/standard/port-spec-midi spec
		;protect/words port/spec ; protect spec object keys of modification
		true
	]
]
