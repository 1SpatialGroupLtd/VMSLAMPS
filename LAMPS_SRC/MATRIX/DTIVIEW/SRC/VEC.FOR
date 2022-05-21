C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 19:33:12.000000000 +0000
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
	SUBROUTINE ADDNOD(X, Y)
	IMPLICIT NONE
	REAL		X, Y		! the coordinate pair
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	HORPT1 = HORPT1+1
	HORIZN(HORPTX, HORPT1) = X
	HORIZN(HORPTY, HORPT1) = Y
	RETURN
	END

	SUBROUTINE NXTNOD
	IMPLICIT NONE
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	IF (.NOT.HORADV) THEN		! not
	   CALL ADDNOD(OLDX1, OLDY1)
	   HORADV = .TRUE.
	ENDIF
	OLDX1 = OLDX2
	OLDY1 = OLDY2
	HOREMP = HOREMP+1
	IF (NDCOPY) THEN
	   CALL ADDNOD(OLDX1, OLDY1)	! copy it
	ELSE
	   NDCOPY = .TRUE.		! copy next one, anyway
	ENDIF
	IF (HOREMP.GT.HORPT2) THEN
	   DANGLE = 1			! reached end of old horizon
	ELSE
	   OLDX2 = HORIZN(OLDPTX, HOREMP)
	   OLDY2 = HORIZN(OLDPTY, HOREMP)
	ENDIF
	RETURN
	END

	INTEGER FUNCTION ICOL(HGT)
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*2	HGT			! a DTI height
	INTEGER*4	I			! loop counter
	IF(BATH)THEN				! bathymetry colour
	  IF (HGT.LT.ZLOWER.OR.HGT.GT.ZUPPER)THEN
	     ICOL=1				!white
	     GOTO 999
	  ENDIF
	  IF(HGT.GT.0)THEN			! land
	    ICOL=2				! brown	in special colour
	    GOTO 999				! table
	  ENDIF
	  DO 100 I=1,STEPS			! test which colour band
	     IF(HGT.GE.HGTSTP(1,I))THEN
	       ICOL=HGTSTP(2,I)
	       GOTO 999
	     ENDIF
100	  CONTINUE
	  ICOL = 14				! just in case
	  
	  GOTO 999
	ENDIF
	IF (HGT.LT.ZLOWER.OR.HGT.GT.ZUPPER)THEN
	   ICOL=1		!white
	   GOTO 999
	ENDIF
	IF (HGT.LE.0)THEN
	   ICOL=2
	   GOTO 999
	ENDIF
	IF (DTICOL) THEN
	  ICOL = ((((HGT-MAX(1,MIN_WVALUE(1)))/STPINT)*CSTEP)+2)
	ELSE
	  ICOL = ((((HGT-MAX(1,MODMIN))/STPINT)*CSTEP)+2)
	ENDIF
	IF (ICOL.GT.MAXCOL)THEN
            ICOL = MAXCOL
	    GOTO 999
	ENDIF
	IF (ICOL.LT.3) ICOL = 3			! lowest land colour
