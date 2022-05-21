C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 18:12:36.000000000 +0000
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
      SUBROUTINE STRSET (TEXT)
C                       Plotting a text line
C                       End of text marked with "$"
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      CHARACTER*(80)  TEXT
      INTEGER*2       I,N
      INTEGER*2       CHARAC

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      DO 10   I = 1,80
              PARAM (I) = ICHAR (TEXT (I:I))
10    CONTINUE

      GP1ERR = .FALSE.

C... plot code
      CODE = 89

C... counting of characters and end $

      N = 1
      DO 30  I = 1,80
             CHARAC = PARAM (I)
             IF (CHARAC .EQ. 8) PARAM (I) = 127
             IF (CHARAC .LT. 32 .AND. CHARAC .NE. 0) GP1ERR = .TRUE.
             IF (CHARAC .EQ. 36) GOTO 25
             IF (CHARAC .EQ. 0) GOTO 25
             IF (CHARAC .GT. 32) N = I
             GOTO 30
25           N = I - 1
             GOTO 35
30    CONTINUE
             
35    IF (.NOT. GP1ERR) GOTO 40
      CALL MESSAG (32)
      GOTO 50

40    CONTINUE
      N = N + 1
      PARAM (N) = 36
      COUNT      = -N

C... transmit
      CALL SENDGP

50    CONTINUE
      RETURN

      E N D
