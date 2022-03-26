$! Command file for creating DTM GKS shareable image
$! =================================================
$!
$	SET NOON
$!
$1:	INQUIRE	VER "Which version (NULL, MOTIF, UIS)
$	IF VER.nes."NULL" .and. VER.nes."MOTIF" .and. VER.nes."UIS" then goto 1
$!
$! write a truth file for conditionals in GKSVEC.MAR
$	SET VER
$	OPEN/WRITE TR TR.MAR
$	WRITE TR "''VER' = 1"
$	CLOSE TR
$!
$	MACRO/OBJ=GKSVEC TR+GKSVEC
$	DELETE TR.MAR;*
$!
$! Now link it
$	LSLOPT = ""
$	IF VER.eqs."MOTIF" .or. VER.eqs."UIS" then -
				LSLOPT = ",LSL$LIBRARY:LSLSHR/OPT"
$	LINK	/SHARE/EXE=DTM_GKS'VER'SHR -
		/MAP=DTM_GKS'VER'SHR/FULL -
		GKSSHR/OPT,GKS'VER'/OPT'LSLOPT'
$	PURGE DTM_GKS'VER'SHR.EXE
$	PURGE DTM_GKS'VER'SHR.MAP
$	DELETE GKSVEC.OBJ;*
$	SET NOVER