999	RETURN
	END

	SUBROUTINE SETCOL
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER	HMIN		! height minimum
	INTEGER HRANGE		! height range
	HRANGE=ZUPPER-ZLOWER
	HMIN=MIN(1,ZLOWER)
	IF (HADSTP) THEN
	   IF(BATH)THEN
	      CALL SEASET
	   ELSE
	      STEPS = HRANGE/STPINT
	      STEPS = MAX(1,STEPS)
	      IF (STEPS*STPINT.LT.HRANGE) STEPS = STEPS+1
	      IF (STEPS.GE.MAXCOL) THEN
	         CALL WRITEF('Heights above %N will appear in white',
     &					STPINT*MAXCOL+HMIN)
	         ZUPPER = STPINT*MAXCOL+HMIN
	         STEPS = MAXCOL
	      ENDIF
	   ENDIF
	ELSE
	   IF(BATH)THEN
	      CALL SEASET
	   ELSE
	      STPINT = HRANGE/STEPS
	      STPINT = MAX(1,STPINT)
	      IF (STEPS*STPINT.LT.HRANGE) STPINT = STPINT+1
	   ENDIF
	ENDIF
	RETURN
	END

	SUBROUTINE CORDTF(X,Y,Z, XX,YY)
	IMPLICIT NONE
	REAL		X, Y, Z		! coordinate in model space
	REAL		XX, YY		! (returned) coordinate in view
	REAL		ZZZ		! perspective intermediary
	REAL		PROJF		! projection factor
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	IF (PRSPVW) THEN		! perspective view
	   ZZZ = Z*A2-X*A1		!  - rotate and -
	   PROJF = DIST/(DOV+Z0-ZZZ)
	   XX = (X*A2+Z*A1)*PROJF	!     project
	   YY = (Y-HOV)*PROJF
	ELSE				! isometric view
	   XX = A11*X+A13*Z		!  - simply rotate
	   YY = A21*X+A22*Y+A23*Z	!    (perhaps not so simply!)
	ENDIF
	IF (XX.LT.VWMINX) VWMINX = XX
	IF (XX.GT.VWMAXX) VWMAXX = XX
	IF (YY.LT.VWMINY) VWMINY = YY
	IF (YY.GT.VWMAXY) VWMAXY = YY
	RETURN
	END

	SUBROUTINE HORINI
	IMPLICIT NONE
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	HORPT1 = 0
	HORPT2 = 0
	HORPTX = 1
	HORPTY = 2
	RETURN
	END

	SUBROUTINE HORINT(X, Y,  MASKX, MASKY)
	IMPLICIT NONE
	REAL		X, Y		! other end of vector starting
	REAL		MASKX,MASKY	! intersection (masking point)
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	REAL		DXN, DYN	! ) vector
	REAL		DXO, DYO	! )  components
	REAL		XPN, XPO	! cross products
	REAL		XPD		! denominator
	DXN = X-NEWX1
	DYN = Y-NEWY1
	DXO = OLDX2-OLDX1
	DYO = OLDY2-OLDY1
	XPN = NEWY1*X-NEWX1*Y
	XPO = OLDY1*OLDX2-OLDX1*OLDY2
	XPD = DXO*DYN-DXN*DYO
	MASKX = (XPO*DXN-XPN*DXO)/XPD
	MASKY = (XPO*DYN-XPN*DYO)/XPD
	CALL ADDNOD(MASKX, MASKY)
	RETURN
	END
	SUBROUTINE HORVIN(X, Y)
	IMPLICIT NONE
	REAL		X, Y		! coord of start of horizon
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	REAL		MASKY		! masking Y-value
	IF (HORPT1.EQ.0) THEN
	   INIHOR = .TRUE.		! mark initialising
	   CALL ADDNOD(X, Y)		! set up first node
	   CALL G3MVTO(X, Y)		! position ourselves
	   MASKED = 0			! on horizon?
	   RETURN			! and we're done
	ENDIF
	IF (DANGLE.EQ.0 .AND. .NOT.INIHOR)
     &		CALL ADDNOD(OLDX2, OLDY2)
	INIHOR = .FALSE.
	NDCOPY = .TRUE.
	NEWX1 = X
	NEWY1 = Y
	OLDPTX = HORPTX
	OLDPTY = HORPTY
	HORPTX = 4-HORPTX
	HORPTY = HORPTX+1
	HORPT2 = HORPT1
	HORPT1 = 0
	HOREMP = 2
	OLDX1  = HORIZN(OLDPTX,1)
	OLDY1  = HORIZN(OLDPTY,1)
	OLDX2  = HORIZN(OLDPTX,2)
	OLDY2  = HORIZN(OLDPTY,2)
	IF (OLDX1.GT.NEWX1) THEN	! not
	   CALL ADDNOD(NEWX1, NEWY1)
	   CALL G3MVTO(NEWX1, NEWY1)
	   DANGLE = -1			! mark state
	   RETURN
	ENDIF
	DANGLE = 0			! record the fact
	HORADV = .FALSE.		! not moved yet
