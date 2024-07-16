REBOL [
    Title: "Soundex"
    Date: 16-Jul-2024
    File: %soundex.r
    Author: "Allen Kamp, Oldes"
    Purpose: {Soundex Encoding returns similar codes for similar sounding words or names. eg Stephens, Stevens are both S315, Smith and Smythe are both S53. Useful for adding Sounds-like searching to databases}
    Comment: {
        This is the basic Soundex algorithm (There are a number of different
        one floating around)

        1. Remove vowels, H, W and Y
        2. Encode each char with its code value
        3. Remove adjacent duplicate numbers

        4. Return First letter, followed by the next 3 letter's code
           numbers, if they exist.

        TODO: Other algorithms: Extended Soundex, Metaphone and the LC Cutter table
    }
    Language: "English"
    Email: %allenk--powerup--com--au
    library: [
        level: 'intermediate 
        platform: 'all 
        type: 'tool 
        domain: [DB text text-processing] 
        tested-under: none 
        support: none 
        license: none 
        see-also: none
    ]
    Version: 1.1.0
    Type: module
    Exports: [soundex]
    Needs: 3.0.0
    History: [
    	17-Jul-1999 @Allen "Initial version"
    	16-Jul-2024 @Oldes "Ported to Rebol3"

    ]
]

soundex: function/with [
    {Returns the Census Soundex Code for the given string}
    string [any-string!] "String to Encode"
][

    code: make string! ""

    either all [string? string string <> ""] [
        string: uppercase trim copy string

        foreach letter string [
            parse to string! letter [soundex-match | soundex-no-match]
            if 4 = length? code [break] ;maximum length for code is 4
        ]
    ] [
        return string ; return unchanged
    ]
    change code first string ; replace first number with first letter
    return code
][
	code: val: none
    ; Create Rules
    set1: [[#"B" | #"F" | #"P" | #"V"](val: #"1")]
    set2: [[#"C" | #"G" | #"J" | #"K" | #"Q" | #"S" | #"X" | #"Z"](val: #"2")]
    set3: [[#"D" | #"T"](val: #"3")]
    set4: [[#"L"](val: "4")]
    set5: [[#"M" | #"N"] (val: #"5")]
    set6: [[#"R"](val: #"6")]
    ; Append val to code if not a duplicate of previous code val
    soundex-match: [[set1 | set2 | set3 | set4 | set5 | set6 ] 
        (if val <> back tail code [append code val]) ]

    ; If letter not a matched letter its val is 0, but we only care
    ; about it if it is the first letter.
    soundex-no-match: [(if (length? code) = 0 [append code "0"])]
]