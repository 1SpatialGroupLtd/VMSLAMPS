C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 21:18:24.000000000 +0000
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
      SUBROUTINE LINSCL (SL)
C                       Determines length of part of interupted stroke
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
      REAL*4          SLIN,SL,SCLFAC
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
      COMMON /GP1C03/ SCLFAC
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      SLIN   = SL * SCLFAC
      GP1ERR = .FALSE.
C
      IF (LEUNIT .EQ. 0) GOTO 10
      SLIN = SLIN * 10.0
      IF (LEUNIT .EQ. 1) GOTO 10
      SLIN = SLIN * 2.54
C
C... test, whether parameter is in permissible range
C
10    IF (SLIN .GE. 0.05 .AND. SLIN .LE. 1250.0) GOTO 20
C
      GP1ERR = .TRUE.
      CALL MESSAG (38)
      GOTO 30
C
C... plot code, conversion into plotter increments
C
20    CONTINUE
      CODE  = 96
      COUNT = 1
C
      NUMBER (1) = INT (20.0 * SLIN + 0.5)
C
C... transmit
C
      CALL SENDGP
C
30    CONTINUE
      RETURN
C
C
      E N D