10	IF (NEWX1.GE.OLDX2) THEN	! we are
	   CALL NXTNOD			! (sets DANGLE)
	   IF (DANGLE.GT.0) THEN	! end of 'old' horizon
	      CALL G3MVTO(NEWX1, NEWY1)
	      CALL ADDNOD(NEWX1, NEWY1)
	      RETURN
	   ELSE
	   GOTO 10			! i.e. DO WHILE
	   ENDIF
	ENDIF
	IF (NEWX1.EQ.OLDX1) THEN
	   IF (NEWY1.LT.OLDY1) THEN	! below horizon
	      MASKED = -1		! mark,
	      IF (.NOT.HORADV)
     &		   CALL ADDNOD(OLDX1, OLDY1) ! 'advance' horizon
	      HORADV = .TRUE.		!   ...and...
	      RETURN			! 	we're done
	   ENDIF
	   IF (NEWY1.GT.OLDY1) THEN	! above horizon
	      MASKED = 1		! mark, and
	   ELSE				! on horizon
	      MASKED = 0		! mark
	   ENDIF
	   CALL ADDNOD(OLDX1, NEWY1)	! make new horizon entry
	   HORADV = .TRUE.
	   CALL G3MVTO(OLDX1, NEWY1)	! get to new position,
	   RETURN			! and exit
	ENDIF
	IF (.NOT.HORADV) CALL ADDNOD(OLDX1, OLDY1)
	HORADV = .TRUE.
	MASKY = OLDY1 + (OLDY2-OLDY1)*(NEWX1-OLDX1)/(OLDX2-OLDX1)
	IF (MASKY.LE.NEWY1) THEN	! above or on horizon
	   IF (MASKY.EQ.NEWY1) THEN
	      MASKED = 0		! on horizon
	   ELSE
	      MASKED = 1		! above it
	   ENDIF
	   CALL ADDNOD(NEWX1, NEWY1)
	   CALL G3MVTO(NEWX1, NEWY1)
	ELSE				! below horizon
	   MASKED = -1
	ENDIF
	RETURN
	END

	SUBROUTINE HORVNX(X, Y)
	IMPLICIT NONE
	REAL		X, Y		! the coords of the point to add
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	REAL		MASKX, MASKY	! coordinates of mask point, etc
	REAL		SAVX, SAVY	! as you'ld expect
	IF (INIHOR) THEN		! easy
	   CALL ADDNOD(X, Y)
	   CALL G3LNTO(X, Y)
	   MASKED = 0			!above horizon?
	   RETURN
	ENDIF
	IF (DANGLE) 10,90,70
10	IF (OLDX1-X) 20,30,70
20	MASKY = NEWY1 + (OLDX1-NEWX1)*(Y-NEWY1)/(X-NEWX1)
	IF (MASKY.GE.OLDY1) THEN	! we're raising the horizon
	   HORADV = .TRUE.		! not to copy old l.h. extreme
	   IF (MASKY.EQ.OLDY1) THEN
	      MASKED = 0		! actually on horizon
	   ELSE
	      MASKED = 1		! above horizon
	   ENDIF
	ELSE				! burrowing in under
	   CALL G3LNTO(OLDX1, MASKY)	! join edge to mask
	   MASKED = -1			! below horizon
	ENDIF
	DANGLE = 0			! no longer dangling
	GOTO 90				! join normal route
30	NEWX1 = X
	NEWY1 = Y
	DANGLE = 0
	IF (OLDY1-Y) 40,50,60
40	MASKED = 1
	HORADV = .TRUE.			! don't copy old l.h. extreme
	GOTO 75
50	MASKED = 0
	GOTO 80
60	MASKED = -1
	GOTO 80
70	NEWX1 = X
	NEWY1 = Y
75	CALL ADDNOD(NEWX1, NEWY1)
80	CALL G3LNTO(NEWX1, NEWY1)
	RETURN
90	IF (X-OLDX2) 100,140,190
100	MASKY = OLDY1 + (OLDY2-OLDY1)*(X-OLDX1)/(OLDX2-OLDX1)
	IF (Y-MASKY) 110,120,130
110	IF (MASKED.GT.0) THEN		! we weren't at last point
	   CALL HORINT(X,Y, MASKX,MASKY)! find intersection with horizon
	   CALL G3LNTO(MASKX, MASKY)	! and draw up to it
	ENDIF
	MASKED = -1			! we're certainly below now
	NEWX1 = X
	NEWY1 = Y
	RETURN
120	NEWX1 = X
	NEWY1 = Y
	CALL ADDNOD(NEWX1, NEWY1)
	IF (MASKED.GT.0) THEN		! coming from above
	   CALL G3LNTO(NEWX1, NEWY1)	!  - draw line
	ELSE				! coming from on or below
	   CALL G3MVTO(NEWX1, NEWY1)	!  - simply move
	ENDIF
	MASKED = 0			! record state
	RETURN
