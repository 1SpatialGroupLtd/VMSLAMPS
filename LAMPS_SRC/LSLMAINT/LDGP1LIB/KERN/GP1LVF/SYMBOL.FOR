C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-19 17:28:00.000000000 +0000
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
C
C=====================================================================
C 718.300.0369   GP1LIB -- GP1 FORTRAN LIBRARY
C
      SUBROUTINE SYMBOL (X,Y,H,TEXT,ALPHA,N)
C                       Draw text line and symbols
C=====================================================================

      IMPLICIT NONE
      INCLUDE  'GP1LVF.GLO'

C...variables:
      LOGICAL     NOTODO,SYMERR
      CHARACTER*(80) CH_STRING
      INTEGER*2   STRING (40),TEXT (1)
      INTEGER*2   N,NUM,NUMSYM,NUMB
      INTEGER*2   I,K,L,M,INDEX
      REAL*4      HIGHT,H,PHI,ALPHA
      REAL*4      X,Y,XEND,YEND

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      XEND   = X
      YEND   = Y
      HIGHT  = H
      PHI    = ALPHA
      NUMB   = N
      NUM    = N
      SYMERR = .FALSE.

C... state of pen
      NOTODO = .FALSE.
      IF (INT(XEND+0.0001) .EQ. 999 .AND. INT(YEND+0.0001) .EQ. 999)
     +    NOTODO = .TRUE.

C... test if the value of number is in permissible range
      IF (NUMB .EQ. 0) GOTO 50
      IF (NUMB .LE. 0) GOTO 30
      IF (NUMB .GT. 80) NUMB = 80

C... exchange storage
      DO 10  I = 1,(NUMB / 2 + 1)
             STRING (I) = TEXT (I)
10    CONTINUE

C... text
      IF (.NOT. NOTODO) CALL VECTOR(XEND,YEND,3)
      IF (GP1ERR) SYMERR = .TRUE.

C... scaling and rotation of text
      CALL STRSCL (HIGHT)
      IF (GP1ERR) SYMERR = .TRUE.
      CALL STROT (PHI)
      IF (GP1ERR) SYMERR = .TRUE.

C... fill up text array with blanks
      INDEX = NUMB / 2 + 1
      IF (MOD (NUMB,2) .EQ. 1)
     +    STRING (INDEX) = MOD (STRING (INDEX),256) + 8192
      NUMB = INT (FLOAT (NUMB) / 2.0 + 0.6) + 1

      DO 20   I = NUMB,40
              STRING (I) = 8224
20    CONTINUE
      
C... write text
      DO 22  I = 1,40
      CH_STRING (2*I-1:2*I-1) = CHAR ( MOD (STRING (I) , 256))
      CH_STRING (2*I:2*I)     = CHAR ( STRING (I) / 256 )
22    CONTINUE

      CALL STRSET (CH_STRING)
      IF (GP1ERR) SYMERR = .TRUE.
      IF (SYMERR .OR. NUM .GT. 80) GOTO 50

      DO 25   I = 1,40
              IF (MOD (STRING (I), 256) .NE. 32) K = 2 * I - 1
              IF ((STRING (I) / 256) .NE. 32)    K = 2 * I
25    CONTINUE
      L = NUM - K
      IF (L .LE. 0) GOTO 50

      DO 26   I = 1,80
              CH_STRING (I:I) = ' '
26    CONTINUE

      DO 27   I = 1,L
              CALL STRSET (CH_STRING)
27    CONTINUE
      GOTO 50

C... symbol
30    CONTINUE
      NUMSYM = TEXT (1) + 11
      IF (NOTODO) GOTO 40
      IF (NUMB .EQ. -1) CALL VECTOR(XEND,YEND,3)
      IF (GP1ERR) SYMERR = .TRUE.
      IF (NUMB .LT. -1) CALL VECTOR(XEND,YEND,2)
      IF (GP1ERR) SYMERR = .TRUE.

C... scaling and rotation of symbol
40    CALL SYSCAL (HIGHT)
      IF (GP1ERR) SYMERR = .TRUE.
      CALL SYROTA (PHI)
      IF (GP1ERR) SYMERR = .TRUE.

C... draw symbol
      CALL SYSET (NUMSYM)
      IF (GP1ERR) SYMERR = .TRUE.

50    IF (SYMERR) GP1ERR = .TRUE.
      RETURN

      E N D
