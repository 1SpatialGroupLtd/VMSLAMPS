$! LSIMAGES.COM - install LSL images. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$! Alpha AXP modifications				CCB	 3-Aug-1994
$!
$! Installs various LSL images for speed of activation, and enhanced privilege.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSIMAGES.COM - Installing images"
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	IF ARCH_NAME.EQS."Alpha"
$	THEN
$! ALPHA
$	   RUN SYS$SYSTEM:INSTALL
LSL$LSLSHR_TV:/SHARE/OPEN/HEADER
LSL$IFFSHR_TV:/SHARE/OPEN/HEADER
LSL$FRTSHR_TV:/SHARE/OPEN/HEADER
LSL$EXE:QUO_TV/PRIV=WORLD
LSL$EXE:SD_AXP/OPEN/HEADER
LSL$EXE:SI_AXP/OPEN/HEADER
!!!LSL$EXE:LITES2MOTIF_TV/OPEN/SHARED/HEADER
$	ELSE
$! VAX
$	   RUN SYS$SYSTEM:INSTALL
LSL$LSLSHR:/SHARE/OPEN/HEADER
LSL$IFFSHR:/SHARE/OPEN/HEADER
LSL$FRTSHR:/SHARE/OPEN/HEADER
LSL$EXE:QUO/PRIV=WORLD
LSL$EXE:SD/OPEN/HEADER
LSL$EXE:SI/OPEN/HEADER
!!!LSL$EXE:STARTMON/PRIV=(DETACH,ALTPRI)
!!!LSL$EXE:LITES2SIG6000/OPEN/SHARED/HEADER
$	ENDIF
$!
$	EXIT