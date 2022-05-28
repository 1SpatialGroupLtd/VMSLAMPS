$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-05-08 13:11:18.000000000 +0100
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
$! command file for setting up things up for LITES2 development
$!
$ set noon
$!
$ write sys$output "***   Version is LITES2"
$!
$! sort out which disk we're on
$!
$ DISC = f$logical("LSL$DISK")
$!
$! set up all the directories
$!
$ ASSIGN 'DISC'<LITES2.COM> COM
$ ASSIGN 'DISC'<LITES2.SRC> SRC
$ ASSIGN 'DISC'<LITES2.CMN> CMN
$ ASSIGN 'DISC'<LITES2.MAR> MAR
$ ASSIGN 'DISC'<LITES2.OBJ> OBJ
$ ASSIGN 'DISC'<LITES2.EXE> EXE
$ ASSIGN 'DISC'<LITES2.GEN> GEN
$ ASSIGN 'DISC'<LITES2.COM> LISTQ
$ ASSIGN  EXE:TWOUSRRTS TWOUSRRTS		! shared image of user
$!						! commands
$ ASSIGN 'DISC'<LITES2.CMD> LSL$LITES2CMD
$ ASSIGN 'DISC'<LITES2.JNL> LSL$LITES2JNL
$ ASSIGN 'DISC'<LITES2.JNL> LSL$LITES2SETUP
$ ASSIGN 'DISC'<LITES2.WORK> LSL$LITES2WORK
$ ASSIGN LSL$EXE:LASERSCAN_BUREAU.LIC LSL$LITES2LOCK
$ ASSIGN 'F$LOGICAL("LSL$LITES2CMD")' CMD
$ ASSIGN 'F$LOGICAL("LSL$LITES2JNL")' JNL
$!
$! set up devices for TEK and ARGS
$!
$ ASSIGN 'F$LOGICAL("TT")' LSL$TK
$ ASSIGN _IDA0: LSL$VS
$ ASSIGN LSL$IDSYDIR:COLOUR8.DAT LSL$IDSY02
$!
$ MTWO  == "@COM:MTWO"	! to MAKE the command file
$ CTWO  == "@COM:CTWO N"! to compile a single module and put in library
$ CTWOD == "@COM:CTWO D"! ditto with debug
$ LTWO  == "@COM:LTWO N"! to link LITES2
$ LTWOD == "@COM:LTWO D"! ditto with debug
$ TWONV == "@COM:TWONV"	! to edit a file
$ CSIGMA== "@COM:CSIGMA"! to compile a single Sigma module
$ OSDEMO== "@COM:OSDEMO"! OS DEMO
$ MCEDEMO== "@COM:MCEDEMO"! MCE DEMO
$ LITES2=="@LSL$COM:LITES2"
$ LITES2D=="$EXE:TWOD"
$ LITES2N=="RUN/NODEBUG EXE:TWOD"
$ TWOTVES=="$MCE$EXE:TWOTVES"
$ HELP2=="HELP/LIBRARY=LSL$HELP:LITES2"	! use LITES2 help
						! outside LITES2
$!
$! purge journal files
$!
$ SET MESSAGE/NOIDENTIFICATION/NOSEVERITY/NOTEXT/NOFACILITY
$ PURGE/KEEP=5 JNL:*.LJN
$ SET MESSAGE/IDENTIFICATION/SEVERITY/TEXT/FACILITY
