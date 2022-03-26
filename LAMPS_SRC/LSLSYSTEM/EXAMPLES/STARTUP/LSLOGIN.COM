$! LSLOGIN.COM - system wide LSL login. Called from SYS$MANAGER:SYLOGIN.COM
$    	SAVVER='F$VERIFY(0)'
$!
$! *** WARNING *** when editing this file to put in site-specific changes,
$! only put them in the section marked for such changes. 
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! This file should be called from SYS$MANAGER:SYLOGIN.COM (SYS$SYLOGIN),
$! so that is is obeyed every time anyone logs in.
$! It sets up the required environment for LSL LAMPS Mapping/GIS software.
$! Add your site-specific package initialisation requirements to the section
$! marked with ***** below.
$! 
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "Executing login definitions from LSLOGIN"
$!
$! Allow group delete access to files, for cooperative working.
$!
$	SET PROT=(S:RWED,O:RWED,G:RWED,W)/DEFAULT	! group file access
$!
$! skip things if not needed
$!
$	IF F$MODE() .EQS. "BATCH" THEN GOTO INIT
$	IF F$TRNLNM("LSL$COM").EQS."" THEN GOTO BYPASS
$	IF F$MODE() .NES. "INTERACTIVE" THEN GOTO BYPASS
$!
$! get terminal charactistics right
$!
$	SET TERM/INQUIRE
$!
$! show disk free space
$!
$	@LSL$COM:FREE
$!
$! call package initialisation files, via site-specific file
$!
$INIT:	
$	@LSL$COM:LSLSYSTEMINI		! initialise LSLSYSTEM package
$!
$! *****************************************************************
$! **** Start of site-specific section - make changes below here ***
$! *****************************************************************
$!
$! set up symbol definitions in alphabetic order
$!
$	DI	=="DIRECTORY"		! shorthand
$	DIR	=="DIRECTORY/DATE/SIZE=ALL/OWNER/WID=(OWNER:19)" ! shorthand
$	DIS*MOUNT=="DISMOUNT/NOUNLOAD"	! to prevent accidental tape unloading
$	MOU*NT  =="MOUNT/NOASSIST"	! to prevent operator messages
$	WS	=="WRITE SYS$OUTPUT"
$!
$! Initialise packages
$!
$	@LSL$COM:IMPINI Q
$	@LSL$COM:LITES2INI
$!
$!!!	@LSL$COM:POSTPROCESSINI
$!!!	@LSL$COM:VTRAKINI
$!
$! ***************************************************************
$! **** End of site-specific section - make changes above here ***
$! ***************************************************************
$!
$!
$BYPASS:
$!
$! set up HERE for SDs benefit
$!
$	AAA="SYS$LOGIN_DEVICE:"
$LOOP:
$	BBB=AAA - ":" - ":"
$	IF F$TRNLNM(BBB,,,,,"CONCEALED") .EQS. "TRUE" THEN GOTO DONE
$	IF F$TRNLNM(BBB,,,,,"MAX_INDEX") .GT. 0 THEN GOTO DONE
$	IF F$TRNLNM(BBB,,,,,"TERMINAL") .EQS. "TRUE" THEN GOTO DONE
$	AAA=F$TRNLNM(BBB)
$	IF AAA .NES. "" THEN GOTO LOOP
$!
$DONE:	ASSIGN 'BBB':'F$DIRECTORY()'	HERE
$ 	ASSIGN 'BBB':			SYS$DISK
$!
$! Check default disk is available
$	IF .NOT. F$GETDVI("SYS$DISK","EXISTS") THEN GOTO NODISK
$	IF       F$GETDVI("SYS$DISK","MNT") THEN GOTO DISKOK
$!
$NODISK:
$	TYPE SYS$INPUT
#########################################################
###  Your default disk is not available for use.      ###
###  Your LOGIN.COM file has not been executed.       ###
###  Complain to System Manager or try again later !  ###
#########################################################
$DISKOK:
$!
$! tidy up and exit
$	WS "LSLOGIN complete"
$	SET CONTROL=T
$	IF SAVVER THEN SET VERIFY
