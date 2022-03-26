$	xxx:='f$verify(0)'
$	if p1 .eqs. "" then inquire p1 "Module"
$	if p1 .eqs. "" then exit
$	set verify
$	lib/rep/mac/log lslmaclib 'p1'
$	xxx:='f$verify(xxx)'
