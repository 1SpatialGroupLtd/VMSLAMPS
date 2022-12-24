$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-05-27 14:54:10.000000000 +0100
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
$ !*********************************************************************
$ !
$ !  S Y S S C A N  PROCEDURE : LOADST
$ !
$ !  DATE / VERSION : 88-05-27 / 4.0  BY:  A.HAINES
$ !
$ !  PURPOSE:
$ !
$ !     Start the user communication part of the LOADST program
$ !
$ !*********************************************************************
$ !
$ !  Find batch identification number
$ !
$ XDEVE = F$LOGICAL("DIO$EXE")
$ DEVW  := ""
$ WRITE SYS$OUTPUT "LOADST version 1.0"
$ WRITE SYS$OUTPUT " "
$ WRITE SYS$OUTPUT "-Please wait-[A"
$ T=F$TIME()
$ NID=F$EXTRACT(13,1,T)+F$EXTRACT(15,2,T)+F$EXTRACT(18,2,T)+F$EXTRACT(21,1,T)
$ !
$ !  Start user communication  
$ !
$ SET ON
$ ON CONTROL_Y THEN GOTO END
$ ON WARNING   THEN GOTO END
$ ASSIGN/USER 'XDEVE'           LOADSTEXE
$ ASSIGN/USER LOADST'NID'.BCH   FOR015
$ ASSIGN/USER TT:               SYS$INPUT
$ ASSIGN/USER LSTAT'NID'.DAT    LSTATUS
$ RUN/NODEBUG 'XDEVE'LOADST
$ !
$ !  Submit the batch job -
$ !
$ WRITE SYS$OUTPUT ""
$! SUBMIT/DELETE/NOTIFY LOADST'NID'.BCH
$ !
$ !  - or run the job interactively
$ !
$ @LOADST'NID'.BCH
$ DELETE/NOCONFIRM LOADST'NID'.BCH;0
$ !
$ END:
$ EXIT
