C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-31 10:01:20.000000000 +0000
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
        INTEGER*4  FUNCTION IFF_SCAN()
C
CDEC$	IDENT	'31JA92'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.					  FJB  15-Aug-1989
C
C Read through IFF file to count nodes (junctions and/or point features),
C areas and lines ( line and point features).
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common:
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN/LIST'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN/LIST'
	INCLUDE 'LSL$CMNIFF:IFFJUN.CMN/LIST'
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN/LIST'
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:DLG_DATA.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:MAGBUF.CMN/LIST'
C
C Word:
	INTEGER*2	N,NN,NNN ! temporary/loop variable
	INTEGER*2	CHECK	! temp variable
	INTEGER*2	NARMS	! number of junction arms
	INTEGER*2	IELEN	! length of
	INTEGER*2	IECODE  ! ... current iff entry
	INTEGER*2	NFSN	! FSN of current feature
	INTEGER*2	NOVER	! current layer number
	INTEGER*2	NVERTX	! vertex number
	INTEGER*2	ISN	! sector to be scanned
	INTEGER*2	NPTS	! number of points in line
	INTEGER*2	IENDS	! line start flag
	INTEGER*2	LPOSS	! save current position
	INTEGER*2	MD_VERSION	! Map Descriptor version number
	INTEGER*2	NODE_F_COUNT	! feature node count
	INTEGER*2	NODE_P_COUNT	! point feature count
	INTEGER*2	DLG_AC		! current AC type
	INTEGER*2	OUTSIDE_FSN(32) ! store FSNs of outside area features
	INTEGER*2	SAVE_NODE_COUNT ! save count of nodes temporarily
	INTEGER*2	POSS_NODE_COUNT ! count of possible nodes 
	INTEGER*2	JB_OFFSET ! junction offset
C
C Longword:
	INTEGER		JB_POS  	! junction block position
	INTEGER		FEAT_NODE_COUNT ! count of feature nodes
	INTEGER		IFC	! Feature code
	INTEGER		IFT	! feature type 
	INTEGER		BIFT	! feature type (relevant bytes extracted)
	INTEGER		OK	! error flag
	INTEGER		EO_POS	! end of layer position
	INTEGER		LSTRP	! address of ST
	INTEGER		SAVE_LPOSH	! remember entry-in-hand position
	INTEGER		SAVE_OFFSET	! remember junction offset in JB
	INTEGER		NSTACK(2000) 	! array for sorting use
C
C Reals:
	REAL		CP_DATA(16) ! corner points
	REAL		POSS_NODE_COORD(2) ! possible node coord
	REAL		ACTU_NODE_COORD(2) ! actual node coord
	REAL		TEMPR 		   ! scratch real
	REAL		ACC 		   ! accuracy tolerance
	REAL		R,S 		   ! scratch
C
C
	LOGICAL		HAD_AC_VALUE	! header AC found
	LOGICAL		HAD_MAP_DESC	! read a valid Map Descriptor
	LOGICAL		HAD_CAT_AC	! got a category AC
	LOGICAL		IN_AREA_FEATURE	! got an area feature
	LOGICAL		HAD_JP		! flag reference to Junction Pointer
C
C Functions:
	INTEGER*4	IFF_HEADER
	INTEGER*4	IFF_NODES
	INTEGER*4	IFF_AREAS
	INTEGER*4	IFF_LINES
	INTEGER*4	OUTREC
	INTEGER*4	ACDFND
	INTEGER*4	STR$CASE_BLIND_COMPARE
	INTEGER*4	LIB$EXTV
C				
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
	LOGICAL		JNCTCT
	EXTERNAL	JNCTCT		! count junctions
	LOGICAL		JNCTEX
	EXTERNAL	JNCTEX		! extract junction positions
	INTEGER*4	CF
	EXTERNAL	CF              ! comparison function for sorting
	EXTERNAL	SWAP		! swapping routine for sorting
C
C
C Initialize:
	CAT_TOTAL = 0
	NODE_F_COUNT = 0
	NODE_P_COUNT = 0
	AREA_COUNT = 1
	LINE_COUNT = 0
