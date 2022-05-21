C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 18:11:32.000000000 +0000
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
      SUBROUTINE STRSEL (TEXT)
C                       Plotting a text line
C                       Length of line parameter will sent first
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      CHARACTER*(80)  TEXT
      INTEGER*2       LEPART (3),LENGTH,I,N,SP,CHARAC

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... initialize
      SP     = 32
      GP1ERR = .FALSE.
      CODE = 116

C... determine the length, blanks at the end will be ignored
      LENGTH = 0
      DO 5    I = 1,80
              IF (TEXT (I:I) .NE . ' ') LENGTH = I
5     CONTINUE
      IF (LENGTH .EQ. 0) RETURN

C... cut length to 77
      IF (LENGTH .GT. 77) LENGTH = 77
      COUNT = - (LENGTH + 3)

C... exchange
      DO 10   I = 4,80
          PARAM (I) = ICHAR (TEXT (I-3:I-3))
          IF (PARAM(I) .EQ. 8) PARAM (I) = 127
          IF (PARAM(I) .LT. 32 .AND. PARAM(I) .NE. 0) GP1ERR = .TRUE.
10    CONTINUE

C... error in string ?
      IF (.NOT. GP1ERR) GOTO 20
      CALL MESSAG (32)
      RETURN

C... split length in 3 parts, put it in PARAM(1,2,3)
20    PARAM (1)  = MOD (LENGTH,64)
      LENGTH     = LENGTH / 64
      PARAM (2)  = MOD (LENGTH,64)
      LENGTH     = LENGTH / 64
      PARAM (3)  = MOD (LENGTH,16)
      PARAM (1)  = PARAM (1) + SP
      PARAM (2)  = PARAM (2) + SP
      PARAM (3)  = PARAM (3) + SP

C... transmit
      CALL SENDGP
      RETURN
      E N D
