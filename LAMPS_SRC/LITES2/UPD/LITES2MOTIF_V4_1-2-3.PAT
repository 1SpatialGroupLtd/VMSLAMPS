lites2motif
! patch to improve buffer zones
! change version number from 4.1-2 to 4.1-3
e/asc 95a38
d/asc .='-3'
!
! changes to REG_TRUNC
! miss out a bit of code by changing a BLEQ (15) to a BRB (11)
d/byte 134ad4=11
!
! add a couple of extra lines (by replacing a section, to try not
! to mess up the branches
set mode ins
repl 00134CA3
"TSTL     B^0EC(R11)"
"BNEQ     00134CB4"
"MOVL     B^0DC(R11),B^0BC(R11)"
"MOVL     B^0E0(R11),B^0C0(R11)"
"BRB      00134CBE"
"MOVL     B^0E4(R11),B^0BC(R11)"
"MOVL     B^0E8(R11),B^0C0(R11)"
exit
"TSTL     B^0EC(R11)"
"BNEQ     L1"
"MOVL     B^0DC(R11),B^0BC(R11)"
"MOVL     B^0E0(R11),B^0C0(R11)"
"BRB      L2"
"L1: MOVL     B^0E4(R11),B^0BC(R11)"
"MOVL     B^0E8(R11),B^0C0(R11)"
"L2: PUSHAL B^0C(R11)"
"    PUSHAL @B^0C(AP)"
"    PUSHAL B^0BC(R11)"
"    CALLS  #3,L^111CF0"
"    CMPL   B^0C(R11),#1"
"    BEQL   L3"
"    CLRL   @B^10(AP)"
"L3: NOP"
exit
!
! now remove adding 0.5 in GET_SHEET_OSGB, so that being within
! 0.5 of top and right does not go into next sheet
repl 12e967
"addd3 #0,b^08(r0),r1"
exit
"movd b^08(r0),r1"
exit
repl 12e96f
"addd3 #0,b^10(r0),r2"
exit
"movd b^10(r0),r2"
exit
u
