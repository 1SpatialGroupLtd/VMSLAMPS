C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-17 17:38:20.000000000 +0000
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

C=======================================================================
C 718.300.0700   GPFPUS -- PUT SYMBOLS TO GP1 (LIBRARY VMS/FORTRAN)

C This program sends and stores user defined symbols to GP1
C=======================================================================

      PROGRAM GPFPUS

      IMPLICIT NONE
      INCLUDE 'GP1LVF.GLO'

      LOGICAL*1   ERR
      LOGICAL     EXIST
      CHARACTER*80 FILNAM
      INTEGER*2   BLANK,DPOINT,POINT,LENGTH,OUT,IN
      INTEGER*2   IPARAM (130)
      INTEGER*2   FN_SIZE
      INTEGER*2   I, J, M, M1, M2, M3, N, NN
      INTEGER*4   LUN
      INTEGER*4   LIB$GET_INPUT
      INTEGER*4   LIB$GET_LUN
      INTEGER*4   FUN_STATUS

C------------------------------------------------------------------------

C... initialize variables
      OUT   = 5
      IN    = 5

C... initialize GP1 and write titles
      CALL GPINIT (1,'DK:SYMBOL.GP1',20,ERR)
      CALL MESSAG (16)
      WRITE (OUT,9003)

C... get a free logical unit number
      FUN_STATUS = LIB$GET_LUN (LUN)
      IF (.NOT. FUN_STATUS) GOTO 998
      ICHANL = LUN

C... read file name from terminal
20    FUN_STATUS = LIB$GET_INPUT (FILNAM,
     +             'File name : ',
     +             FN_SIZE)
      IF (.NOT. FUN_STATUS) GOTO 20

C... does this file exist ?
      INQUIRE (FILE = FILNAM (1:FN_SIZE), EXIST = EXIST)
      IF (.NOT. EXIST) GOTO 996

C... access to plot file
75    OPEN (UNIT=ICHANL, NAME=FILNAM, TYPE='OLD', READONLY, ERR=999)

C... read all symbols and send them to GP1
      I = 1
110   CONTINUE
      READ (ICHANL, 9001, ERR=997, END=140) M,N
      IPARAM(1) = M
      IPARAM(2) = N
      NN=3*N
      J = 3

120   CONTINUE
         READ (ICHANL, 9001, ERR=997, END=140) M1,M2,M3
         IPARAM (J) = M1
         J = J + 1
         IPARAM (J) = M2
         J = J + 1
         IPARAM (J) = M3
         J = J + 1
         I = I + 1
         IF (J .LE. NN) GOTO 120

      CALL SYMDEF (IPARAM)
      GOTO 110

C... let's store the symbols
140   CALL SYSTOR
      CALL PLTEND
      CALL EXIT

C-----------------------------------------------------------------------

C... file not exist
996   WRITE (OUT,9006)
      CALL EXIT

C... error during reading the file
997   CONTINUE
      WRITE (OUT,9007)I
      CALL EXIT

C... error opening a channel
998   WRITE (7,9005)
      CALL SYS$EXIT (%VAL(FUN_STATUS))

C... error opening the file
999   WRITE (7,9004) FILNAM
      CALL EXIT

C-----------------------------------------------------------------------

9001  FORMAT (3I5)
9003  FORMAT ( 1X, 'GPFPUS - PUT SYMBOLS' , ///,
     +       1X, 'This program sends a user symbol file to the GP1',/,
     +       1X, '------------------------------------------------',//)
9004  FORMAT (/1X,'GPFPUS - Cannot open the input file ',A80,//)
9005  FORMAT (/1X,'GPFPUS - Error opening a channel',//)
9006  FORMAT (/1X,'GPFPUS - File does not exist',//)
9007  FORMAT (/1X,'GPFPUS - Reading error data file in line',I3,//)
9008  FORMAT (A80)

      E N D
