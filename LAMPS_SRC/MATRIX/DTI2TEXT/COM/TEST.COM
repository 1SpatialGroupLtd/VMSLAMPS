$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-12-08 12:53:00.000000000 +0000
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
FORMAT 12F8.1
FILEOUT TEST.TXT
NULL -1
UNITS METRES
SHOW UNITS
ENABLE NINT
ENABLE PME
ENABLE DIAG
SHOW DEF
SHOW UNITS
PAUSE
SHOW UNITS
FILEIN FAIROES
SHOW UNITS
UNITS METRES
WINDOW 10 200 1452 3001
SHOW UNITS
SHOW WINDOW
PAUSE
SHOW DEF
PAUSE
RETURN
