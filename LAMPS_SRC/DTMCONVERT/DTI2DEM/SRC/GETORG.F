C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-11-01 10:07:50.000000000 +0000
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
	LOGICAL FUNCTION GETORG
C
CDEC$	IDENT	'25OC89'
C
C 	Copyright 			Laser-Scan Ltd., Cambridge, England
C
C 	Created			 			RWR   	24-Jan-1989
C
C	Modified					APB	19-Oct-1989
C	
C		Updated to use LSLIB, DTILIB and standard messages
C
C Description:
C 
C	Checks geometry of DTI, and gets its origin (in UTM coordinates)
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE		'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE		'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE		'($RMSDEF)'
C
C Common blocks
C
    	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE 	'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNDTI:DTIHDR.CMN'		! DTI header 
C
C Functions
C
	INTEGER		TTRSTR
	INTEGER		RDDBLE
C
C Local variables
C
	INTEGER		DTITYP		! type of DTI file
	INTEGER		NUMCH		
	LOGICAL		STATUS
	INTEGER		SPACING
C
C-------------------------------------------------------------------------------
C
	GETORG = .FALSE.
C
C Check for correct spacing
C
	IF (.NOT.PLNMET) THEN
	   X_GRID(INLUN) = X_GRID(INLUN)*F2M
	   Y_GRID(INLUN) = Y_GRID(INLUN)*F2M
	ENDIF
	IF (X_GRID(INLUN).NE.DEMDELX.OR.Y_GRID(INLUN).NE.DEMDELY) THEN
	   CALL LSL_PUTMSG( DTI2DEM__INCGRDSPC,
     &                      X_GRID(INLUN),Y_GRID(INLUN) )
	   CALL LSL_ADDMSG( DTI2DEM__DEMGRD,DEMDELX,DEMDELY )
	   GOTO 999
	ENDIF
C
C Get origin of this DTI
C
	CALL WRITEF('Define origin of the DTI (in UTM coordinates) '//
     &	            '(default: %F0.3 %F0.3)',
     &               X_OFFSET(INLUN),Y_OFFSET(INLUN) )

   10	STATUS=TTRSTR(,NUMCH,'Eastings Northings : ',GETORG)
	IF (.NOT.STATUS) THEN			!  error
	   IF (GETORG.NE.RMS$_EOF) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADORG )
	      CALL LSL_ADDMSG(GETORG)
	   ENDIF
	   GOTO 999
	ELSEIF ( STATUS .AND. NUMCH.EQ.0 ) THEN
	   ORIGIN(1) = X_OFFSET(INLUN)
	   ORIGIN(2) = Y_OFFSET(INLUN)
	   GOTO 30	   
	ENDIF
C
C Read real number from TXTBUF
C
	CALL BSLN
	IF (RDDBLE(ORIGIN(1))) THEN
	   CALL LSL_PUTMSG( DTI2DEM__ERRDNUM )
	   GOTO 10
	ENDIF	

	SPACING = ORIGIN(1)/DEMDELX
	IF (SPACING*DEMDELX.NE.ORIGIN(1)) THEN
	   CALL LSL_PUTMSG( DTI2DEM__NOTGRID,ORIGIN(1) )
	   GOTO 10
	ENDIF
	IF (.NOT.RDDBLE(ORIGIN(2))) GOTO 25 ! check for both on one line
C
   20	STATUS=TTRSTR(,NUMCH,'Northings : ',GETORG)
	IF (NUMCH.EQ.0) GOTO 20			! blank line
	IF (.NOT.STATUS) THEN			!  error
	   IF (GETORG.NE.RMS$_EOF) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADORG )
	      CALL LSL_ADDMSG(GETORG)
	   ENDIF
	   GOTO 999
	ENDIF
C
	CALL BSLN
	IF (RDDBLE(ORIGIN(2))) THEN
	   CALL LSL_PUTMSG( DTI2DEM__ERRDNUM )
	   GOTO 20
	ENDIF	
C
   25	CONTINUE
	SPACING = ORIGIN(2)/DEMDELX
	IF (SPACING*DEMDELX.NE.ORIGIN(2)) THEN
	   CALL LSL_PUTMSG( DTI2DEM__NOTGRID,ORIGIN(2) )
	   GOTO 20
	ENDIF
C
C Work out extent of DTI
C
30	CONTINUE
	NCOL = X_EXTENT(INLUN)
	NROW = Y_EXTENT(INLUN)
	DTIUR(1)=ORIGIN(1)+(NCOL-1)*X_GRID(INLUN)
	DTIUR(2)=ORIGIN(2)+(NROW-1)*Y_GRID(INLUN)
C
	GETORG=.TRUE.
C
  999	CONTINUE
	RETURN
	END
