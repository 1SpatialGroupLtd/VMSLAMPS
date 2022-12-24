C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-22 12:26:56.000000000 +0000
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
        INTEGER*4  FUNCTION IFF_NODES()
C
CDEC$	IDENT	'22JA92'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.					  FJB  18-Aug-1989
C
C Transfer junctions in input IFF file (open on lun IFFLUN) to 
C nodes in DLG format
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'
  	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:DLG_DATA.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:MAGBUF.CMN/LIST'
C
C Word:
	INTEGER*2	MM	! temporary/loop variable
	INTEGER*2 	NOVER	! layer number
	INTEGER*2 	NFNUM	! FSN number
	INTEGER*2	NPTS	! number of co-ordinates in point or feature
	INTEGER*2	NARMS	! number of junction arms
	INTEGER*2	IENDS	! pen up/down flag
	INTEGER*2	IECODE	! entry code
	INTEGER*2	IELEN	! return code
	INTEGER*2	JB_OFFSET ! junction offset from JB entry
	INTEGER*2	STRLEN	! output string length
C
C Real:
	REAL		RPOS(2,1) ! coordinates
C
C Longword:
	INTEGER		IFC	! Feature code
	INTEGER		N	! record counter
	INTEGER		J	! AC counter
	INTEGER		CHAR_PAIRS	! character pairs in D1 record
	INTEGER		IERR	! for error return
	INTEGER		IPOSX	! X coord
	INTEGER		IPOSY	! Y coord
	INTEGER		MAJOR_CODE	! AC type number (DLG major code)
	INTEGER		MINOR_CODE	! AC integer value (DLG minor code)
        INTEGER		CODE_ARRAY(MAX_CODES,2)! stores AC type and value
C
	LOGICAL		START_REC	! flag beginning of code record
C
C Functions:
	INTEGER*4	FRTFND		! get FRT parameters for FC
	INTEGER*4	OUTREC		! output data to mag tape
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C ....................................................................
C
C Assume the best
	IFF_NODES=%LOC(SS$_NORMAL)
C
C Initialise
	ELEM_CODE(1:2) = 'N '
	CHAR_PAIRS = 0
C
C .....................................................................
C
C			M A I N   L O O P
C
C Skip through the IFF file using the positions for FS and JB entries
C previously found in s/r IFF_SCAN
C
C
	DO 100,N=1,NODE_COUNT
C
	   J = 0
	   CALL IFFPKE(IECODE,IELEN,NODE_POS(N,1))
	   IF (IELEN.EQ.-1) GOTO 220
C
C ......................................................................
C
C FS - Feature Code
C
	   IF(IECODE .EQ. 'FS')THEN
C
	      CALL EIHRI(IFC,1,1)		! read feature code
C
20	      CALL IFFNXT(IECODE,IELEN)
	      IF (IELEN.EQ.-1) GOTO 220
C
C Get co-ordinates
	      IF((IECODE .EQ. 'ST') .OR. (IECODE .EQ. 'ZS'))THEN
C
C Change address of node to enable IFF_LINES to cross_reference it later
		 NODE_POS(N,1) = LPOSH
C
C Extract node position
		 CALL EIHRS(NPTS,IENDS)
		 IF(NPTS .LT. 1)GOTO 240
		 CALL EIHRR(RPOS,2,1)
		 IPOSX = NINT(RPOS(1,1))
		 IPOSY = NINT(RPOS(2,1))
	         GOTO 20	    
	      ENDIF
C
	      IF(IECODE .EQ. 'AC')THEN
		 CALL EIHR(MAJOR_CODE,1,1)
C
C Is it a point ? if so don't create an attribute
	   	 DO 30, MM=1,NUM_FC_POINT
		    IF (IFC.EQ.POINT_FC(MM)) GOTO 20
30		 CONTINUE
C
		 IF(MAJOR_CODE .GT. 100)THEN
		   CALL EIHRI(MINOR_CODE,1,2)
