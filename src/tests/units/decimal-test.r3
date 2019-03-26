Rebol [
	Title:   "Rebol3 decimal test script"
	Author:  "Oldes, Peter W A Wood"
	File: 	 %decimal-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]


~~~start-file~~~ "decimal"

===start-group=== "round"
	--test-- "round"
	--assert  1.0 = round  1.4999
	--assert  2.0 = round  1.5
	--assert -2.0 = round -1.5

	--test-- "round/to (decimal)"
	--assert 1.375 = round/to 1.333 .125
	--assert 1.33  = round/to 1.333 .01

	--test-- "round/to (integer)"
	--assert     1 = round/to 0.5   1
	--assert     0 = round/to 0.499 1
	--assert integer? round/to 0.5  1

	--test-- "round/to (money)"
	--assert   $1 = round/to 0.5   $1
	--assert   $0 = round/to 0.499 $1
	--assert money? round/to 0.5   $1

	--test-- "round/down"
	--assert  1.0 = round/down  1.999
	--assert -1.0 = round/down -1.999

	--test-- "round/even"
	--assert  2.0 = round/even  1.5
	--assert -2.0 = round/even -1.5

	--test-- "round/half-down"
	--assert  1.0 = round/half-down  1.5
	--assert -1.0 = round/half-down -1.5

	--test-- "round/floor"
	--assert  1.0 = round/floor  1.999
	--assert -2.0 = round/floor -1.0000001

	--test-- "round/ceiling"
	--assert  2.0 = round/ceiling  1.0000001
	--assert -1.0 = round/ceiling -1.999

	--test-- "round/half-ceiling"
	--assert  2.0 = round/half-ceiling  1.5
	--assert -1.0 = round/half-ceiling -1.5

===end-group===
	
~~~end-file~~~
