C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 22:41:12.000000000 +0000
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
      SUBROUTINE SETPAR (LENGTH,ANGLE)
C                       Set len and angle unit
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      LOGICAL*1       GP1ERR
      INTEGER*2       LEUNIT
      INTEGER*2       ANUNIT
      INTEGER*2       LENGTH,LEN
      INTEGER*2       ANGLE,ANG
C
      COMMON /GP1C01/ GP1ERR,LEUNIT,ANUNIT
C
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      LEN    = LENGTH
      ANG    = ANGLE
      GP1ERR = .FALSE.
C
      IF ((LEN .GE. 0 .AND. LEN .LE. 2) .AND.
     +    (ANG .GE. 0 .AND. ANG .LE. 2)) GOTO 10
C
      GP1ERR = .TRUE.
      CALL MESSAG (47)
      GOTO 20
C
10    CONTINUE
      LEUNIT = LEN
      ANUNIT = ANG
C
20    CONTINUE
      RETURN
C
C
      E N D
