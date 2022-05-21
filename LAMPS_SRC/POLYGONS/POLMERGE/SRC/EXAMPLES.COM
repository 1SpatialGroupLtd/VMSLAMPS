$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-10-08 11:40:30.000000000 +0100
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
$ SET NOON
$ IMPINI Q
$ SI LSL$SOURCE_ROOT:[POLYGONS.POLMERGE]
$ ASS LSL$SOURCE_ROOT:[POLYGONS.POLMERGE] LSL$LOOKUP
$ POLMERGE DAVEC_SLP_50 EXAMPLE
GO 
 
EXI
$ POLMERGE DAVEC_SLP_50/MER =(BY_LOO)/ELIM /AREA = (MER:5,ELIM:5) - 
 EXAMPLE1 /LOG /RATIO =(MER:7,ELIM:7,AREA:25) /LOO = POLMERGE.DAT
GO
 
EXI
$ POLMERGE DAVEC_SLP_50 /LOG /NOMERGE /ELIM /LOO=POLMERGE.DAT EXAMPLE2
GO
 
EXI
$ POLMERGE DAVEC_SLP_50 /LOG /NOELIM /MER = (BY_LOO,BY_SMALL) -
 /AREA=(MER:5)  EXAMPLE3 /LOO = POLMERGE2.DAT
GO
 
EXI
$ POLMERGE DAVEC.DUFF /LOG EXAMPLE4 
GO
 
EXI
$ POLMERGE DAVEC_SLP_50 /AREA =(MER:10,NOELIM) /ELIM=(BY_LOO)  -
 /MER =(BY_LARGE) /LOO =POLMERGE2.DAT EXAMPLE5 /LOG
GO
 
EXI
