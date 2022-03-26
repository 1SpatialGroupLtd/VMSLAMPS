gkscal5800shr
set module/all
set mode ins
e GESC+0B7
repl
.
"clrl w^019c(r3)"
exit
"incl l^0c4d8"
"movl l^0c4d8, w^019c(r3)"
"pushl #0"
"pushl sp"
"pushal w^019c(r3)"
"calls #2,l^setlvl"
"addl2 #4,sp"
exit
u