C
C Blank record buffer
	BLKPTR = 1
	BLKSIZ = 0
	OUTSTR = ' '
	OUTBLK = ' '
C                                              
C ....................................................................
C
C Assume the best
	IFF_SCAN=%LOC(SS$_NORMAL)
C
C .....................................................................
C
C			F I R S T   L O O P
C
C Read the IFF file entry by entry and derive totals.
C
C
C Enable Read Look Ahead
	CALL IFFRLA(.TRUE.)
C
C Rewind IFF file first
	CALL IFFRWD
C
C Log it ?
	IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__INITSCAN)
C	
100	CALL IFFNXT(IECODE,IELEN)
	IF (IELEN.EQ.-1) THEN
	   IFF_SCAN=I2DLG__UNEXPEOF
	   CALL LSL_PUTMSG(IFF_SCAN)
	   GOTO 1000
	ENDIF
	IF (IECODE.EQ.'NO') GOTO 110
	IF (IECODE.EQ.'NF') GOTO 120
	IF (IECODE.EQ.'FS') GOTO 130
	IF (IECODE.EQ.'AC') GOTO 140
	IF (IECODE.EQ.'EO') GOTO 150
	IF (IECODE.EQ.'EJ') GOTO 200
	GOTO 100
C
C
C ....................................................................
C
C NO - Overlay
C
110	CALL EIHRI(NOVER,1,1)		! read layer number
C
C Log it ?
	IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__LAYER,NOVER)
C
C Skip over layer 0
	IF(NOVER .EQ. 0)THEN
	   CALL EIHRL(EO_POS,1,3)
	   IF(EO_POS .GT. 0)THEN
	      CALL IFFPKE(IECODE,IELEN,EO_POS)
	      IF (IELEN.EQ.-1) THEN
	         IFF_SCAN=I2DLG__UNEXPEOF
	         CALL LSL_PUTMSG(IFF_SCAN)
	         GOTO 1000
	      ENDIF
	      GOTO 100
	   ELSE
	      CALL IFFNXC('EO', IELEN)
	      IF (IELEN.EQ.-1) THEN
	         IFF_SCAN=I2DLG__UNEXPEOF
	         CALL LSL_PUTMSG(IFF_SCAN)
	         GOTO 1000
	      ENDIF
	      GOTO 100
	   ENDIF
	ENDIF
C
C Initialise counters
	IF(BY_LAYER)THEN
	   CAT_TOTAL = CAT_TOTAL + 1
	   IF(CAT_TOTAL .GE. 32)THEN
C	         IFF_SCAN = I2DLG__TOOCAT
C	         CALL LSL_PUTMSG(IFF_SCAN)
	         GOTO 1000
	   ENDIF	   
	   CAT_CODE(CAT_TOTAL,5) = LPOSH
	   HAD_CAT_AC = .FALSE.
	   OUTSIDE_FSN(CAT_TOTAL) = 0
	   NODE_F_COUNT = 0
           NODE_P_COUNT = 0
	   LINE_COUNT = 0
	ELSEIF(CAT_TOTAL .EQ. 0)THEN
	   CAT_CODE(1,5)=LPOSH
	   CAT_TOTAL = 1
	ENDIF
C
	GOTO 100
C
C ....................................................................
C
C NF - New Feature
C
120	CALL EIHR(NFSN,1,1)
	GOTO 100
C
C ....................................................................
C
C
C FS - Feature Code
C
130	CALL EIHRI(IFC,1,1)		! read feature code
	CALL EIHRI(IFT,1,3)		! read feature type
	BIFT = LIB$EXTV(14,2,IFT)       ! extract bits for checking
	IN_AREA_FEATURE = .FALSE.
C
C Is it a node ( as defined as features)?
	IF(NUM_FC_NODE .GT. 0)THEN
	   DO 132, N=1,NUM_FC_NODE
	      IF(NODE_FC(N) .EQ. IFC) THEN
		 IF(BIFT .EQ. 1)THEN
		    HAD_JP = .FALSE.
