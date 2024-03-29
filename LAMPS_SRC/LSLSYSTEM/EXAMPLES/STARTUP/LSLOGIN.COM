$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-18 10:22:08.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
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