130	IF (MASKED.LT.0) THEN		! we weren't at last point
	   CALL HORINT(X,Y, MASKX,MASKY)! evaluate intersection
	   CALL G3MVTO(MASKX, MASKY)	! get to it
	ENDIF
	NEWX1 = X
	NEWY1 = Y
	MASKED = 1
	CALL ADDNOD(NEWX1, NEWY1)
	CALL G3LNTO(NEWX1, NEWY1)
	RETURN
140	IF (Y-OLDY2) 150,170,180
150	IF (MASKED.GT.0) THEN
	   CALL HORINT(X,Y, MASKX,MASKY)! get intersection
	   CALL G3LNTO(MASKX, MASKY)	! draw to it
	ENDIF
	MASKED = -1
160	NEWX1 = X
	NEWY1 = Y
	CALL NXTNOD
	IF (DANGLE.GT.0) THEN
	   IF (MASKED.LT.0) CALL G3MVTO(NEWX1, NEWY1)
	ENDIF
	RETURN
170	IF (MASKED.GT.0) THEN		! from above
	   CALL G3LNTO(OLDX2, OLDY2)	!  - draw to it
	ELSE				! from below
	   CALL G3MVTO(OLDX2, OLDY2)	!  - simply move there
	ENDIF
	MASKED = 0
	GOTO 160
180	IF (MASKED.LT.0) THEN
	   CALL HORINT(X,Y, MASKX,MASKY)! get intersection
	   CALL G3MVTO(MASKX, MASKY)	! get to it
	ENDIF
	CALL G3LNTO(X, Y)		! draw new bit of horizon
	MASKED = 1
	CALL ADDNOD(X, Y)		! replace old node
	NDCOPY = .FALSE.		!  with new point
	GOTO 160
190	MASKY = NEWY1 + (OLDX2-NEWX1)*(Y-NEWY1)/(X-NEWX1)
	IF (MASKY-OLDY2) 200,220,230
200	SAVY = MASKY
	SAVX = OLDX2
	IF (MASKED.GT.0) THEN		! weren't below at start
	   CALL HORINT(X,Y, MASKX,MASKY)! find crossing
	   CALL G3LNTO(MASKX, MASKY)	! complete vector
	ENDIF
	MASKED = -1
210	CALL NXTNOD
	IF (DANGLE.GT.0) THEN		! at end of old horizon
	   IF (MASKED.LT.0)
     &	      CALL G3MVTO(SAVX, SAVY)	! get to where new horizon
	   GOTO 70			! to append to chain
	ELSE				! still in chain
	   GOTO 90			! loop to try again
	ENDIF
220	IF (MASKED.GT.0) THEN
	   CALL G3LNTO(OLDX2, OLDY2)
	ELSE
	   CALL G3MVTO(OLDX2, OLDY2)
	ENDIF
	MASKED = 0
	GOTO 210
