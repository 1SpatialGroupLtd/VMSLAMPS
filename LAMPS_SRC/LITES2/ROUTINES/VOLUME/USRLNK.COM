$	LINK/SHARE=VOLUME_ROUTINE SYS$INPUT:/OPT,-
	LSL$LIBRARY:TRANLIB/LIB,-
	LSL$LIBRARY:LSLSHR/OPT
USRLIB/INCLUDE=(USRDO,USRINI,USRRET,-
USRSTO,USRGZS,USRPZS,USRDEF)/LIB
UNSUPPORTED = 1	! force demand zero compression
UNIVERSAL = USRDO,USRINI,USRRET,USRSTO
UNIVERSAL = USRGZS,USRPZS,USRDEF
PSECT_ATTR=USRKEEP,NOSHR
PSECT_ATTR=USRKEEPC,NOSHR
PSECT_ATTR=USRFEAT,NOSHR
PSECT_ATTR=USRFEATC,NOSHR
$!