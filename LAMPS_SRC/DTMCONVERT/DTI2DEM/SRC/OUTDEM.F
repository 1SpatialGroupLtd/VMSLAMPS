C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-26 15:26:08.000000000 +0100
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
	LOGICAL FUNCTION OUTDEM
C
CDEC$	IDENT	'26OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	27-Jan-1986
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	Outputs body of DEM
C
	IMPLICIT NONE
C
C Common blocks
C	
        INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
        INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:CLD.CMN'
C
C Functions
C
	LOGICAL		OUTREC
	LOGICAL		DTI_READ_DATA	! Read datum from DTI
C
C Local variables
C
	INTEGER		STATUS
	INTEGER		I,J,M
	INTEGER		STRPTR		! pointer into string
	INTEGER*2	HEIGHT
C
C Data for record B header
C
	INTEGER*2	ROWCOLN(2)	! row and column number
	INTEGER*2	ROWCOLC(2)	! number of rows and columns
	REAL*8		PLANORG(2)	! UTM coord of first point
	REAL*8		HEIGHTORG	! local height elevation
	REAL*8		ZRANGE(2)	! range of heights in this col
C
	DATA		ROWCOLN(1)/1/	! always set to 1
	DATA		ROWCOLC(2)/1/	! only 1 column per B record
	DATA		HEIGHTORG/0.0D0/! no height offset at present
C
C-------------------------------------------------------------------------------
C
C Write out a reassuring message
C
	IF (ISTAPE) THEN
	   CALL WRITEF('Outputting DEM file to %S',DEVNAM(1:DEVNAML))
	ELSE
	   CALL WRITEF('Outputting DEM file to %S',
     &	                     FILARY(1)(1:FIL_LEN(1)))
	ENDIF
	CALL WRITEF(' ')
C
C Output each record of DEM in turn
C
	DO 100, I=FSTCOL,LSTCOL
C
C More reassurance
C
	   IF (MOD(I-FSTCOL+1,50).EQ.0) THEN
	      CALL WRITEF('...record #%I0',I-FSTCOL+1)
	   ENDIF
C
C Initialise header
C
	   ROWCOLN(2)=I-FSTCOL+1
	   ROWCOLC(1)=COLLST(I)-COLFST(I)+1
	   PLANORG(1)=ORIGIN(1)+(I-1)*DEMDELX
	   PLANORG(2)=ORIGIN(2)+(COLFST(I)-1)*DEMDELY
	   ZRANGE(1)=COLMIN(I)
	   ZRANGE(2)=COLMAX(I)
C
C and write it to output string
C
	   OUTSTR=' '			! fill with spaces
   10	   FORMAT(4I6,5D24.15)
	   WRITE(OUTSTR,10) ROWCOLN,ROWCOLC,PLANORG,HEIGHTORG,ZRANGE
	   STRPTR=145
C
C Now write out the heights for this column
C
	   DO 50, J=COLFST(I),COLLST(I)
C
C Output OUTSTR, if it is full
C
	      IF ((STRPTR+6).GT.RECSIZ) THEN
	         OUTDEM=OUTREC(.FALSE.)
	         IF (.NOT.OUTDEM) GOTO 900
C
C and initialise it again
C
	         OUTSTR=' '
	         STRPTR=1
	      ENDIF
C
C Get height of this point, and output it
C
	      STATUS = DTI_READ_DATA( INLUN,HEIGHT,I,J )
   20	      FORMAT(I6)
	      WRITE(OUTSTR(STRPTR:RECSIZ),20) HEIGHT
C
C Update pointer into OUTSTR
C
	      STRPTR=STRPTR+6
   50	   CONTINUE
C
C Output final record
C
	   IF (I.NE.LSTCOL) THEN
	      OUTDEM=OUTREC(.FALSE.)		! output this record
	   ELSE
	      OUTDEM=OUTREC(.TRUE.)
	   ENDIF
	   IF (.NOT.OUTDEM) GOTO 900		! flush outblk
  100	CONTINUE
C
	OUTDEM=.TRUE.
C
  900	CONTINUE
	RETURN
	END