230	IF (MASKED.LT.0) THEN		! not at start
	   CALL HORINT(X,Y, MASKX,MASKY)! get intersection
	   CALL G3MVTO(MASKX, MASKY)	! and get to it
	ENDIF
	MASKED = 1
	NDCOPY = .FALSE.
	GOTO 210
	END

	SUBROUTINE DRAW_LEGEND
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	MAX_EXPMAX	! maximum possible buffer length
	PARAMETER	(MAX_EXPMAX = 1024)
	INTEGER*4	DEF_EXPMAX	! default buffer length
	PARAMETER	(DEF_EXPMAX = 255)
	INTEGER*2	EXPLEN		! current line length
	BYTE		EXPTYP		! type of fake string
	BYTE		EXPCLA		! class of fake string
	INTEGER*4	EXPPTR		! address of buffer
	INTEGER*2	EXPMAX		! actual buffer length
	INTEGER*4	EXPCTF		! control flags for expansion
	BYTE		EXPBUF(MAX_EXPMAX+1)	! expansion buffer
	INTEGER*4	EXPDSC(2)	! fake string descriptor
	EQUIVALENCE	(EXPDSC,EXPLEN)
	COMMON/LSL_EXPC/EXPLEN,EXPTYP,EXPCLA,EXPPTR,EXPMAX,EXPCTF,EXPBUF
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP,GSOLID
	PARAMETER (GASTI=3)		! deferral At Some TIme
	PARAMETER (GSUPPD=0)		! regeneration suppressed
	PARAMETER (GBUNDL=0)		! GKS ASF bundled
	PARAMETER (GINDIV=1)		! GKS ASF individual
	PARAMETER (GMETRE=0)		! device coords metres
	PARAMETER (GSUPP=0)		! suppress update regeneration
	PARAMETER (GALWAY=1)		! clear always
	PARAMETER (GNONE=0)		! no input
	PARAMETER (GOK=1)		! input OK
	PARAMETER (GNPICK=2)		! no segment picked
	PARAMETER (GINVIS=0)		! invisible
	PARAMETER (GVISI=1)		! visible
	PARAMETER (GNORML=0)		! normal
	PARAMETER (GHILIT=1)		! highlighted
	PARAMETER (GNCLIP=0)		! no clipping
	PARAMETER (GCLIP=1)		! clipping
	PARAMETER (GSOLID=1)		! solid 
	INTEGER*4	INCR		! height increment
	INTEGER*4	HRANGE		! height range
	INTEGER*4	BOX		! legend box count
	INTEGER*4	I
	INTEGER*4	HGT
	INTEGER		COL
	INTEGER*4	ISEG		! saved quadrant values
	INTEGER*4	DEVICE
	REAL		LS
	REAL		HGT0
	REAL		RDUMMY
	REAL		LX,LY		! legend position in device units
	REAL		XLL,YLL,XUR,YUR	! box ll and ur corners in WC
	REAL		WXR,WYR		! world range
	REAL		WX,WY		! world coords
	INTEGER		NBOXES
	INTEGER		ICOL
	IF (.NOT.(PRIMARY.OR.SECONDARY))GOTO 999
	IF(PRIMARY.AND.WTYPE(1).EQ.9900)THEN
	   CALL GDAWK(1)
	ENDIF
	IF(PRIMARY)THEN
	  CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(1,0)
	ENDIF
	IF(SECONDARY)THEN
	  CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(2,0)
	ENDIF
	IF (SPLIT)THEN
	   ISEG=QUAD
	   QUAD=QUAD-1
	   IF(QUAD.EQ.0)QUAD=4
	ENDIF
	CALL GSTXCI(1)		!colour
	CALL GSLWSC(1.0)	!thin lines
	CALL GSCHUP(0.0,1.0)	!angle of text
	IF(PRIMARY)THEN
	  HGT0=(WYMAX-WYMIN)*0.0025/SCRNDY(1)
	  CALL GSCHH(HGT0)
	ENDIF
	IF(SECONDARY)THEN
	  HGT0=(WYMAX-WYMIN)*0.0025/SCRNDY(2)
	  CALL GSCHH(HGT0)
	ENDIF
	IF (PRIMARY) THEN
	  WXR=SCRNDX(1)	!world x range
	  WYR=SCRNDY(1)	!world y range
	  LX =(LEGX*WXR)-(WXR*0.5)
	  LY =(LEGY*WYR)-(WYR*0.5)
	  LS =LEGSIZ*0.01
	  DEVICE=1
	ELSE
	  WXR=SCRNDX(2)	!world x range
	  WYR=SCRNDY(2)	!world y range
	  LX =(LEGX*WXR)-(WXR*0.5)
	  LY =(LEGY*WYR)-(WYR*0.5)
	  LS =LEGSIZ*0.01
	  DEVICE=2
	END IF
	BOX=1
	IF(MIN_WVALUE(1).LE.0)THEN
	  CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5.0+LY,XLL,YLL)
	  CALL VSTKD2W(DEVICE,LS*2.0+LX,LS*(BOX+1)*5.0+LY,XUR,YUR)
	  CALL G3FILL(XLL,YLL,XUR,YUR,2)! fill in blue
	  CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*(BOX+1)*5.0+LY,WX,WY)
	  CALL G3TX(WX,WY,'     0')	! draw text
	  BOX=BOX+1
	ENDIF
	IF(ZLOWER.GT.MIN_WVALUE(1))THEN
	  CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5.0+LY,XLL,YLL)
	  CALL VSTKD2W(DEVICE,LS*2.0+LX,LS*(BOX+1)*5.0+LY,XUR,YUR)
	  CALL G3FILL(XLL,YLL,XUR,YUR,1)
	  CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*(BOX+1)*5.0+LY,WX,WY)
	  CALL EXPAND('%I',ZLOWER)
	  CALL G3TX(WX,WY,EXPDSC)
	  BOX=BOX+1
	ENDIF
	HRANGE=(ZUPPER-ZLOWER)
	INCR=STPINT
