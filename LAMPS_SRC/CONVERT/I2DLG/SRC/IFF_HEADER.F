        INTEGER*4  FUNCTION IFF_HEADER()
C
CDEC$	IDENT	'12AP94'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C	Created.				  	FJB	07-Sep-1989
CMOD	Initialise B1_REG_POINTS to 4		   	DM	10-Jan-1991
CMOD    Prevent the program crashing by ensuring	ST	12-Apr-1994
C       that ACD_NAME is passed when outputting
C       message UNK0ACNAM. Mod 1356.
C
C Create the initial header records in the DLG file.
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
	INTEGER*2	N,JJ	! temporary/loop variable
	INTEGER*2	CHECK	! temp variable
	INTEGER*2	NARMS	! number of junction arms
	INTEGER*2	IELEN	! length of
	INTEGER*2	IECODE  ! ... current iff entry
	INTEGER*2	NFSN	! FSN of current feature
	INTEGER*2	NOVER	! current layer number
	INTEGER*2	LPOSS	! save current position
	INTEGER*2	MD_VERSION	! Map Descriptor version number
	INTEGER*2	STRLEN	! output string length
C
C Longword:
	INTEGER		IFC	! Feature code
	INTEGER		IFT	! feature type 
	INTEGER		BIFT	! feature type (relevant bytes extracted)
	INTEGER		OK	! error flag
C
C Reals:
	REAL		CP_DATA(4,4) ! corner points
C
C
	LOGICAL		HAD_AC_VALUE	! header AC found
	LOGICAL		HAD_MAP_DESC	! read a valid Map Descriptor
C
C Functions:
	INTEGER*4	OUTREC
	INTEGER*4	ACDFND
	INTEGER*4	STR$CASE_BLIND_COMPARE
	INTEGER*4	LIB$EXTV
C				
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C Arrays for AC data
	INTEGER*2	DLG_AC		! current AC type
C
	INTEGER		HEADER_VALUE(23) ! store AC values
	INTEGER		PLAN_ZONE_CODE	! UTM Zone number
	INTEGER		A4_RESOLUTION
	INTEGER		A4_ACCURACY
	INTEGER		A4_POLYGON_SIDES
	INTEGER		B1_REG_POINTS
	INTEGER		B2_CORNER_COORD(4,2)
	INTEGER		CAT_MAX_NODES
	INTEGER		CAT_MAX_AREAS
	INTEGER		CAT_MAX_LINES
C
	BYTE		T1BUFF(40)	! temporary byte buffer for AC text
	BYTE		T2BUFF(10)	! temporary byte buffer for AC text
	BYTE		FILLER_BUFFER(47)   ! blank filler
	BYTE		T3BUFF(25)	! temporary byte buffer for AC text
C
	CHARACTER*(40)	HEADER_T1                       ! unit name
	CHARACTER*(10)	HEADER_T2                       ! source material
	CHARACTER*(12)	HEADER_NAME(HEADER_DATA_MAX) ! AC name definitions
	CHARACTER*(24)	HEADER_REG(8)			! geog. reg. pts.
	CHARACTER*(24)	HEADER_PROJ(4)			! transform params
	CHARACTER*(2)	B2_CORNER_IDENT(4)
C
	HEADER_NAME(1)  = 'CARTO_UNIT  '
	HEADER_NAME(2)  = 'SOURCE_MATER'
	HEADER_NAME(3)  = 'DATE_QUAL   '
	HEADER_NAME(4)  = 'SOURCE_SCALE'
	HEADER_NAME(5)  = 'QUAD_NUMBER '
	HEADER_NAME(6)  = 'CONT_INT_L  '
	HEADER_NAME(7)  = 'COMMA1      '
	HEADER_NAME(8)  = 'BATHY_INT_L '
	HEADER_NAME(9)  = 'CONT_INT_S  '
	HEADER_NAME(10) = 'COMMA2      '
	HEADER_NAME(11) = 'BATHY_INT_S '
	HEADER_NAME(12) = 'FLAG_A      '
	HEADER_NAME(13) = 'FLAG_B      '
	HEADER_NAME(14) = 'FLAG_C      '
	HEADER_NAME(15) = 'EDGE_FLAG   '
	HEADER_NAME(16) = 'EDGEWS      '
	HEADER_NAME(17) = 'EDGEWR      '
	HEADER_NAME(18) = 'EDGENS      '
	HEADER_NAME(19) = 'EDGENR      '
	HEADER_NAME(20) = 'EDGEES      '
	HEADER_NAME(21) = 'EDGEER      '
	HEADER_NAME(22) = 'EDGESS      '
	HEADER_NAME(23) = 'EDGESR      '
