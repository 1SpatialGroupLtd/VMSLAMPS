	SUBROUTINE SET_MAPDES()
C
CDEC$	IDENT	'21MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	21-May-1992
C
C Description:
C
C       Routine to calculate the origin of the 
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'MESPAR.PAR'
C
C Common blocks
C
	INCLUDE 'TABLES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
C
C Local workspace
C
	INTEGER*4	X,Y		     	! loopy
	INTEGER*4	T1,T2			! working tile name
	CHARACTER*1	LONG,LAT
C
C ......................................................................
C
	LONG = CURRGEO(1:1)
	LAT  = CURRGEO(2:2)
	T1 = ICHAR(TILESEL(1:1))-48
	T2 = ICHAR(TILESEL(2:2))-48
C
	IF (CURRGEO(1:2).EQ.'  ') THEN
	   MD2LOC(1) = 0.0
	   MD2LOC(2) = 0.0
	   ORIGIN(1) = 0.0
	   ORIGIN(2) = 0.0
	ELSE
	   DO 100 X = 1,NUM_LONG_GEO
	      IF (LONG_GEOREF(X:X).EQ.LONG) THEN
		 DO 200 Y = 1,NUM_LAT_GEO
		    IF (LAT_GEOREF(Y:Y).EQ.LAT) THEN
		       MD2LOC(1)=DBLE((X-13)*15+(T1-1)*5)
		       MD2LOC(2)=DBLE((Y-7)*15+(T2-1)*5)
		       ORIGIN(1)=REAL(MD2LOC(1))
		       ORIGIN(2)=REAL(MD2LOC(2))
		    ENDIF
 200		 CONTINUE
	      ENDIF
100	   CONTINUE
	ENDIF
	MATV2 = 2
	MD2SCL = 1000000
	MD2PRJ = 100
	MD2UNT = 4
	MD2SPH = 22
C
C ......................................................................
C
1000	RETURN
	END
