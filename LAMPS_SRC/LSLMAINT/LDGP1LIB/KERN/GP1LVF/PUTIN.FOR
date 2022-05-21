C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 15:31:10.000000000 +0000
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
      SUBROUTINE PUTIN (CODE_STRING,COD_COUNT)
C                      Transmission of ASCII plotter string
C                      (only for commands in REMOTE-operation)
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables
      INTEGER*2  COD_COUNT
      INTEGER*2  BIT (8)
      INTEGER*2  GP1STS
      INTEGER*2  CODE_STRING (500)
      INTEGER*2  I,M,N
      REAL*4     TIME
      CHARACTER*500 COMMAND

C... "QIO" variabeln :
      INTEGER*4	FUN_STATUS
      INTEGER*4	SYS$QIOW
      CHARACTER*(10) BUFF
      INTEGER*2	BUFLEN
      INTEGER*4	ISTS(2)
      INTEGER*2	IST(2)
      EQUIVALENCE (ISTS,IST)

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... if online skip
      IF (IMODE .EQ. 1) GOTO 10

C... write to data file (offline)
      WRITE (ICHANL,9000,ERR=997) (CODE_STRING (I),I=1,COD_COUNT - 2)
      IF (IMODE .EQ. 0) RETURN

C... transmit
10    CONTINUE

      DO 20 I = 1,COD_COUNT
      COMMAND (I:I) = CHAR (CODE_STRING (I))
20    CONTINUE


      FUN_STATUS = SYS$QIOW (,%VAL(GP1_CHAN),
     +                  %VAL(FUN_QIO_W),
     +                  ISTS,,,
     +                  %REF(COMMAND),
     +                  %VAL(COD_COUNT),,,,)

      IF (.NOT. FUN_STATUS) GOTO 998

C... test status for successfull transmission
      CALL GPSTAT (BIT)
      M = 0
      IF (BIT (3) .EQ. 0) M = 6
      IF (BIT (1) .EQ. 1) M = 13
      IF (BIT (4) .EQ. 0) M = 8
      IF (M .NE. 0) GOTO 996
      RETURN


C... GP1 in local, halt or reference lost (severe errors) :
C... set error code and send message
996   GP1ERR = .TRUE.
      CALL MESSAG (M)
      RETURN      


C...                          FATAL ERROR exits with stop of the program


C... writing to the data file failed
997   CALL MESSAG (57)
      FUN_STATUS = 1
      GOTO 999

C... QIOW failed
998   CALL MESSAG (69)
999   CALL MESSAG (63)
      CALL SYS$EXIT (%VAL(FUN_STATUS))


9000  FORMAT (80A1)

      END