C                                      
	HEADER_NAME(24) = 'REG_SW_LONG '
	HEADER_NAME(25) = 'REG_SW_LAT  '
	HEADER_NAME(26) = 'REG_NW_LONG '
	HEADER_NAME(27) = 'REG_NW_LAT  '
	HEADER_NAME(28) = 'REG_NE_LONG '
	HEADER_NAME(29) = 'REG_NE_LAT  '
	HEADER_NAME(30) = 'REG_SE_LONG '
	HEADER_NAME(31) = 'REG_SE_LAT  '
C
	HEADER_NAME(32) = 'PROJ_A_ONE  '
	HEADER_NAME(33) = 'PROJ_B_TWO  '
	HEADER_NAME(34) = 'PROJ_C_THREE'
	HEADER_NAME(35) = 'PROJ_D_FOUR '
C
	DO 3000, N=1,23
	    HEADER_VALUE(N) = ' '
3000	CONTINUE
	DO 3010, N=1,8
	    HEADER_REG(N) = ' '
3010	CONTINUE
	DO 3020, N=1,4
	    HEADER_PROJ(N) = ' '
3020	CONTINUE
C
	HEADER_T1 = ' '
	HEADER_T2 = ' '
C
	B1_REG_POINTS = 4
C
C ....................................................................
C
C Assume the best
	IFF_HEADER=%LOC(SS$_NORMAL)
	HAD_MAP_DESC = .FALSE.
C
C .....................................................................
C
C Rewind IFF file first
	CALL IFFRWD
C	
10	CALL IFFNXT(IECODE,IELEN)
11	IF (IELEN.EQ.-1) GOTO 220
	IF (IECODE.EQ.'CP') GOTO 20
	IF (IECODE.EQ.'MD') GOTO 30
	IF (IECODE.EQ.'NO') GOTO 40
	IF (IECODE.EQ.'EJ') GOTO 220
	GOTO 10
C
C ....................................................................
C
C CP - Corner points
C
20	CALL EIHRR(CP_DATA,16,1)
C
	GOTO 10
C
C ....................................................................
C
C MD - Map Descriptor
C
30	CALL EIHRI(MD_VERSION,1,1)
	IF(MD_VERSION .NE. 2)THEN
	    IFF_HEADER=I2DLG__UNSETMD2
	    CALL LSL_PUTMSG(IFF_HEADER,MD_VERSION)
	    GOTO 1000
	ENDIF
C
	CALL EIHR(MD2ARR,200,1)
	HAD_MAP_DESC = .TRUE.
C
	GOTO 10
C
C ....................................................................
C
C NO - Overlay
C
40	CALL EIHRI(NOVER,1,1)		! read layer number
C
C Extract Header AC entries from any feature in Overlay 0
	IF(NOVER .EQ. 0)THEN
	   HAD_AC_VALUE = .FALSE.
41	   CALL IFFNXT(IECODE,IELEN)
	   IF (IELEN.EQ.-1) GOTO 220
C
C Extract header details from AC entries
	   IF (IECODE.EQ.'AC') THEN
	      CALL EIHR(DLG_AC,1,1)
C
C Find out details of AC from FRT ACD table
	      IF ( ACDFND(DLG_AC,.TRUE.) ) THEN
	         CALL LSL_PUTMSG(I2DLG__UNKATYP,DLG_AC)
		 GOTO 41
	      ENDIF
C
C Loop to discover which field we've got
	      DO 45,N=1,HEADER_DATA_MAX
	         CHECK=STR$CASE_BLIND_COMPARE(HEADER_NAME(N),
     &					      ACD_NAME) 
	         IF(CHECK .EQ. 0)THEN
		    HAD_AC_VALUE = .TRUE.
		    IF(N .EQ. 1) THEN
			CALL EIHR(T1BUFF,(IELEN-3),4)
			CALL EXPAND('%WS%A40',HEADER_T1,T1BUFF)
			GOTO 41
		    ELSEIF(N .EQ. 2) THEN
			CALL EIHR(T2BUFF,(IELEN-3),4)
			CALL EXPAND('%WS%A10',HEADER_T2,T2BUFF)
			GOTO 41
		    ELSEIF(N .GT. 2 .AND. N .LT. 24)THEN
		        CALL EIHRL(HEADER_VALUE(N),1,2)
			GOTO 41
		    ELSEIF ( N .GT. 23 .AND. N .LT. 32)THEN
		        DO 3030,JJ=1,25
			  T3BUFF(JJ)=' '
3030			CONTINUE
			CALL EIHR(T3BUFF,(IELEN-3),4)
			CALL EXPAND('%WS%A24',HEADER_REG(N-23),T3BUFF)
			GOTO 41
		    ELSEIF ( N .GT. 31 .AND. N .LT. 36)THEN
		        DO 3035,JJ=1,25
			  T3BUFF(JJ)=' '
