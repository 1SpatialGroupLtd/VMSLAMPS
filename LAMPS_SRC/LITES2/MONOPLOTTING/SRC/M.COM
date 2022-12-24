$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-07-11 16:12:32.000000000 +0100
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
$! MONOPLOTTING_DEMO.COM
$!
$! Created 					CCB	15-Oct-1994
$! Layout standardised 				PGH	17-Oct-1994
$!
$! Procedure for demonstration of OSGB monoplotting
$!
$! Note that this is an example template file, for the user to adapt to fit the 
$! local environment. As such, names and locations may need to be 
$! changed to avoid conflicts.
$!
$ DEFINE/USER LSL$FILL_POINTSMAX 32768	! needs doing before LITES2 starts
$ DEFINE/USER LSL$LITES2TERMINAL " "	! prevent this from running
$ DEFINE/USER THIS_DIR 'F$ELEMENT(0,"]",F$ENVIRONMENT("PROCEDURE"))']
$ DEFINE/USER LSL$UIL THIS_DIR:
$ DEFINE/USER SYS$INPUT SYS$COMMAND
$ LITES2 @THIS_DIR:M.LCM
$!
$! end of MONOPLOTTING_DEMO.COM
