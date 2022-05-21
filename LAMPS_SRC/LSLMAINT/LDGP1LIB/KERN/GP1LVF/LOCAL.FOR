C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 15:19:12.000000000 +0000
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
C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE LOCAL
C                     Switch from REMOTE to LOCAL
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2  BIT (8), I

C... "QIO" variabeln :
      INTEGER*4	FUN_STATUS
      INTEGER*4	SYS$QIOW
      CHARACTER*(12) COMMAND
      INTEGER*2	BUFLEN,IST(2)
      INTEGER*4	ISTS(2)
      EQUIVALENCE (ISTS,IST)

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... if offline then skip
      IF (IMODE .EQ. 0) RETURN

C... switch to LOCAL
      COMMAND (1:1) = CHAR (23)
      COMMAND (2:2) = CHAR (55)
      COMMAND (3:3) = CHAR (13)
      COMMAND (4:4) = CHAR (10)
      BUFLEN = 4

      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(COMMAND),
     +                  %VAL(BUFLEN),,,,)

      IF (.NOT. FUN_STATUS) GOTO 999

C... wait until GP1 is really in LOCAL mode
10    CONTINUE
      DO 20 I = 1,1000
20    CONTINUE
      CALL GPSTAT (BIT)
      IF (BIT (3) .EQ. 1) GOTO 10
      RETURN


C... QIOW failed              FATAL ERROR exits with stop of the program
999   CALL MESSAG (67)
      CALL MESSAG (63)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

      E N D