C
C Is it cross-referenced to a Junction Block	
131		    CALL IFFNXT(IECODE,IELEN)
		    IF (IELEN.EQ.-1) THEN
	   	       IFF_SCAN=I2DLG__UNEXPEOF
	   	       CALL LSL_PUTMSG(IFF_SCAN)
	   	       GOTO 1000
		    ENDIF
		    IF (IECODE.EQ.'JP')HAD_JP = .TRUE.
		    IF (IECODE.NE.'EF') GOTO 131
		    IF (HAD_JP)THEN
		       NODE_F_COUNT = NODE_F_COUNT + 1
		    ELSE
		       NODE_P_COUNT = NODE_P_COUNT + 1
		    ENDIF
		    HAD_JP = .FALSE.
		    GOTO 100
		 ELSE
		    CALL LSL_PUTMSG(I2DLG__NOTASYMBN,NFSN)
		    GOTO 100
		 ENDIF
	      ENDIF
132	   CONTINUE
	ENDIF
C
C Is it an area?
	IF(NUM_FC_AREA .GT. 0)THEN
	   DO 134, N=1,NUM_FC_AREA
	      IF(AREA_FC(N) .EQ. IFC) THEN
		 IF(BIFT .EQ. 1)THEN
	            AREA_COUNT = AREA_COUNT + 1
		    IN_AREA_FEATURE = .TRUE.
		    GOTO 100
		 ELSE
		    CALL LSL_PUTMSG(I2DLG__NOTASYMBA,NFSN)
		    GOTO 100
		 ENDIF
	      ENDIF
134	   CONTINUE
	ENDIF
C
C Is it a line?
	IF(NUM_FC_LINE .GT. 0)THEN
	   DO 136, N=1,NUM_FC_LINE
	      IF(LINE_FC(N) .EQ. IFC) THEN
		 IF(BIFT .EQ. 0)THEN
	            LINE_COUNT = LINE_COUNT + 1
		    GOTO 100
		 ELSE
		    CALL LSL_PUTMSG(I2DLG__NOTALINE,NFSN)
		    GOTO 100
		 ENDIF
	      ENDIF
136	   CONTINUE
	ENDIF
C
C Is it a point (degenerate line and assumed node location)?
	IF(NUM_FC_POINT .GT. 0)THEN
	   DO 138, N=1,NUM_FC_POINT
	      IF(POINT_FC(N) .EQ. IFC) THEN
		 IF(BIFT .EQ. 1)THEN
	            LINE_COUNT = LINE_COUNT + 1
		    NODE_P_COUNT = NODE_P_COUNT + 1
		    GOTO 100
		 ELSE
		    CALL LSL_PUTMSG(I2DLG__NOTASYMBP,NFSN)
		    GOTO 100
		 ENDIF
	      ENDIF
138	   CONTINUE
	ENDIF
C
C Ignore unknown feature codes
	GOTO 100
C
C ....................................................................
C
C AC - Ancillary Code
C
140	CALL EIHR(DLG_AC,1,1)            ! read Major Code
C
C Check it is a valid AC
	IF(ACDFND(DLG_AC,.TRUE.))THEN
	   IFF_SCAN = I2DLG__UNKATYP
	   CALL LSL_PUTMSG(IFF_SCAN,DLG_AC)
	   GOTO 1000
	ENDIF
C
C Is this an outside area? - skip ACs
	IF ((ACD_NAME(1:12) .EQ. 'OUTSIDE_AREA'   ) .AND.
     &	    (IN_AREA_FEATURE) ) THEN
	   AREA_COUNT = AREA_COUNT - 1 	! already counted the outside area
	   OUTSIDE_FSN(CAT_TOTAL) = NFSN
	   GOTO 100
	ENDIF
C
C Is this a background area? - skip ACs
	IF (ACD_NAME(1:15) .EQ. 'BACKGROUND_AREA') GOTO 100
C
C Save it
	IF (DLG_AC .GT. 100) THEN
	   IF( .NOT. HAD_CAT_AC)THEN
	      CAT_CODE(CAT_TOTAL,1) = DLG_AC
	      CATEGORY_NAME(CAT_TOTAL) = ACD_NAME(1:20)
