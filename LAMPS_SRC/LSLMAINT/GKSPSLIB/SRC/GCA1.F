C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1995-04-03 11:04:30.000000000 +0100
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
C
C Cell array functions
C ====================
C
C *********************************************************************
C
C	PIXEL IMAGE PRIMITIVE
C	=====================
C
C
	SUBROUTINE	LSG_PIXEL_ARRAY(
     &		PX,PY,NX,NY,VX1,VX2,VY1,VY2,SCX,SCY,PXARR)
C
CDEC$	IDENT	'03AP95'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
	IMPLICIT NONE
C
	INCLUDE	'GFABUF.CMN'
C
C Arguments:
C
	REAL	PX			! X coord (w.c.)
	REAL	PY			! Y coord
	INTEGER	NX,NY			! size of array, and direction
	INTEGER	VX1,VX2,VY1,VY2		! portion of array
	INTEGER	SCX,SCY			! scale factors
	BYTE	PXARR(*)		! array of pixels
C
C Functions
	LOGICAL	INIT_FILL_MEM
C
C first time through, get the memory
	IF (MEMORY_FAIL) GOTO 999
C
	IF (GFAMAX .EQ.0) THEN
	   MEMORY_FAIL = INIT_FILL_MEM()
	   IF (MEMORY_FAIL) GOTO 999
	ENDIF	      
C
C call the actual routine to do the work, passing it a byte buffer to
C use
C
	CALL LSG_PIXEL_ARRAY_SUB(
     &		PX,PY,NX,NY,VX1,VX2,VY1,VY2,SCX,SCY,PXARR,
     &	        BMAX,%VAL(B_ADDR))

C
999	RETURN
	END
C
	SUBROUTINE	LSG_PIXEL_ARRAY_SUB(
     &		PX,PY,NX,NY,VX1,VX2,VY1,VY2,SCX,SCY,PXARR,BMAX,B)
C
CDEC$	IDENT	'25MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	REAL	PX			! X coord (w.c.)
	REAL	PY			! Y coord
	INTEGER	NX,NY			! size of array, and direction
	INTEGER	VX1,VX2,VY1,VY2		! portion of array
	INTEGER	SCX,SCY			! scale factors
	BYTE	PXARR(*)		! array of pixels
	INTEGER	BMAX			! size of workspace
	BYTE	B(BMAX)			! workspace
C
C Functions
	INTEGER	LIB$EXTZV
C
C Workspace
	REAL	DX,DY			! device coordinate
	INTEGER	REPX,REPY		! replication factors
	INTEGER	NCOLS,NROWS
	INTEGER	XSTEP,YSTEP,TEMP
	INTEGER	PIND
	INTEGER	I,J
	REAL	TMAT(6)			! PostScript matrix
	INTEGER*4	PIXL
	BYTE		PIXB
	EQUIVALENCE	(PIXL,PIXB)
	LOGICAL	MONO,INVERT
C
C check arguments
	IF (NX.EQ.0.OR.NY.EQ.0) GOTO 200
	IF (VX1.LT.1.OR.VX2.GT.ABS(NX).OR.VX1.GT.VX2) GOTO 200
	IF (VY1.LT.1.OR.VY2.GT.ABS(NY).OR.VY1.GT.VY2) GOTO 200
	IF (SCX.LE.0.OR.SCY.LE.0) GOTO 200
C
C is this workstation active? - if not ignore it
	IF (.NOT.WSACT) GOTO 200
C
C ensure that our transformation is up to date
	IF (UPTRN) CALL GUPTRN		! update it
C
C is everything clipped (ie nothing visible)
	IF (CLPALL) GOTO 200
C
	NCOLS = VX2-VX1+1
	NROWS = VY2-VY1+1
	XSTEP = SIGN(1,NX)
	YSTEP = SIGN(1,NY)
	REPX = SCX
	REPY = SCY
C
C contruct matrix to transform metre device space to image space
C (i.e. 0 to rows/cols-1)
	IF (.NOT.PIXROT) THEN
	   TMAT(1) = XSTEP/(REPX*PSIZX + RASEXP/NCOLS/1000.0)
	   TMAT(2) = 0.0
	   TMAT(3) = 0.0
	   TMAT(4) = YSTEP/(REPY*PSIZY + RASEXP/NROWS/1000.0)
	ELSE
	   TMAT(2) = -YSTEP/(REPY*PSIZX + RASEXP/NROWS/1000.0)
	   TMAT(3) = XSTEP/(REPX*PSIZY + RASEXP/NCOLS/1000.0)
	   TMAT(1) = 0.0
	   TMAT(4) = 0.0
	   TEMP = YSTEP
	   YSTEP = XSTEP
	   XSTEP = -TEMP
	ENDIF
