$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-03-26 11:25:46.000000000 +0000
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
$	V='F$VER(0)'
$	SET VER
$	SET ON
$	ON ERROR THEN GOTO EXIT
$	ON CONTROL THEN GOTO EXIT
$ !
$ ! Created from VAX/VMS Systems Dispatch (Jan 1985)	 DM	26-Mar-1985 
$ !
$ ! Converts an image linked with /TRACEBACK into one that no longer has
$ ! /TRACEBACK. This procedure uses certain image header offsets as
$ ! hard-coded values, and may therefore cease to work for versions of
$ ! of VAX/VMS after 4.0.
$ !
$ ! This procedure modifies the transfer address array for an image. It
$ ! deletes the first transfer address in the array by moving the following
$ ! three entries up one position, while placing a zero in the vacated
$ ! position. It only operates on images containing the address SYS$IMGSTA
$ ! in the first entry of the transfer address array.
$ !
$	IF P1 .EQS. "" THEN INQUIRE/NOP P1 "Image name ? "
$	IF P1 .EQS. "" THEN GOTO EXIT
$ !
$	P1:="''F$PARSE(P1,".EXE;")'"
$	IF P1 .NES. "" THEN GOTO OK
$	P1=F$SEARCH(P1)
$	GOTO EXIT				! report error & exit
$ !
$ OK:	POS='F$LOCATE(".EXE;",P1)'
$	P1:='F$EXTRACT(0,POS,P1)'
$ !
$	PATCH/ABSOLUTE/NOOUT/NOJOU 'P1'
!
! Determine whether the image is linked /TRACEBACK with the S0 flavour of
! SYS$IMGSTA.
!
EXAMINE/WORD 2
DEFINE BASE=\
REPLACE/LONG BASE
80000168
EXIT
80000168
EXIT
EXIT
$	IF $STATUS THEN GOTO PATCH_IMAGE
$	PATCH/ABSOLUTE/NOOUT/NOJOU 'P1'
!
! Determine whether the image is linked /TRACEBACK with the P1 flavour of
! SYS$IMGSTA.
!
EXAMINE/WORD 2
DEFINE BASE=\
REPLACE/LONG BASE
7FFEDF68
EXIT
7FFEDF68
EXIT
EXIT
$	IF .NOT. $STATUS THEN GOTO EXIT
$ !
$ PATCH_IMAGE:
$ !
$ ! At this point, we have an image that was linked /TRACEBACK.
$ ! Now, modify the transfer address array so that the image appears
$ ! to the system as if it was linked /NOTRACEBACK.
$ !
$	PATCH/ABSOLUTE/OUT='P1'/JOU='P1' 'P1'
!
! Retrieve offset to transfer address array
!
EXAMINE/WORD 2
DEFINE BASE=\
!
! Move the second, third and fourth array elements up one longword in
! the array, thus clobbering the first entry (which is SYS$IMGSTA for
! images linked with /TRACEBACK). Since the fourth array element
! contains a zero, the third one will also when we're done.
!
EXAMINE/LONG BASE+4
DEFINE CONTENTS=\
DEPOSIT/LONG BASE+0=CONTENTS
!
EXAMINE/LONG BASE+8
DEFINE CONTENTS=\
DEPOSIT/LONG BASE+4=CONTENTS
!
EXAMINE/LONG BASE+0C
DEFINE CONTENTS=\
DEPOSIT/LONG BASE+8=CONTENTS
!
UPDATE
EXIT
$ EXIT:	IF V THEN SET VERIFY
