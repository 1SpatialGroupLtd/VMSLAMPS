C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 18:13:50.000000000 +0000
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
      SUBROUTINE VECTOR (X,Y,IP)
C                       Drawing of straight lines
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:
      INTEGER*2       IROUND,PEN,IP
      REAL*4          MAX,XEND,YEND,X,Y

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... constant:
      MAX = 1310.6996

C... initialize values
      XEND   = X * SCLFAC
      YEND   = Y * SCLFAC
      PEN    = IP
      GP1ERR = .FALSE.

C... conversion into mm
      IF (LEUNIT .EQ. 0) GOTO 10
      XEND = XEND * 10.0
      YEND = YEND * 10.0

      IF (LEUNIT .EQ. 1) GOTO 10
      XEND = XEND * 2.54
      YEND = YEND * 2.54

C... test, whether parameters are in permissible range
10    IF (ABS (XEND) .GT. MAX) GOTO 20
      IF (ABS (YEND) .GT. MAX) GOTO 20
      IF (PEN .GT. 4 .OR. PEN .LT. 2) GOTO 20

C... generate ASCII Code
      CODE  = 63 + PEN

C... convert coordinates into plotter increments
      COUNT = 2
      PARAM (1) = IROUND (25.0 * XEND)
      PARAM (2) = IROUND (25.0 * YEND)

C... transmit
      CALL SENDGP
      RETURN

20    CONTINUE
      GP1ERR = .TRUE.
      CALL MESSAG (24)
      RETURN


      E N D
