C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 22:38:36.000000000 +0000
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
      SUBROUTINE SCALE (XS,YS)
C                      Change of scale in X and Y direction
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (1)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      REAL*4          XSCL,YSCL,XS,YS
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      XSCL   = XS
      YSCL   = YS
      GP1ERR = .FALSE.
C
C... test, whether parameters are in permissible range
C
      IF ((XSCL .GE. 0.01 .AND. XSCL .LE. 250.0) .AND.
     +    (YSCL .GE. 0.01 .AND. YSCL .LE. 250.0)) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (25)
      GOTO 20
C
C... scaling of x axis
C
10    CONTINUE
      CODE       = 68
      COUNT      = 1
      NUMBER (1) = INT (100.0 * XSCL + 0.5)
C
C... transmit
C
      CALL SENDGP
C
C... scaling of y axis
C
      CODE       = 69
      NUMBER (1) = INT (100.0 * YSCL + 0.5)
C
C... transmit
C
      CALL SENDGP
C
20    CONTINUE
      RETURN
C
C
      E N D