50	NBOXES=(HRANGE/INCR)+1
	IF(NBOXES.GT.10)THEN
	  INCR=INCR*2
	  GOTO 50
	ENDIF
	HGT = ZLOWER
	DO 60 I=1,NBOXES
	   HGT = HGT+INCR
	   IF(HGT.GT.ZUPPER)GOTO 100
	   COL = ICOL(HGT-1)
	   CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5.0+LY,XLL,YLL)
	   CALL VSTKD2W(DEVICE,LS*2.0+LX,LS*(BOX+1)*5.0+LY,XUR,YUR)
	   CALL G3FILL(XLL,YLL,XUR,YUR,COL)
	   IF(I.EQ.1.AND.ZLOWER.EQ.MIN_WVALUE(1)) THEN
	     CALL EXPAND('%^W%I',MIN_WVALUE(1))
	     CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*BOX*5.0+LY,WX,WY)
	     CALL G3TX(WX,WY,EXPDSC)
	   ENDIF
	   CALL EXPAND('%I',HGT)
	   CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*(BOX+1)*5.0+LY,WX,WY)
	   CALL G3TX(WX,WY,EXPDSC)
	   BOX=BOX+1
60	CONTINUE
100	IF(ZUPPER.LT.MAX_WVALUE(1))THEN
	  CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5.0+LY,XLL,YLL)
	  CALL VSTKD2W(DEVICE,LS*2.0+LX,LS*(BOX+1)*5.0+LY,XUR,YUR)
	  COL=ICOL(ZUPPER-1)
	  CALL G3FILL(XLL,YLL,XUR,YUR,COL)
	  CALL EXPAND('%I',ZUPPER)
	  CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*(BOX+1)*5.0+LY,WX,WY)
	  CALL G3TX(WX,WY,EXPDSC)
	  BOX=BOX+1
	ENDIF
	CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5.0+LY,XLL,YLL)
	CALL VSTKD2W(DEVICE,LS*2.0+LX,LS*(BOX+1)*5.0+LY,XUR,YUR)
	COL=ICOL(MAX_WVALUE(1)-1)
	CALL G3FILL(XLL,YLL,XUR,YUR,COL)
	CALL EXPAND('%^W%I',MAX_WVALUE(1))
	CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*(BOX+1)*5.0+LY,WX,WY)
	CALL G3TX(WX,WY,EXPDSC)
	IF (SPLIT) QUAD = ISEG
	IF (PRIMARY.AND.WTYPE(1).EQ.9900)THEN
	   CALL GACWK(1)
	ENDIF
	IF(PRIMARY)CALL GUWK(1,GSUPP)
	IF(SECONDARY)CALL GUWK(2,GSUPP)
