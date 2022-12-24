$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-03-20 10:52:00.000000000 +0000
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
$	IF P1.EQS."" THEN -	!'F$VERIFY(1)
$	FORTRAN/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SECTST.SRC
$	LINK/DEBUG SECTST,FILSEC,VIOLIB/LIB
$	V='F$VERIFY(0)
$	IF F$SEARCH("SECTST.OBJ;-1")+F$SEARCH("SECTST.EXE;-1").NES."" THEN -
$	PURGE SECTST.OBJ,.EXE
