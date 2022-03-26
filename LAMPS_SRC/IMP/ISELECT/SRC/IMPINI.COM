
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Manipulation Package 'IMP'
$!
$! if we are not interactive, then don't output the explanation of what
$! IMP is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto obsolete_names
$!
$! and if they have used IMPINI Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto obsolete_names
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto obsolete_names
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$! We need to have an IMP lookup file to hold AC skeleton file for
$! the 10th wonder of the universe ISELAC. ACSKEL.DAT
$! is in LSL$LOOKUP on the public tree.
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m======  Initialising IFF Map Processing package 'IMP' Version 1.0 ======"
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The IMP modules are:                                                            "
$ ws "                                                                                "
$ ws "ICHECK      IDIFFERENCE      IFILTER      IFIXAREA      IFROMTEXT     IINFO     "
$ ws "                                                                                "
$ ws "ILAYFC      IMEND            IMERGE       IPATCH        IRECODE       IRENUMBER "
$ ws "                                                                                "
$ ws "IREPORT     ISELAC           ISELECT      ISORT         ISTART        ITOTEXT   "
$ ws "                                                                                "
$ ws "ITRANS      IWINDOW                                                             "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ Obsolete_names:
$	I2TEXT:=="WRITE SYS$OUTPUT ""Use ITOTEXT instead"""
$	TEXT2I:=="WRITE SYS$OUTPUT ""Use IFROMTEXT instead"""
$	IWRITE:=="WRITE SYS$OUTPUT ""Write a text or IFF file? Use ITOTEXT instead"""
$	IREAD :=="WRITE SYS$OUTPUT ""Read a text or IFF file? Use IFROMTEXT instead"""
$!
$	ICHECK:==$LSL$EXE:ICHECK
$	IDIFF*ERENCE:==$LSL$EXE:IDIFFERENCE
$	IFILT*ER:==$LSL$EXE:IFILTER
$	IINF*O:==$LSL$EXE:IINFO
$	ILAY*FC:==$LSL$EXE:ILAYFC
$	IMEND:==$LSL$EXE:IMEND
$	IMER*GE:==$LSL$EXE:IMERGE
$	IPAT*CH:==$LSL$EXE:IPATCH
$	IREC*ODE:==$LSL$EXE:IRECODE
$	IREP*ORT:==$LSL$EXE:IREPORT
$	ISELAC:==$LSL$EXE:ISELAC
$	ISELECT:==$LSL$source_root:[imp.iselect]ISELECT
$	ISORT:==$LSL$EXE:ISORT
$	ISTA*RT:==$LSL$EXE:ISTART
$	ITRA*NS:==$LSL$EXE:ITRANS
$!
$! Changed names
$!
$	ITO*TEXT:==$LSL$EXE:ITOTEXT
$	IWIN*DOW:==$LSL$EXE:IWINDOW
$	IFIXA*REA:==$LSL$EXE:IFIXAREA
$	IREN*UMBER:==$LSL$EXE:IRENUMBER
$	IFROM*TEXT:==$LSL$EXE:IFROMTEXT
$!
$! Define logical to point to OS Map Header translation table
$!
$	IF F$TRNLNM("LSL$OS_MH_TABLE").EQS."" THEN -
	   DEFINE LSL$OS_MH_TABLE LSL$LOOKUP:OSMH_NEW_TABLE.DAT
$!
$	if ver_status then set verify
