C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-25 12:29:30.000000000 +0100
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
	LOGICAL FUNCTION OUTREC(FINAL)
C
CDEC$	IDENT	'25OC89'
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
C	Outputs a record consisting of OUTSTR
C
	IMPLICIT NONE
C
C Argument
C
	LOGICAL		FINAL		! .TRUE. if last record output
					! ie flush buffers
C 
C Parameters
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'	! DTI2DEM message definitions
C
C Common block
C
	INCLUDE 	'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE 	'LSL$CMNLSL:MTOVCM.CMN'
C
C Local variables
C
	INTEGER		STATUS
	INTEGER		ERROR
C
C Functions
C
	LOGICAL		MTOWRB
	LOGICAL		FLWSTR
C
C-------------------------------------------------------------------------------
C
   10	FORMAT(A)
C
	IF (ISTAPE) THEN
	   WRITE(OUTBLK(BLKPTR:BLKSIZ),10) OUTSTR
	   BLKPTR=BLKPTR+RECSIZ
	   IF ((BLKPTR.GE.BLKSIZ).OR.FINAL) THEN
	      STATUS = MTOWRB(%REF(OUTBLK),BLKSIZ)
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERRWRTTB,DEVNAM(1:DEVNAML) )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 900
	      ENDIF
C
C Reset output block
C
	      BLKPTR=1
	      OUTBLK=' '
	   ENDIF
	ELSE
	   STATUS = FLWSTR( OUTSTR,ERROR )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DTI2DEM__ERRWRTREC )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( ERROR )
	      GOTO 900
	   ENDIF
	ENDIF
C
	OUTREC=.TRUE.
C
  900	CONTINUE
	RETURN
	END
