C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-01-25 22:57:18.000000000 +0000
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
      SUBROUTINE TKREI
C                      Pen down and circle with tangentialdrive
C=====================================================================

      IMPLICIT NONE
C
C... variables:
C
      INTEGER*2       CODE
      INTEGER*2       COUNT
C
      COMMON /GP1C02/ CODE,COUNT
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... full circle counterclockwise with engraphing tool
C
      CODE       = 114
      COUNT      = 0
C
      CALL SENDGP
C
C
      RETURN
C
C
      E N D