C
C Remove ACD table ref.
		   MAJOR_CODE = MAJOR_CODE - (MAJOR_CODE/1000 * 1000)
C
C Save codes
		   J = J+1
		   IF(J .GT. MAX_CODES)THEN
		     CALL LSL_PUTMSG(I2DLG__TOOAC,MAJOR_CODE,MINOR_CODE)
		     J = J-1
		     GOTO 20
		   ENDIF
		   CODE_ARRAY(J,1) = MAJOR_CODE
		   CODE_ARRAY(J,2) = MINOR_CODE
C
		 ENDIF
	         GOTO 20			! get next IFF entry
C
	      ENDIF
C
C When end-of-feature found then write out node details
	      IF(IECODE .EQ. 'EF')THEN
	   	 CALL EXPAND('%WS%S2%(5%I6%)',
     &	         	      OUTSTR,
     &		      	      ELEM_CODE,
     &		      	      N,
     &		              IPOSX,
     &		              IPOSY,
     &		              J,
     &		              CHAR_PAIRS)
C
	   	 IF( .NOT. OUTREC(.FALSE.))GOTO 230
C	   
C Now ouput any ACs
5000		 FORMAT(2I6)
		 IF(J .GT. 0)THEN
		    STRLEN = 1
		    DO 3000,MM=1,J
C
C Assemble first pair of codes in record
		       WRITE(OUTSTR(STRLEN:STRLEN+11),5000)
     &				CODE_ARRAY(MM,1),CODE_ARRAY(MM,2)
		       STRLEN = STRLEN + 12
C
C Write out a record of major and minor codes
		       IF((STRLEN .GE. 144) .OR. (MM .EQ. J))THEN
	   	          IF( .NOT. OUTREC(.FALSE.))THEN
			     IFF_NODES=I2DLG__ERROROUT
			     CALL LSL_PUTMSG(IFF_NODES)
			     GOTO 1000
			  ENDIF
			  STRLEN = 1
		       ENDIF
C
3000		    CONTINUE
C
		 ENDIF
C
C Only proper exit from loop (20) is after having written full node record(s)
	         GOTO 100
C
	      ENDIF
C
C Ignore other entries
	      GOTO 20
C
	   ENDIF
C
C ......................................................................
C
C JB - Junction Block
C
	   IF(IECODE .EQ. 'JB')THEN
	      JB_OFFSET = NODE_POS(N,2)    ! INTEGER*2-ize
	      CALL IFJPKJ
     &		(RPOS(1,1),RPOS(2,1),NARMS,NODE_POS(N,1),JB_OFFSET)
	      IF(NARMS .LT. 1)GOTO 100
	      IPOSX = NINT(RPOS(1,1))
	      IPOSY = NINT(RPOS(2,1))
	      J = 0
	      CALL EXPAND('%WS%S2%(5%I6%)',
     &	                  OUTSTR,
     &		          ELEM_CODE,
     &		          N,
     &		          IPOSX,
     &		          IPOSY,
     &			  J,
     &		          CHAR_PAIRS)
C
C And write out a node record
	      IF( .NOT. OUTREC(.FALSE.))GOTO 230
C
	      GOTO 100
C
	   ENDIF
C
C Invalid entry
	   IFF_NODES = .FALSE.
	   GOTO 1000
C
100	CONTINUE
C
C
	GOTO 1000
C
C ......................................................................
C
C			E R R O R S 
C
C Unexpected end of file
220	IFF_NODES=I2DLG__UNEXPEOF
	CALL LSL_PUTMSG(IFF_NODES)
	GOTO 1000
C
C Error writing to ouput file
230	IFF_NODES=I2DLG__ERROROUT
	CALL LSL_PUTMSG(IFF_NODES)
	GOTO 1000
C
C No coords in feature
C
240	IFF_NODES = I2DLG__NOCOORDS
	CALL LSL_PUTMSG(IFF_NODES,NFNUM)
	GOTO 1000
C
C ......................................................................
C
1000	IF (IFF_NODES) IFF_NODES=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
