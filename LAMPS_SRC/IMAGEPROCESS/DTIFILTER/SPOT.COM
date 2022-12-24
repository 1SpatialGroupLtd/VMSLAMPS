$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-12-11 15:06:58.000000000 +0000
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

$ ASS LSL$LOOKUP:DFIL.DAT LSL$FILTER
$ RUN DTIFILTER/NODEB
FILE SPOT1WORD
WIN 1400 950 1499 1299
ABSOLUTE
OUT SPOTLAP
KER LAPLAC
CON
OUT SPOTE
KER GRADEAST
CON
OUT SPOTNW
KER GRADNW
CON
OUT SPOTNE
KER GRADNE
CON
OUT SPOTN
KER GRADNORTH
CON
OUT SPOTSOBX
KER SOBELX
CON
OUT SPOTSOBY
KER SOBELY 
CON
OUT SPOTMEDE
KER MEDEAST
MEDIAN
OUT SPOTMEDNW
KER MEDNW
MEDIAN
OUT SPOTMEDLARNW
KER MEDLARGENW
MEDIAN
OUT SPOTMED
SIZ 3 3
KER 1 1 1 1 1 1 1 1 1
MEDIAN
OUT SPOTMODE
MODE
OUT SPOTMEAN
MEAN
EXIT
