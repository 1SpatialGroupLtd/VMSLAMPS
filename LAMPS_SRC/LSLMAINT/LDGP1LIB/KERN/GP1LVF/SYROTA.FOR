C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 21:54:26.000000000 +0000
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
      SUBROUTINE SYROTA (RS)
C                       Rotation of a symbol
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE,IROUND
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (2)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      REAL*4          RSYMB,RS
      REAL*4          RAD,TWOPI
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
C
C... constant:
C
      RAD   = 0.017453293
      TWOPI = 6.2831854
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      RSYMB  = RS
      GP1ERR = .FALSE.
C
      IF (ANUNIT .EQ. 0) RSYMB = RSYMB * RAD
      IF (ANUNIT .EQ. 1) RSYMB = RSYMB * RAD * 0.9
C
C... test, whether parameter is in permissible range
C
      IF (ABS (RSYMB) .LT. TWOPI) GOTO 10
      GP1ERR = .TRUE.
      CALL MESSAG (30)
      GOTO 20
C
C... plot code, generation of rotation parameters
C
10    CODE  = 87
      COUNT = 2
C
      NUMBER (1) = IROUND (SIN (RSYMB) * 32767.0)
      NUMBER (2) = IROUND (COS (RSYMB) * 32767.0)
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
