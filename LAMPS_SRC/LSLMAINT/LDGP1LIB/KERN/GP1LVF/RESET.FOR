C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 15:42:36.000000000 +0000
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
      SUBROUTINE RESET
C                     Set default values
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

      GP1ERR = .FALSE.
      LEUNIT = 0
      ANUNIT = 0
      SCLFAC = 1.0

      CALL VECTOR (0.0,0.0,3)
      CALL SCALE  (1.0,1.0)
      CALL SETPAR (0,0)
      CALL SYSET  (0)
      CALL SYSCAL (5.0)
      CALL SYROTA (0.0)
      CALL CHAR   (1)
      CALL STRSCL (5.0)
      CALL STROT  (0.0)
      CALL STRSLN (90.0)
      CALL PENCHA (1)
      CALL LINSET (1)
      CALL LINSCL (5.0)
      CALL LINRAT (5.0)
      CALL LINSYM (0)
      CALL LINSRO (0.0)
      CALL CLRWIN
      CALL SPEED  (9)

      RETURN


      E N D