3035			CONTINUE
			CALL EIHR(T3BUFF,(IELEN-3),4)
			CALL EXPAND('%WS%A24',HEADER_PROJ(N-31),T3BUFF)
			GOTO 41
		    ENDIF
	         ENDIF
45	      CONTINUE
C
	      IF (.NOT. HAD_AC_VALUE) CALL LSL_PUTMSG(I2DLG__UNK0ACNAM,
     &				      ACD_NAME(1:ACD_NAME_LEN))
C
C Look for next AC entry
	      GOTO 41	 
	   ENDIF
C
C Only valid exit from loop is at the end of the layer
	   IF(IECODE .EQ. 'EO') GOTO 200
C
C If we get here then no subsequent layers of data found
	   IF(IECODE .EQ. 'EJ') GOTO 220
C
C Ignore any other entries
	   GOTO 41
C
	ELSE
C
C Not layer 0
	   GOTO 10
	ENDIF
C
   	GOTO 10
C ......................................................................
C
C Come to the end of layer 0 so write header data to tape
C
C Record A1
C
200	CONTINUE
C
	IF( .NOT. HAD_MAP_DESC) THEN
	   IFF_HEADER = I2DLG__NOMD
	   CALL LSL_PUTMSG(IFF_HEADER)
 	   GOTO 1000
 	ENDIF
C 
 	IF( .NOT. HAD_AC_VALUE)THEN
 	   IFF_HEADER = I2DLG__NOACHD
 	   CALL LSL_PUTMSG(IFF_HEADER)
 	   GOTO 1000
 	ENDIF
C 
	HEADER_VALUE(7)= ','
	HEADER_VALUE(10)= ','
C
	DO 3040,N=1,47
	    FILLER_BUFFER(N) = ' '
3040	CONTINUE
C
C Fill buffer
	CALL EXPAND('%WS%S40%A1%S10%A1%I8%A3%A3%A47%(4%A4%A1%)%(11%A1%)',
     &			OUTSTR,
     &			HEADER_T1,
     &			FILLER_BUFFER,
     &			HEADER_T2,
     &			HEADER_VALUE(3),
     &			HEADER_VALUE(4),
     &			FILLER_BUFFER,
     &			HEADER_VALUE(5),
     &			FILLER_BUFFER,
     &			HEADER_VALUE(6),
     &			HEADER_VALUE(7),
     &			HEADER_VALUE(8),
     &			FILLER_BUFFER,
     &			HEADER_VALUE(9),
     &			HEADER_VALUE(10),
     &			HEADER_VALUE(11),
     &			HEADER_VALUE(12),
     &			HEADER_VALUE(13),
     &			HEADER_VALUE(14),
     &			HEADER_VALUE(15),
     &			HEADER_VALUE(16),
     &			HEADER_VALUE(17),
     &			HEADER_VALUE(18),
     &			HEADER_VALUE(19),
     &			HEADER_VALUE(20),
     &			HEADER_VALUE(21),
     &			HEADER_VALUE(22),
     &			HEADER_VALUE(23))
C                       
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record A2
C
	PLAN_ZONE_CODE = MD2PAR(3)
C
C If we have the plan zone code, that's all we need so all the projection
C parameters can be set to zero. If we don't have it then we only need
C parameters 1 & 2.
	IF(PLAN_ZONE_CODE.NE.0)THEN
	  CALL EXPAND('%WS%^L%I6%I6%I6%^D%(5%F24.15%)',
     &			OUTSTR,
     &			LEVEL_CODE,
     &			PLAN_REF_SYSTEM,
     &			PLAN_ZONE_CODE,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0 )
	ELSE
	  CALL EXPAND('%WS%^L%I6%I6%I6%^D%(5%F24.15%)',
     &			OUTSTR,
     &			LEVEL_CODE,
     &			PLAN_REF_SYSTEM,
     &			PLAN_ZONE_CODE,
     &			MD2PAR(1),
     &			MD2PAR(2),
     &			0.0,
     &			0.0,
     &			0.0 )
	ENDIF
C
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record A3
C
	CALL EXPAND('%WS%^D%(6%F24.15%)',
     &			OUTSTR,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0 )
C
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record A4
C
	A4_RESOLUTION = MD2SCL / 1000.0 * 0.02540
	A4_ACCURACY = 0
	A4_POLYGON_SIDES = 4