C
C Check subsequent ACs are consistent
	   ELSEIF(ACD_NAME(1:4) .NE. CATEGORY_NAME(CAT_TOTAL)(1:4))THEN
	      IFF_SCAN = I2DLG__INVALMAJAC
	      CALL LSL_PUTMSG(IFF_SCAN,DLG_AC,NFSN)
	      GOTO 1000
	   ENDIF
	   HAD_CAT_AC = .TRUE.
	ENDIF
C
	GOTO 100
C
C ....................................................................
C
C EO - End of Overlay
C
C Save counters
150	CAT_CODE(CAT_TOTAL,2) = NODE_P_COUNT + NODE_F_COUNT
	CAT_CODE(CAT_TOTAL,3) = AREA_COUNT
	CAT_CODE(CAT_TOTAL,4) = LINE_COUNT
	CAT_CODE(CAT_TOTAL,6) = LPOSH
C
	GOTO 100
C
C ......................................................................
C
C Scan whole file for Junction Blocks in order to count nodes
200	CONTINUE
	CALL IFFRWD
C
C Log it ?
	IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__JUNCSCAN)
C
C Scan each sector
	IF( IFSHSZ .GT. 0)THEN
	DO 210,ISN=1,IFSHSZ
	   CALL IFJSCN( ISN, JNCTCT )
210	CONTINUE
	ENDIF
C
C ....................................................................
C
C Generate the DLG header blocks
299	CONTINUE
C
C Log it ?
	IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__HEADOUT)
C
	IFF_SCAN = IFF_HEADER() 
	IF( .NOT. IFF_SCAN ) GOTO 1000
C
C ....................................................................
C
C			S E C O N D   L O O P
C
C Read the IFF file layer by layer
C and generate datasets of nodes, areas and lines
C
C
	DO 400,N=1,CAT_TOTAL
C
C Zero counters
	   POSS_NODE_COUNT = 0
	   NODE_COUNT = NODE_COUNT
           AREA_COUNT = 0
	   LINE_COUNT = 0
	   CAT_NUM = N
C
C set accuracy tolerance for comparing equal coordinates
	   ACC = 0.001
C
C Scan whole file for Junction Blocks referencing this layer
C in order to extract locations
	   CALL IFFRWD
C
C Scan each sector
C
C Log it ?
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__JUNCPOS)
	   IF( IFSHSZ .GT. 0)THEN
	      DO 410,ISN=1,IFSHSZ
	         CALL IFJSCN( ISN, JNCTEX )
410	      CONTINUE
	   ENDIF
C
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__AUTONOD,NODE_COUNT)
	   FEAT_NODE_COUNT = NODE_COUNT + 1
C
C
C Get to start of data ( ie beginning of each layer )
	   CALL IFFPKE(IECODE,IELEN,CAT_CODE(N,5))
	   IF (IELEN.EQ.-1) THEN
	      IFF_SCAN=I2DLG__UNEXPEOF
	      CALL LSL_PUTMSG(IFF_SCAN)
	      GOTO 1000
	   ENDIF
       	   IF (IECODE.NE.'NO') THEN
	      IFF_SCAN=I2DLG__UNEXPEOF
	      CALL LSL_PUTMSG(IFF_SCAN)
	      GOTO 1000
	   ENDIF
C
C Define a default outside area as the first area
	   AREA_POS(1,1) = 0
	   AREA_POS(1,2) = 65535
	   AREA_COUNT = AREA_COUNT + 1
	   CAT_CODE(N,3)= AREA_COUNT
C
C......................................................................
C
C Loop through entry by entry
300	   CALL IFFNXT(IECODE,IELEN)
	   IF (IELEN.EQ.-1) THEN
	      IFF_SCAN=I2DLG__UNEXPEOF
	      CALL LSL_PUTMSG(IFF_SCAN)
	      GOTO 1000
	   ENDIF
C
	   IF (IECODE.EQ.'FS') GOTO 310
	   IF (IECODE.EQ.'NF') GOTO 320
	   IF (IECODE.EQ.'EJ' .AND. .NOT. BY_LAYER) GOTO 390
	   IF (IECODE.EQ.'EO' .AND. BY_LAYER) GOTO 390
	   IF (IECODE.EQ.'EJ' .AND. BY_LAYER) GOTO 1000
	   GOTO 300
