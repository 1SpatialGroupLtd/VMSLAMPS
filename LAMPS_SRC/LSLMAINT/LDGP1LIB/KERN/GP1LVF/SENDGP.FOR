C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 18:09:08.000000000 +0000
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
      SUBROUTINE SENDGP
C                      Preparation of ASCII plotter string
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C... variables:

      INTEGER*2  GPCODE (500)
      INTEGER*2  PART (3)
      INTEGER*2  QUANT
      INTEGER*2  CHECK, IPLP
      INTEGER*2  I
      INTEGER*2  SP,CR,LF


C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C... constants:
      SP     = 32
      CR     = 13
      LF     = 10

C... distinction of cases
      GPCODE (1) = CODE
      IF (COUNT .GT. 0) GOTO 20
      QUANT = 0
      IF (COUNT .EQ. 0) GOTO 40
      QUANT = IABS (COUNT)

      DO 10  I = 1,QUANT
             GPCODE (I + 1) = PARAM (I)
10    CONTINUE
      GOTO 40

C... split up numbers
20    CONTINUE
      DO 30  I = 1,COUNT
             QUANT = 3 * I
             IPLP  = PARAM (I)
             IF (IPLP .LT. 0) GOTO 21

             PART (1) = MOD (IPLP,64)
             IPLP     = IPLP / 64
             PART (2) = MOD (IPLP,64)
             IPLP     = IPLP / 64
             PART (3) = MOD (IPLP,16)
             GOTO 22

21           IPLP     = IPLP + 32767
             IPLP     = IPLP + 1
             PART (1) = MOD (IPLP,64)
             IPLP     = IPLP / 64
             PART (2) = MOD (IPLP,64)
             IPLP     = IPLP / 64
             PART (3) = MOD (IPLP,16) + 8


22           GPCODE (QUANT - 1) = PART (1) + SP
             GPCODE (QUANT)     = PART (2) + SP
             GPCODE (QUANT + 1) = PART (3) + SP
30    CONTINUE

40    CONTINUE

C... find checksum
      CHECK  = 0
      DO 50  I = 1,QUANT + 1
             CHECK = CHECK + GPCODE (I)
50    CONTINUE

      CHECK = MOD (CHECK,128)
      IF (CHECK .LT. 32) CHECK = CHECK + 32
      GPCODE (QUANT + 2) = CHECK
      GPCODE (QUANT + 3) = CR
      GPCODE (QUANT + 4) = LF
      QUANT = QUANT + 4

C... transmit
      CALL PUTIN (GPCODE,QUANT)

      RETURN

      E N D
