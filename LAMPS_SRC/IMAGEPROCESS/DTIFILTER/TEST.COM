$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-12-11 18:03:20.000000000 +0000
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
FILE TESTDF2
ABSOLUTE
OUT TESTLAP
KER LAPLAC
CON
OUT TESTE
KER GRADEAST
CON
OUT TESTNW
KER GRADNW
CON
OUT TESTNE
KER GRADNE
CON
OUT TESTN
KER GRADNORTH
CON
OUT TESTSOBX
KER SOBELX
CON
OUT TESTSOBY
KER SOBELY 
CON
OUT TESTMEDE
KER MEDEAST
MEDIAN
OUT TESTMEDNW
KER MEDNW
MEDIAN
OUT TESTMEDLARNW
KER MEDLARGENW
MEDIAN
OUT TESTMED
SIZ 3 3
KER 1 1 1 1 1 1 1 1 1
MEDIAN
OUT TESTMODE
MODE
OUT TESTMEAN
MEAN
EXIT