C          
C ....................................................................
C
C
C FS - Feature Code
C
310	   CALL EIHRI(IFC,1,1)		! read feature code
	   CALL EIHRI(IFT,1,3)		! read feature type
	   BIFT = LIB$EXTV(14,2,IFT)       ! extract bits for checking
C
C Is it a node ( as defined as features)?
	   IF(NUM_FC_NODE .GT. 0)THEN
	      DO 311,NN=1,NUM_FC_NODE
	         IF(NODE_FC(NN) .EQ. IFC) THEN
	            IF(BIFT .EQ. 1)THEN
	               NODE_COUNT = NODE_COUNT + 1
		       NODE_POS(NODE_COUNT,1) = LPOSH
		       NODE_POS(NODE_COUNT,2) = 0
		       CAT_CODE(N,2)= NODE_COUNT
		       GOTO 300
		    ELSE
		       CALL LSL_PUTMSG(I2DLG__NOTASYMBN,NFSN)
		       GOTO 300
		    ENDIF
	         ENDIF
311	      CONTINUE
           ENDIF
C
C Is it an area?
	   IF(NUM_FC_AREA .GT. 0)THEN
	      DO 312, NN=1,NUM_FC_AREA
	         IF(AREA_FC(NN) .EQ. IFC) THEN
	            IF(BIFT .EQ. 1)THEN
		       IF(NFSN .NE. OUTSIDE_FSN(N))THEN
	                  AREA_COUNT = AREA_COUNT + 1
		          AREA_POS(AREA_COUNT,1) = LPOSH
		          AREA_POS(AREA_COUNT,2) = NFSN
		       ELSE
		          AREA_POS(1,1) = LPOSH
		       ENDIF
		       CAT_CODE(N,3)= AREA_COUNT
		       GOTO 300
		    ELSE
		       CALL LSL_PUTMSG(I2DLG__NOTASYMBA,NFSN)
		       GOTO 300
		    ENDIF
	         ENDIF
312	      CONTINUE
	   ENDIF
C
C Is it a line?
	   IF(NUM_FC_LINE .GT. 0)THEN
	      DO 313, NN=1,NUM_FC_LINE
	         IF(LINE_FC(NN) .EQ. IFC) THEN
	            IF(BIFT .EQ. 0)THEN
	               LINE_COUNT = LINE_COUNT + 1
		       LINE_POS(LINE_COUNT,1) = LPOSH
		       LINE_POS(LINE_COUNT,2) = NFSN
		       CAT_CODE(N,4)= LINE_COUNT
		       GOTO 300
		    ELSE
		       CALL LSL_PUTMSG(I2DLG__NOTALINE,NFSN)
		       GOTO 300
		    ENDIF
	         ENDIF
313	      CONTINUE
	   ENDIF
C          
C Is it a point (degenerate line and assumed node location)?
	   IF(NUM_FC_POINT .GT. 0)THEN
	      DO 314, NN=1,NUM_FC_POINT
	         IF(POINT_FC(NN) .EQ. IFC) THEN      ! valid FC
	            IF(BIFT .EQ. 1)THEN              ! is an IFF point feature
C
C Count a line 
	               LINE_COUNT = LINE_COUNT + 1
		       LINE_POS(LINE_COUNT,1) = LPOSH
		       LINE_POS(LINE_COUNT,2) = NFSN
		       CAT_CODE(N,4)= LINE_COUNT
C
C See if any other nodes point to the same JB entry.
		       SAVE_LPOSH = LPOSH
	      	       CALL IFFNXC('JP', IELEN)
		       CALL EIHRL(JB_POS,1,1)
		       CALL EIHRI(JB_OFFSET,1,3)
	               CALL IFJPKJ(TEMPR,TEMPR,NARMS,JB_POS,JB_OFFSET)
C
C if not then put node in node list 
		       IF (NARMS.EQ.1) THEN
		 	  NODE_COUNT = NODE_COUNT + 1
		 	  NODE_POS(NODE_COUNT,1) = SAVE_LPOSH
		 	  NODE_POS(NODE_COUNT,2) = -1
		 	  CAT_CODE(N,2) = NODE_COUNT
		       ELSE
