lites2motif
! Patch to LITES2MOTIF V4.1-3 of 17 Dec 92
! (linked 14/1/93 and patched subsequently)
! to fix point attributes on points 181-200 etc. of contructions.
!
! Change version to -4
e/byte 95a39
d/byte 95a39=34
!
! In STRTER, copy down attributes (and call DELDEF)
set mode ins
e 11cc3a
insert 11cc3a
"movb w^00b4(r6),(r6)+"
"pushr #3"
"pushal w^0fc44(r1)"
"calls #1,l^7edd0"
"popr #3"
"movl w^0ff14(r1),w^0fc44(r1)"
"clrl w^0ff14(r1)"
exit
!
u