C
C Convert world position to device coordinate
	CALL GKSW2D(1,PX,PY,DX,DY)
C
C allow for convention of passing centre of first pixel - move to actual
C corner of first pixel
	DX = DX-0.5*XSTEP*PSIZX
	DY = DY-0.5*YSTEP*PSIZY
C
	TMAT(5) = -( TMAT(1)*DX + TMAT(3)*DY )
	TMAT(6) = -( TMAT(2)*DX + TMAT(4)*DY )
C
	IF (PACK.EQ.8) THEN
	   CALL PS_BEGIN_IMAGE(NCOLS,NROWS,TMAT,.FALSE.,0,.FALSE.,.FALSE.)
	ELSE
	   PIXL = 1
	   PIXL = ISHFT(PIXL,POFF)	! apply offset
	   PIXL = PIXL.AND.PSEL		! apply mask
C
C check if this appears to be a black and white image
	   MONO = .FALSE.
	   INVERT = .FALSE.
C
C 1 bits naturally come out white, INVERT if 0 bits wanted white
	   IF (RGB(0,1).NE.RGB(0,2).OR.RGB(0,2).NE.RGB(0,3)) GOTO 5
	   IF (RGB(0,1).NE.0.0 .AND. RGB(0,1).NE.1.0) GOTO 5
	   IF (RGB(0,1).EQ.1.0) INVERT = .TRUE.
	   IF (RGB(PIXL,1).NE.RGB(PIXL,2) .OR.
     &	       RGB(PIXL,2).NE.RGB(PIXL,3)) GOTO 5
	   IF (RGB(PIXL,1).NE.0.0 .AND. RGB(PIXL,1).NE.1.0) GOTO 5
C
C check if both colours the same (pretty silly)
	   IF ((RGB(PIXL,1).EQ.1.0).EQV.INVERT) GOTO 5
	   MONO = .TRUE.
5	   IF (.NOT.MONO) INVERT = .FALSE.
	   CALL PS_BEGIN_IMAGE(NCOLS,NROWS,TMAT,.TRUE.,PIXL,MONO,INVERT)
	ENDIF
C
	IF (PACK.EQ.8.AND.POFF.EQ.0.AND.PSEL.EQ.-1) THEN
C
C byte data that does not need shifting, or masking
	   IF (NCOLS.EQ.ABS(NX)) THEN
	      CALL PS_IMAGE(PXARR((VY1-1)*ABS(NX)+VX1),NCOLS*NROWS)
	   ELSE
	      DO 10 J=VY1,VY2
	         CALL PS_IMAGE(PXARR((J-1)*ABS(NX)+VX1),NCOLS)
10	      CONTINUE
	   ENDIF
C
	ELSEIF (PACK.EQ.1.AND.MOD(NX,8).EQ.0.AND.
     &		MOD(VX1-1,8).EQ.0.AND.MOD(NCOLS,8).EQ.0) THEN
C
C bit data that starts on byte boundaries
	   IF (NCOLS.EQ.ABS(NX)) THEN
	      CALL PS_BIT_IMAGE(PXARR(((VY1-1)*ABS(NX)+VX1)/8+1),
     &				NCOLS*NROWS)
	   ELSE
	      DO 11 J=VY1,VY2
	         CALL PS_BIT_IMAGE(PXARR(((J-1)*ABS(NX)+VX1)/8+1),NCOLS)
11	      CONTINUE
	   ENDIF
C
	ELSE
	   PIND = 0
	   DO 20 J=VY1,VY2
	      IF (PACK.EQ.8) THEN
	         DO 15 I=VX1,VX2
	            PIND = PIND+1
	            PIXL = 0
	            PIXB = PXARR((J-1)*ABS(NX)+I)
	            IF (POFF.NE.0) PIXL = ISHFT(PIXL,POFF) ! apply offset
	            B(PIND) = PIXB.AND.PSEL		   ! apply mask
	            IF (PIND.GE.BMAX) THEN
	               CALL PS_IMAGE(B,PIND)
	               PIND = 0
	            ENDIF
15	         CONTINUE
	      ELSE
C
C use a macro subroutine to emulate the CCC commented code
	         CALL LSG_LOOP(
     &			NCOLS,(J-1)*ABS(NX)+VX1-1,PIND,PXARR,B,BMAX*8)