999	RETURN
	END

	SUBROUTINE LEGBAT
	IMPLICIT NONE
	INTEGER*4	MAX_EXPMAX	! maximum possible buffer length
	PARAMETER	(MAX_EXPMAX = 1024)
	INTEGER*4	DEF_EXPMAX	! default buffer length
	PARAMETER	(DEF_EXPMAX = 255)
	INTEGER*2	EXPLEN		! current line length
	BYTE		EXPTYP		! type of fake string
	BYTE		EXPCLA		! class of fake string
	INTEGER*4	EXPPTR		! address of buffer
	INTEGER*2	EXPMAX		! actual buffer length
	INTEGER*4	EXPCTF		! control flags for expansion
	BYTE		EXPBUF(MAX_EXPMAX+1)	! expansion buffer
	INTEGER*4	EXPDSC(2)	! fake string descriptor
	EQUIVALENCE	(EXPDSC,EXPLEN)
	COMMON/LSL_EXPC/EXPLEN,EXPTYP,EXPCLA,EXPPTR,EXPMAX,EXPCTF,EXPBUF
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	INTEGER*4	I		! counter
	INTEGER*4	BOX		! number of boxes required
	INTEGER*4	ISEG		! saved quadrant value
	INTEGER*4	DEVICE
	REAL		HGT0
	REAL		SDX,SDY
	REAL		RDUMMY
	REAL		LS		! legend scaling factor
	REAL		LX,LY		! legend position in device units
	REAL		XLL,YLL,XUR,YUR	! box ll and ur corners in WC
	REAL		WXR,WYR		! world range
	REAL		WX,WY		! world coords
	IF (.NOT.(PRIMARY.OR.SECONDARY))GOTO 999
	IF ((PRIMARY).AND.(WTYPE(1).EQ.9900))CALL GDAWK(1)
	IF (SPLIT)THEN
	   ISEG=QUAD
	   QUAD=QUAD-1
	   IF(QUAD.EQ.0)QUAD=4
	ENDIF
	CALL GSTXCI(1)		!colour
	CALL GSLWSC(1.0)	!thin lines
	CALL GSCHUP(0.0,1.0)	!angle of text
	IF(PRIMARY)THEN
	  HGT0=(WYMAX-WYMIN)*0.0025/SCRNDY(1)
	  CALL GSCHH(HGT0)
	ENDIF
	IF(SECONDARY)THEN
	  HGT0=(WYMAX-WYMIN)*0.0025/SCRNDY(2)
	  CALL GSCHH(HGT0)
	ENDIF
	IF (PRIMARY) THEN
	  WXR=SCRNDX(1)	!world x range
	  WYR=SCRNDY(1)	!world y range
	  LX =(LEGX*WXR)-(WXR*0.5)
	  LY =(LEGY*WYR)-(WYR*0.5)
	  LS =LEGSIZ*0.01
	  DEVICE=1
	ELSE
	  WXR=SCRNDX(2)	!world x range
	  WYR=SCRNDY(2)	!world y range
	  LX =(LEGX*WXR)-(WXR*0.5)
	  LY =(LEGY*WYR)-(WYR*0.5)
	  LS =LEGSIZ*0.01
	  DEVICE=2
	END IF
	BOX=0
	DO 100 I=STEPS,1,-1
	   BOX=BOX+1
	   CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5+LY,XLL,YLL)
	   CALL VSTKD2W(DEVICE,LS*2.0+LX,
     &			LS*(BOX+1)*5.0+LY,XUR,YUR)
	   CALL G3FILL(XLL,YLL,XUR,YUR,HGTSTP(2,I))
	   CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*BOX*5.0+LY,WX,WY)
	   IF(I.EQ.STEPS)THEN
	     CALL EXPAND('%I',-SEABOT)
	     CALL G3TX(WX,WY,EXPDSC)
	   ELSE
	      CALL EXPAND('%I',HGTSTP(1,I))
	      CALL G3TX(WX,WY,EXPDSC)
	   ENDIF
100	CONTINUE		   
	BOX=BOX+1
	CALL VSTKD2W(DEVICE,LS+LX,LS*BOX*5+LY,XLL,YLL)
	CALL VSTKD2W(DEVICE,LS*2.0+LX,
     &			LS*(BOX+1)*5.0+LY,XUR,YUR)
	CALL G3FILL(XLL,YLL,XUR,YUR,15)! fill in brown
	CALL EXPAND('   Land')
	CALL VSTKD2W(DEVICE,LS*2.5+LX,LS*BOX*5.0+LY,WX,WY)
	CALL G3TX(WX,WY,EXPDSC)
	IF (SPLIT) QUAD = ISEG
	IF ((PRIMARY).AND.(WTYPE(1).EQ.9900))CALL GACWK(1)
