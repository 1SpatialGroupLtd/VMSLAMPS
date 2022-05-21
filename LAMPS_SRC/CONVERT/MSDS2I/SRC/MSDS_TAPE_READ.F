C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-02-05 11:10:44.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
CDEC$	IDENT	'05FE90'
C jiffy program to read an MSDS tape PGH/RWR 5/2/90
C (COPY and CONVERT won't work because lines are too long for buffers)
	INTEGER		RECLEN
	CHARACTER*4096	BUFFER
C
	OPEN(UNIT=1,NAME='MUB1:MSDS.NFF',STATUS='OLD',RECL=4096,READONLY)
	OPEN(UNIT=2,NAME='MSDS.PGH',STATUS='NEW',CARRIAGECONTROL='LIST',
     &   RECL=4096)
C
	DO 10 I=1,100000
	   READ(1,1000,END=999)RECLEN,BUFFER
	   WRITE(2,2000)BUFFER(1:RECLEN)
	   TYPE *,'Written record',I,' length ',RECLEN
10	CONTINUE	   
999	CALL EXIT
1000	FORMAT(Q,A)
2000	FORMAT(A)
	END
