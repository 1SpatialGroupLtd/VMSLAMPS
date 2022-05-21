C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 22:53:34.000000000 +0000
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
      SUBROUTINE SYMDEF (IPARAM)
C                       Definition of an user symbol
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       IPARAM (130)
      INTEGER*2       CODE,I
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (130)
C
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... gp1 code, number of parameters and symbol data block
C
      IF (IPARAM (1) .GT. 57 .OR. IPARAM (1) .LT. 26) GOTO 20
      CODE       = 111
      COUNT      = IPARAM (2) * 3 + 2
      IF (COUNT .LT. 2 .OR. COUNT .GT. 122) GOTO 20
      DO 10 I = 1,COUNT
            IF (IPARAM (I) .GT. 127 .OR. IPARAM (I) .LT. -128) GOTO 20
            NUMBER (I) = IPARAM (I)
10    CONTINUE
C
C... transmit
C
      CALL SENDGP
      GOTO 30
C
20    CONTINUE
      CALL MESSAG (51)
C
30    CONTINUE
      RETURN
C
C
      E N D
