/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-10-27 19:35:10.000000000 +0100
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
	SUBROUTINE READ_TAPE
C
CDEC$	IDENT	'04MY90'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					22-Jan-1990	J.M. Cadogan
C
C Description:
C
C	Read tape in SIF format onto disk for convertion to IFF
C
	IMPLICIT	NONE
C
	INCLUDE	'CMN:LUN.PAR'		! UNIT numbers
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
C
	INCLUDE 'CMN:FILES.CMN'		! file names
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
C
	INTEGER		STATUS
	INTEGER*2	BLKSIZ
	PARAMETER	(BLKSIZ=1024)
	INTEGER		RECLEN
	CHARACTER*72	RECORD
	CHARACTER*143	HEADER1
	CHARACTER*216	HEADER2
	BYTE		MTBUF( BLKSIZ )	! Tape buffer
	INTEGER		MTBYTES		! No. of bytes read from tape
	INTEGER*2	IREC	
	INTEGER*2	NUMBLK
	INTEGER*2	START,END
	INTEGER*2	RECSIZ
	INTEGER*2	I
C
C Functions called
C
	LOGICAL		MTINIT
	LOGICAL		MTIRDB		! Read from magtape
	LOGICAL		MTIBCK		! Backspace one block on tape
	INTEGER		READSTR
	INTEGER		RDCHS
	INTEGER		FLWSTR
	INTEGER		FLWOPN
	INTEGER		FLWSEL
	INTEGER		FLWCLO
	
C
	DATA	RECSIZ	/ 72 /
C
C-------------------------------------------------------------------------------
C
C Initialize tape
C
	STATUS = MTINIT( TAPEDEV(1:TAPEDEVLEN), .FALSE., )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   GOTO 999
	ENDIF
C
	IF (HAD_CCG) THEN
	   IF (HAD_CELL) THEN
C	      STATUS = FLWOPN(CELLLUN,CELLFIL,,143)
	      OPEN( CELLLUN,FILE=CELLFIL,FORM='FORMATTED',STATUS='NEW',
     &		RECL=143 )
	   ENDIF
C	   STATUS = FLWOPN(SIFLUN,SIFFIL(1:SIFLEN),,216)
	   OPEN( SIFLUN,FILE=SIFFIL(1:SIFLEN),FORM='FORMATTED',STATUS='NEW',
     &		RECL=216 )
	ELSE
C	   STATUS = FLWOPN(SIFLUN,SIFFIL(1:SIFLEN),,80)
	   OPEN( SIFLUN,FILE=SIFFIL(1:SIFLEN),FORM='FORMATTED',STATUS='NEW',
     &		RECL=80 )
	ENDIF
C
	NUMBLK = 0
C
C Read blocks from tape for CELL file if tape is from CCG
C and has a CELL file before the SIF command file
C
	IF (HAD_CCG.AND.HAD_CELL) THEN
C	   STATUS = FLWSEL(CELLLUN)
50	   CONTINUE
	   STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF ( STATUS.EQ.LSL__EOF ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 900
	   ELSEIF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 999
	   ENDIF
	   NUMBLK = NUMBLK + 1
	   CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read from
	   IF (NUMBLK.EQ.1) THEN
	      CALL SET_TXTLIM( 143 )	
	      RECLEN = READSTR( HEADER1 )
C	      STATUS = FLWSTR(HEADER1)
	      WRITE( CELLLUN,500 ) HEADER1
	      START = 2
	      END = 14
	      CALL SET_TXTLIM( RECSIZ )	
	   ELSE
	      CALL SET_TXTLIM( RECSIZ )	
	      START = 1
	      END = 14
	   ENDIF
	   DO 100 IREC = START, END
	      RECLEN = READSTR( RECORD )
	      IF (RECORD(RECSIZ:RECSIZ).EQ.'/') THEN
	         RECLEN = 68
	         DO 90 I = 1, 4
	            CALL BSCH
90	         CONTINUE
	      ENDIF
C	      IF (RECLEN.GT.0) STATUS = FLWSTR (RECORD(1:RECLEN))
	      IF (RECLEN.GT.0) WRITE( CELLLUN,500 ) RECORD(1:RECLEN)
C	      WRITE( *,501 ) RECORD(1:RECLEN)
	      WRITE( *,502 ) NUMBLK
100	   CONTINUE
	   GOTO 50
	ENDIF
C
500	FORMAT(1X,A<RECLEN>)
501	FORMAT(1X,A<RECLEN>)
502	FORMAT('+','Reading block #',I5 )
C
900	CONTINUE
C	PRINT *
C	PRINT *, 'End of file detected at block #',NUMBLK
C	PRINT *
C
C Read blocks from tape for SIF command file
C
	NUMBLK = 0
C	STATUS = FLWSEL(SIFLUN)
950	CONTINUE
	STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	IF ( STATUS.EQ.LSL__EOF ) THEN
	   GOTO 990
	ELSEIF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   GOTO 999
	ENDIF
	NUMBLK = NUMBLK + 1
	CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read from
	IF ((HAD_CCG).AND.(NUMBLK.EQ.1)) THEN
	   CALL SET_TXTLIM(216)	
	   RECLEN = READSTR( HEADER2 )
C	   STATUS = FLWSTR(HEADER2)
	   WRITE( SIFLUN,500 ) HEADER2
	   START = 2
	   END = 14
	   CALL SET_TXTLIM( RECSIZ )	
	ELSE
	   CALL SET_TXTLIM( RECSIZ )	
	   START = 1
	   END = 14
	ENDIF
	DO 200 IREC = START, END
	   RECLEN = READSTR( RECORD,,,.FALSE. )
C	   STATUS = FLWSTR(RECORD(1:RECLEN))
	   IF (RECLEN.GT.0) WRITE( SIFLUN,500 ) RECORD(1:RECLEN)
C	   WRITE( *,501 ) RECORD(1:RECLEN)
	   WRITE( *,502 ) NUMBLK
200	CONTINUE
	GOTO 950
C
990	CONTINUE
	PRINT *
	PRINT *,'End of file detected at block #',NUMBLK
	PRINT *
C
999	CONTINUE
C	STATUS = FLWCLO(CELLLUN)
C	STATUS = FLWCLO(SIFLUN)
	IF (HAD_CELL) CLOSE(UNIT=CELLLUN)
	CLOSE(UNIT=SIFLUN)
C
	END
