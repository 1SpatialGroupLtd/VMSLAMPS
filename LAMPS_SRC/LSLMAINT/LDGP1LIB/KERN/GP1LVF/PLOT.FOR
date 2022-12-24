C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 21:30:06.000000000 +0000
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
      SUBROUTINE PLOT (X,Y,IP)
C                     Drawing of straight lines, set origin, end
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       IP,PEN
      REAL*4          X,Y,XEND,YEND
      LOGICAL*1       SETOR
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      XEND = X
      YEND = Y
      PEN  = IP
C
      SETOR = .FALSE.
      IF (PEN .LT. 0) SETOR = .TRUE.
      PEN = IABS (PEN)
C
C... end
C
      IF (PEN .EQ. 999) GOTO 10
C
C... wrong selection of pen
C
      IF (PEN .GT. 4 .OR. PEN .LT. 2) GOTO 20
C
C... drawing
C
      CALL VECTOR (XEND,YEND,PEN)
C
C... set origin
C
      IF (SETOR) CALL SETORG
      GOTO 20
C
C... end
C
10    CONTINUE
      CALL VECTOR (0.0,0.0,3)
      CALL PLTEND
C
20    CONTINUE
      RETURN
C
C
      E N D