C                   
C otherwise buffer up node as a possible.
		          POSS_NODE_COUNT = POSS_NODE_COUNT + 1
		          POSS_NODE_POS(POSS_NODE_COUNT,1) = SAVE_LPOSH
		          POSS_NODE_POS(POSS_NODE_COUNT,2) = -1
		       ENDIF
	      	       CALL IFFPKE(IECODE,IELEN,SAVE_LPOSH)
		       GOTO 300
		    ELSE
		       CALL LSL_PUTMSG(I2DLG__NOTASYMBP,NFSN)
		       GOTO 300
		    ENDIF
	         ENDIF
314	      CONTINUE
	   ENDIF
C             
C Ignore unknown feature codes
	   GOTO 300
C          
C ....................................................................
C
C NF - New Feature
C
320	   CALL EIHR(NFSN,1,1)
	   GOTO 300
C
C .....................................................................
C
C EO - End of Overlay 
C      Output a dataset
C
390	   CONTINUE
C
C for each possible auto node check actual node list for existing node
C at same (x,y). If not then we can add it to the actual node list.
	   SAVE_NODE_COUNT = NODE_COUNT
	   DO 391 NN = 1,POSS_NODE_COUNT
	      CALL IFFPKE(IECODE,IELEN,POSS_NODE_POS(NN,1))
	      IF (IELEN.EQ.-1) THEN
	         IFF_SCAN=I2DLG__UNEXPEOF
	         CALL LSL_PUTMSG(IFF_SCAN)
	         GOTO 1000
	      ENDIF
	      CALL IFFNXC('ST', IELEN)
	      CALL EIHRR(POSS_NODE_COORD,2,1)
	      DO 392 NNN  = FEAT_NODE_COUNT,SAVE_NODE_COUNT
	         CALL IFFPKE(IECODE,IELEN,NODE_POS(NNN,1))
	         IF (IELEN.EQ.-1) THEN
	            IFF_SCAN=I2DLG__UNEXPEOF
	            CALL LSL_PUTMSG(IFF_SCAN)
	            GOTO 1000
	         ENDIF
	         CALL IFFNXC('ST', IELEN)
	         CALL EIHRR(ACTU_NODE_COORD,2,1)
		 R = ABS(POSS_NODE_COORD(1)-ACTU_NODE_COORD(1))
		 S = ABS(POSS_NODE_COORD(2)-ACTU_NODE_COORD(2))
		 IF ((R.LT.ACC).AND.(S.LT.ACC)) THEN
		    GOTO 391
		 ENDIF
392	      CONTINUE
		 NODE_COUNT = NODE_COUNT + 1
		 NODE_POS(NODE_COUNT,1) = POSS_NODE_POS(NN,1)
		 NODE_POS(NODE_COUNT,2) = POSS_NODE_POS(NN,2)
		 CAT_CODE(N,2)= NODE_COUNT
391	   CONTINUE
C
C Write nodes
   	   IF (NODE_COUNT .GT. 0) THEN
C
C Sort nodes into ascending order of IFF file address
C for searching for node number when outputting line records
	      CALL QUICK_SORT( NODE_POS, NODE_COUNT, CF, SWAP, NSTACK)
C
C Log it ?
	      IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__NODEOUT)
	      IFF_SCAN = IFF_NODES()
	      IF( .NOT. IFF_SCAN)GOTO 1000
	   ENDIF
C
C Write areas
	   IF (AREA_COUNT .GT. 0) THEN
C
C Log it ?
	      IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__AREAOUT)
	      IFF_SCAN = IFF_AREAS()
	      IF( .NOT. IFF_SCAN)GOTO 1000
	   ENDIF
C
C Write lines
	   IF (LINE_COUNT .GT. 0) THEN
C
C Log it ?
	      IF (HAD_LOG) CALL LSL_PUTMSG(I2DLG__LINEOUT)
	      IFF_SCAN = IFF_LINES()
	      IF( .NOT. IFF_SCAN)GOTO 1000
	   ENDIF
C             
400	CONTINUE
C
C ......................................................................
C
1000	IF (IFF_SCAN) IFF_SCAN=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
