$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-12-06 12:35:24.000000000 +0000
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
$! Diddy procedure to test hardware names list.
$! Created					PGH	5-Dec-1994
$ WRITE SYS$OUTPUT "... Creating test program"
$ CREATE HW_NAMES_TEST.FOR
	CHARACTER*100 NAME
	INTEGER NAME_LENGTH
	INTEGER	NUMBER
10	TYPE *,'Input a model number (0 to exit)'
	ACCEPT *,NUMBER
	IF (NUMBER.LE.0) CALL EXIT
	CALL HW_MODEL_TO_NAME(NUMBER,NAME,NAME_LENGTH)
	TYPE *,'Model Name is "',NAME(1:NAME_LENGTH),'"'
	GOTO 10
	END
$!	
$ WRITE SYS$OUTPUT "... Compiling test program and generated routine"
$ FORT  HW_NAMES_TEST+HW_MODEL_TO_NAME.SRC
$ WRITE SYS$OUTPUT "... Linking test program with generated routine"
$ LINK HW_NAMES_TEST
$ WRITE SYS$OUTPUT "... Running test program"
$ DEFINE/USER DBG$INPUT SYS$COMMAND
$ DEFINE/USER SYS$INPUT SYS$COMMAND
$ RUN HW_NAMES_TEST
$ WRITE SYS$OUTPUT "... Test program complete"
$ EXIT
