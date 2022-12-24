C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 21:24:28.000000000 +0000
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
      SUBROUTINE NEWIND (XL,YL,XR,YU)
C                       Set a new window
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       CODE,IROUND
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (4)
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      REAL*4          XLEFT,YLOWER
      REAL*4          XL,YL
      REAL*4          XRIGHT,YUPPER
      REAL*4          XR,YU
      REAL*4          MAX,SCLFAC
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
      COMMON /GP1C02/ CODE,COUNT,NUMBER
      COMMON /GP1C03/ SCLFAC
C
C... constant:
C
      MAX = 1310.6996
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      XLEFT  = XL * SCLFAC
      YLOWER = YL * SCLFAC
      XRIGHT = XR * SCLFAC
      YUPPER = YU * SCLFAC
      GP1ERR = .FALSE.
C
C... conversion into mm
C
      IF (LEUNIT .EQ. 0) GOTO 10
      XLEFT  = XLEFT  * 10.0
      YLOWER = YLOWER * 10.0
      XRIGHT = XRIGHT * 10.0
      YUPPER = YUPPER * 10.0
C
      IF (LEUNIT .EQ. 1) GOTO 10
      XLEFT  = XLEFT  * 2.54
      YLOWER = YLOWER * 2.54
      XRIGHT = XRIGHT * 2.54
      YUPPER = YUPPER * 2.54
C
C... test, whether parameters are in permissible range
C
10    IF (ABS (XLEFT)  .GT. MAX) GOTO 20
      IF (ABS (YLOWER) .GT. MAX) GOTO 20
      IF (ABS (XRIGHT) .GT. MAX) GOTO 20
      IF (ABS (YUPPER) .GT. MAX) GOTO 20
C
C... plot code, conversion into plotter increments
C
      CODE  = 106
      COUNT = 4
C
      NUMBER (1) = IROUND (25.0 * XLEFT)
      NUMBER (2) = IROUND (25.0 * YLOWER)
      NUMBER (3) = IROUND (25.0 * XRIGHT)
      NUMBER (4) = IROUND (25.0 * YUPPER)
C
C... transmit
C
      CALL SENDGP
      GOTO 30
C
20    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (43)
C
30    CONTINUE
      RETURN
C
C
      E N D
