C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-11-03 11:47:52.000000000 +0000
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
	LOGICAL FUNCTION WRITE_FEATURE
CDEC$	IDENT	'03NO94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author						ST 03-Nov-1994
C
C       MOD 1421. Call VIOCLR to clear flag arrays to	ST 21-Nov-1994
C	prevent flags of previous feature being carried
C       over onto the current one in RETAIN_FLAGS.
C
C Description:
C       This routine write the IFF entries to form a feature and calls
C       WRITE_CB to write the points.
C
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'	! FRT definitions
C
C common blocks
C
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C Functions
C
	LOGICAL		WRITE_CB
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
	LOGICAL		OK
C
C------------------------------------------------------------------------------
C
	WRITE_FEATURE = .TRUE.
C
	IF (.NOT.DEFAULT_FC) THEN
	   IF (IS_SYMBOL) THEN
	      IF (FRTGT.NE.UNOTYP .AND. FRTGT.NE.ORITYP .AND.
     &		  FRTGT.NE.SCATYP .AND. HAD_LOG)
     &		   	CALL LSL_PUTMSG(MD2I__NOTSYMBFTR,FC,CODENUM)
C
	   ELSE
	      IF (FRTGT.NE.LINTYP .AND. FRTGT.NE.CURTYP .AND.
     &		  FRTGT.NE.STRTYP .AND. FRTGT.NE.ARETYP .AND. 
     &		  HAD_LOG)
     &		  	CALL LSL_PUTMSG(MD2I__NOTLINEFTR,FC,CODENUM)
	   ENDIF
	ENDIF
C
C
C calculate all the bits of the FS entry
C
	ISTAT(1) = FC
	ISTAT(2) = 0
	ISTAT(3) = 0
C
	IF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   ! bits 14-15 = 1 (symbol)
	ENDIF
C
C Set ISQ to 0 to count ISN and start feature
C
	ISQ = 0
	CALL IFFNF(FSN, ISQ)
C
C so write the FS entry
C
	CALL IFFFS( ISTAT )
C
C Write the AC
C
	IF (HAD_AC .AND. TEXT_AC_CODE.GE.0) THEN
	   CALL IFFAC(TEXT_AC_CODE,0,ACBYTE,ACLEN)
	ENDIF
C
C write the CB entry.
C
	WRITE_FEATURE = WRITE_CB()
	IF (.NOT.WRITE_FEATURE) GOTO 999
C
C Output the rotation
C
	IF (IS_SYMBOL .AND. FRTGT.EQ.ORITYP) CALL IFFRO(ROTATE)
C
C Reset the number of point for the next feature
C
	NPTS = 0
C
C End the feature
C
	CALL IFFEF
C
C Clear the FLAGS array for the next feature
C
	CALL VIOCLR(FLAGS,MAXPTS,0)
	CALL VIOCLR(LINE_IN_FLAGS,MAXPTS,0)
	CALL VIOCLR(LINE_OUT_FLAGS,MAXPTS,0)
C
C and that's it
C
999	RETURN
	END
C
