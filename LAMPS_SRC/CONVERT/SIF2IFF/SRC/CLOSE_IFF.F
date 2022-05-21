C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-07-02 13:31:00.000000000 +0100
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
        LOGICAL FUNCTION CLOSE_IFF
C
CDEC$	IDENT   '02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	15-Jan-1990
C
C	CONVERT SIF2IFF Utility - Close IFF file
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE '($STSDEF)/NOLIST'
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
	INCLUDE 'CMN:LUN.PAR'		! logical unit numbers
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'		! filenames
	INCLUDE 'CMN:FLAGS.CMN'		! flag variables
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Local Variables
C
	LOGICAL		IFF_ERR		! had IFF error ?
C
C See if we had an IFF error
C
	IFF_ERR = ((IERCD .NE. 0) .OR. (IERNM .NE. 1)) 
C
C Close the output file 
C
	IF (LSL_STATUS) THEN
	   CALL IFFCLO(IFFLUN)
	ELSEIF (DONE_START_MAP) THEN
	   CALL IFFCLO(IFFLUN,LSL_STATUS)
	ELSE
	   CALL IFFCDL(IFFLUN)
	ENDIF
C
C Output an appropriate message
C
	IF (((IERCD .NE. 0) .OR. (IERNM .NE. 1)) .AND. 
     &	    .NOT. IFF_ERR) THEN
	   CALL LSL_PUTMSG(SIF2IFF__IFFCLOERR)
	ELSE 
	   IF (DONE_START_MAP) THEN
	      IF (LSL_STATUS .OR. 
     &	         ((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING))
     &	         THEN
	         IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__IFFCLOSED)
	      ELSE
	         IF (HAD_LOG) CALL LSL_ADDMSG(SIF2IFF__IFFCLOSED)
	      ENDIF
	   ELSE
	      CALL LSL_ADDMSG(SIF2IFF__IFFDELETED)
	   ENDIF
	ENDIF
C
C Assign function value
C
	CLOSE_IFF = ((IERCD .EQ. 0) .AND. (IERNM .EQ. 1))
C
C Return
C
	RETURN
        END