999	RETURN
	END

	SUBROUTINE ANNOTATE
	IMPLICIT NONE
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP,GSOLID
	PARAMETER (GASTI=3)		! deferral At Some TIme
	PARAMETER (GSUPPD=0)		! regeneration suppressed
	PARAMETER (GBUNDL=0)		! GKS ASF bundled
	PARAMETER (GINDIV=1)		! GKS ASF individual
	PARAMETER (GMETRE=0)		! device coords metres
	PARAMETER (GSUPP=0)		! suppress update regeneration
	PARAMETER (GALWAY=1)		! clear always
	PARAMETER (GNONE=0)		! no input
	PARAMETER (GOK=1)		! input OK
	PARAMETER (GNPICK=2)		! no segment picked
	PARAMETER (GINVIS=0)		! invisible
	PARAMETER (GVISI=1)		! visible
	PARAMETER (GNORML=0)		! normal
	PARAMETER (GHILIT=1)		! highlighted
	PARAMETER (GNCLIP=0)		! no clipping
	PARAMETER (GCLIP=1)		! clipping
	PARAMETER (GSOLID=1)		! solid 
	INTEGER*4	DESC(2)
	REAL		TX,TY		! text device position
	REAL		WX,WY		! text world position
	REAL		WXR,WYR		! world ranges
	REAL		HGT		! character height
	IF (.NOT.(PRIMARY.OR.SECONDARY))GOTO 999
	CALL PLTPOS(.FALSE.,.FALSE.)
	CALL GSSGT
	IF (PRIMARY) THEN
	  WXR=SCRNDX(1)		!world x range
	  WYR=SCRNDY(1)		!world y range
	  TX =(LABX*WXR)-(WXR*0.5)
	  TY =(LABY*WYR)-(WYR*0.5)
	  CALL VSTKD2W(1,TX,TY,WX,WY)
	ELSE
	  WXR=SCRNDX(2)	!world x range
	  WYR=SCRNDY(2)	!world y range
	  TX =(LABX*WXR)-(WXR*0.5)
	  TY =(LABY*WYR)-(WYR*0.5)
	  CALL VSTKD2W(2,TX,TY,WX,WY)
	ENDIF
	IF(PRIMARY)THEN
          IF(NOPLNS.EQ.4.OR.WTYPE(1).EQ.9900)THEN
	    CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,0)
	    CALL LSG_PLANE_VISIBLE(1,-1)
	  ELSE
	    CALL LSG_PLANE_SELECT(1,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,NOPLNS)
	    CALL LSG_PLANE_VISIBLE(1,-1)
	  ENDIF
	ENDIF
	IF(SECONDARY)THEN
          IF(NOPLNS.EQ.4)THEN
	    CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,0)
	    CALL LSG_PLANE_VISIBLE(2,-1)
	  ELSE
	    CALL LSG_PLANE_SELECT(2,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,NOPLNS)
	    CALL LSG_PLANE_VISIBLE(2,-1)
	  ENDIF
	ENDIF
	IF(NOPLNS.EQ.4)THEN
	  CALL GSTXCI(1)
	ELSE
          CALL GSTXCI(LABCOL)
	ENDIF
	CALL GSLWSC(1.0)
	CALL GSCHUP(0.0,1.0)
	IF(PRIMARY)  HGT=(WYMAX-WYMIN)*(0.0025*LABSIZ)/SCRNDY(1)
	IF(SECONDARY)HGT=(WYMAX-WYMIN)*(0.0025*LABSIZ)/SCRNDY(2)
	CALL GSCHH(HGT)
	DESC(1) = TXTPTR-DCPTR+1
	DESC(2) = %LOC(TXTBUF(DCPTR))
	CALL G3TX(WX,WY,DESC)
	IF(PRIMARY)CALL GUWK(1,GSUPP)
	IF(SECONDARY)CALL GUWK(2,GSUPP)
999	RETURN
	END

	SUBROUTINE SEASET
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER*4	I		!loop counter
	INTEGER*2	CINDEX		!colour index
	IF (DTICOL) THEN
	   SEABOT=MIN_WVALUE(1)			!ignore null heights
	   SEABOT=ABS(SEABOT)			!make positive
	ELSE
	   SEABOT=MODMIN
	   SEABOT=ABS(SEABOT)
	ENDIF
	IF (HADSTP) THEN		!calulate number of colour steps
	  STEPS =INT(0.5+(SEABOT/STPINT))
	  STEPS =MAX(1,MIN(STEPS,MAXCOL))
	ELSE				!calculate step interval
	  STPINT=INT(0.5+(SEABOT/STEPS))
	  STPINT=MAX(1,MIN(STPINT,SEABOT))
	ENDIF
	CINDEX=0
	CSTEP=(MAXCOL/STEPS)	!only an approximate division
	DO 200 I=1,STEPS
	   CINDEX=CINDEX+CSTEP
	   HGTSTP(1,I)=-STPINT*I	!negative again
	   HGTSTP(2,I)=CINDEX
200	CONTINUE
999	RETURN
	END
