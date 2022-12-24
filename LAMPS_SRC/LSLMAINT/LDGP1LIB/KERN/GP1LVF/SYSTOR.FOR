C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-17 17:44:34.000000000 +0000
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

      SUBROUTINE SYSTOR
C                      Storing of user defined symbols on TU58
C=====================================================================

      IMPLICIT NONE

      INTEGER*2       CODE
      INTEGER*2       COUNT
      INTEGER*2       NUMBER (130)

      COMMON /GP1C02/ CODE,COUNT,NUMBER

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      CODE  = 112
      COUNT = 0

      CALL SENDGP

      RETURN


      E N D