CCC	         DO 16 I=VX1,VX2
CCC	            PIND = PIND+1
CCC	            PIXL = LIB$EXTZV((J-1)*ABS(NX)+I-1,1,PXARR)
CCC	            CALL LIB$INSV(PIXL,PIND-1,1,B)
CCC	            IF (PIND.GE.BMAX*8) THEN
CCC	               CALL PS_BIT_IMAGE(B,PIND)
CCC	               PIND = 0
CCC	            ENDIF
CCC16	         CONTINUE
C
C for non-multiple of 8 rows, then output after each row
C (this is so PS stuff can output padding to byte)
C don't bother do test PIND.GT.0 - it must be since array has space
C for multiple of 8 bits, and we do NOT have a multiple
	         IF (MOD(NCOLS,8).NE.0) THEN
	            CALL PS_BIT_IMAGE(B,PIND)
	            PIND = 0
	         ENDIF
	      ENDIF
20	   CONTINUE
	   IF (PIND.GT.0) THEN
	      IF (PACK.EQ.8) THEN
	         CALL PS_IMAGE(B,PIND)
	      ELSE
	         CALL PS_BIT_IMAGE(B,PIND)
	      ENDIF
	      PIND = 0
	   ENDIF
	ENDIF
C
	IF (PACK.EQ.8) THEN
	   CALL PS_END_IMAGE(.FALSE.)
	ELSE
	   CALL PS_END_IMAGE(.TRUE.)
	ENDIF
C
200	RETURN
	END
C
	SUBROUTINE	LSG_FILL_RECTANGLE(PX,PY)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	REAL	PX(2)			! X coords
	REAL	PY(2)			! Y coords
C
C Workspace
	REAL	X(4),Y(4)
	INTEGER	NCOLI
C
C let GFA deal with it
	X(1) = PX(1)
	Y(1) = PY(1)
	X(3) = PX(2)
	Y(3) = PY(2)
	X(2) = X(1)
	Y(2) = Y(3)
	X(4) = X(3)
	Y(4) = Y(1)
	CALL GFA(4,X,Y)
C
	RETURN
	END
C
	SUBROUTINE	LSG_PLANE_SELECT(WKID,MASK)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Set plane selection mask
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER	WKID			! unused
	BYTE	MASK			! plane selection mask
C
C workspace
	INTEGER	NLEV
C
	PSEL = MASK
C
	UPLIN = .TRUE.			! need to update line attributes
	UPFA = .TRUE.			! and areas
	RETURN
	END
C
	SUBROUTINE	LSG_PLANE_OFFSET(WKID,OFFSET)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Specify bit offset (shift) for writing index
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER	WKID			! unused
	INTEGER	OFFSET			! plane offset
C
	POFF = OFFSET
	UPLIN = .TRUE.			! need to update line attributes
	UPFA = .TRUE.			! and areas
	RETURN
	END
C
	SUBROUTINE	LSG_PACKING_MODE(WKID,MODE)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Specify packing mode for pixel array (1 or 8 for bit/byte)
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER	WKID			! unused
	INTEGER	MODE			! packing mode
C
	IF (MODE.EQ.1.OR.MODE.EQ.8) THEN
	   PACK = MODE
	ENDIF
C
9999	RETURN
	END
C
	SUBROUTINE	LSG_ROTATION_MODE(WKID,ROT)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Set rotation mode for pixel arrays
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER		WKID			! unused
	LOGICAL		ROT			! rotate?
C
	PIXROT = ROT
	RETURN
	END
C
	SUBROUTINE	LSG_PLANE_VISIBLE(WKID,MASK)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Set plane visibility mask
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER	WKID			! unused
	BYTE	MASK			! visibility mask
C
C do nothing
	PVIS = MASK
C
	RETURN
	END
C
C
	SUBROUTINE	LSG_PIXEL_SIZE(WKID,SIZEX,SIZEY)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Specify bit offset (shift) for writing index
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
C
	INTEGER	WKID			! unused
	REAL	SIZEX,SIZEY		! pixel size
C
	CALL GW2D(WKID,SIZEX,SIZEY,PSIZX,PSIZY)	! convert to DC
	RETURN
	END
C
	SUBROUTINE	LSG_ZOOM_IMAGE(WKID,PX,PY,ZF)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Zoom image
C
	IMPLICIT NONE
C
C Arguments:
C
	INTEGER	WKID			! unused
	REAL	PX,PY			! position (w.c.)
	INTEGER	ZF			! zoom factor
C
	RETURN
	END
C
	SUBROUTINE	LSG_SET_CURSOR(WKID,PX,PY,ON)
C
CDEC$	IDENT	'08JN87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	 8-Jun-1987
C
C Set cursor position and visibility
C
	IMPLICIT NONE
C
C Arguments:
C
	INTEGER	WKID			! unused
	REAL	PX,PY			! position (w.c.)
	LOGICAL	ON		! visible?
C
	RETURN
	END
