$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-04-07 14:47:56.000000000 +0100
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
