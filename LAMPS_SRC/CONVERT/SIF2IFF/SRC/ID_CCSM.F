	SUBROUTINE 	ID_CCSM( IDENT,USER1,USER2,CCSM )
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Decode the ident field ID=ident,user1,user2 to return a CCSM code
C
	IMPLICIT	NONE
C
	CHARACTER*12	CCSM		! Return CCSM code
	INTEGER		IDENT		
	INTEGER		USER1
	INTEGER		USER2
C
	INTEGER		CCSM_2
	INTEGER		CCSM_3
	CHARACTER*6	CCSMC_2
	CHARACTER*4	CCSMC_3
C
C-------------------------------------------------------------------------------
C
	CCSM(1:12) = '            '
C
	CCSM(1:1) = CHAR( IDENT .AND. '00FF'X )
	CCSM(2:2) = CHAR( (IDENT .AND. 'FF00'X)/'0100'X )
C
	CCSM_2    = ( USER1 .AND. 'FFFF'X ) + 100000
	CCSM_3    = ( USER2 .AND. '7FF'X ) + 1000
	WRITE ( CCSMC_2,'(I6)' ) CCSM_2
	WRITE ( CCSMC_3,'(I4)' ) CCSM_3
C
	CCSM(4:8) = CCSMC_2(2:6)
	CCSM(10:12) = CCSMC_3(2:4)
C
	RETURN
	END