C
	CALL EXPAND('%WS%^D%(4%F24.15%)%^L%I6%^D%F24.15%^L%I6%I6',
     &			OUTSTR,
     &			0.0,
     &			0.0,
     &			0.0,
     &			0.0,
     &			PLAN_UNITS_CODE,
     &			A4_RESOLUTION,
     &			A4_ACCURACY,
     &			A4_POLYGON_SIDES )
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record A5
C
	CALL EXPAND('%WS%(6%S24%)',
     &			OUTSTR,
     &			HEADER_REG(1),
     &			HEADER_REG(2),
     &			HEADER_REG(3),
     &			HEADER_REG(4),
     &			HEADER_REG(5),
     &			HEADER_REG(6) )
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record A6
C
	CALL EXPAND('%WS%(2%S24%)',
     &			OUTSTR,
     &			HEADER_REG(7),
     &			HEADER_REG(8) )
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record B1
C
	CALL EXPAND('%WS%(4%S24%)%^L%I6',
     &			OUTSTR,
     &			HEADER_PROJ(1),
     &			HEADER_PROJ(2),
     &			HEADER_PROJ(3),
     &			HEADER_PROJ(4),
     &			B1_REG_POINTS )
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record B2
C
	B2_CORNER_IDENT(1) = 'SW'
	B2_CORNER_IDENT(2) = 'NW'
	B2_CORNER_IDENT(3) = 'NE'
	B2_CORNER_IDENT(4) = 'SE'
C
	B2_CORNER_COORD(1,1) = NINT(CP_DATA(1,2))    ! SW X
	B2_CORNER_COORD(1,2) = NINT(CP_DATA(2,2))    ! SW Y
	B2_CORNER_COORD(2,1) = NINT(CP_DATA(1,1))    ! NW X
	B2_CORNER_COORD(2,2) = NINT(CP_DATA(2,1))    ! NW Y
	B2_CORNER_COORD(3,1) = NINT(CP_DATA(1,4))    ! NE X
	B2_CORNER_COORD(3,2) = NINT(CP_DATA(2,4))    ! NE Y
	B2_CORNER_COORD(4,1) = NINT(CP_DATA(1,3))    ! SE X
	B2_CORNER_COORD(4,2) = NINT(CP_DATA(2,3))    ! SE Y
C
	CALL EXPAND('%WS%^L%(4%S2%I6%I6%)',
     &			OUTSTR,
     &			B2_CORNER_IDENT(1),
     &			B2_CORNER_COORD(1,1),
     &			B2_CORNER_COORD(1,2),
     &			B2_CORNER_IDENT(2),
     &			B2_CORNER_COORD(2,1),
     &			B2_CORNER_COORD(2,2),
     &			B2_CORNER_IDENT(3),
     &			B2_CORNER_COORD(3,1),
     &			B2_CORNER_COORD(3,2),
     &			B2_CORNER_IDENT(4),
     &			B2_CORNER_COORD(4,1),
     &			B2_CORNER_COORD(4,2) )
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record C1
C
	CALL EXPAND('%WS%I6',
     &			OUTSTR,
     &			CAT_TOTAL)	
C
C and write it out
	IF( .NOT. OUTREC(.FALSE.) )THEN
	   IFF_HEADER = I2DLG__ERROROUT
	   CALL LSL_PUTMSG(IFF_HEADER)
	   GOTO 1000
	ENDIF
C
C .....................................................................
C
C Record Cn
C
	STRLEN = 1
	CAT_MAX_NODES = 0
	CAT_MAX_AREAS = 0
	CAT_MAX_LINES = 0
5000	FORMAT(A20,6I6)
C
C Total all the nodes, areas and lines
	DO 3050, N=1,CAT_TOTAL
	   CAT_MAX_NODES = CAT_MAX_NODES + CAT_CODE(N,2)
	   CAT_MAX_AREAS = CAT_MAX_AREAS + CAT_CODE(N,3)
	   CAT_MAX_LINES = CAT_MAX_LINES + CAT_CODE(N,4)
3050	CONTINUE
C
C Assemble record
	DO 3060, N=1,CAT_TOTAL
C
	   WRITE(OUTSTR(STRLEN:STRLEN+55),5000)
     &				CATEGORY_NAME(N),
     &				CAT_MAX_NODES,
     &				CAT_CODE(N,2),
     &				CAT_MAX_AREAS,
     &				CAT_CODE(N,3),
     &				CAT_MAX_LINES,
     &				CAT_CODE(N,4) 
C
	   STRLEN = STRLEN + 56
C
C and write it out
	   IF((STRLEN .GE. 112) .OR. (N .EQ. CAT_TOTAL))THEN
	      IF( .NOT. OUTREC(.FALSE.) )THEN
	          IFF_HEADER = I2DLG__ERROROUT
	          CALL LSL_PUTMSG(IFF_HEADER)
	          GOTO 1000
	      ENDIF
	      STRLEN = 1
	   ENDIF
C
3060	CONTINUE
C
	GOTO 1000
C
C .....................................................................
C .....................................................................
C
C			E R R O R S 
C
C Unexpected end of file
220	IFF_HEADER=I2DLG__UNEXPEOF
	CALL LSL_PUTMSG(IFF_HEADER)
	GOTO 1000
C
C ......................................................................
C
1000	IF (IFF_HEADER) IFF_HEADER=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
