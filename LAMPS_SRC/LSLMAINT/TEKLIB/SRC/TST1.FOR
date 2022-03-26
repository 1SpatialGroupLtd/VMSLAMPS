C
C Tests the refresh and stored-mode buffering, and drawing, of
C  the TMU board.
C
C Author J.Rees
C Date 13/Jun/80
C
	REAL OX(18),OY(18)
	DATA OX/-5.0, -5.0, 10.0, 10.0, -5.0
     &		,-5.0, 0.0, 15.0, 15.0, 10.0
     &		,10.0, 15.0
     &		,0.0, 0.0, 5.0, 5.0, 0.0, 5.0/
C
	DATA OY/-10.0, 10.0, 10.0, -10.0, -10.0
     &		,10.0, 12.5, 12.5, -7.5, -10.0
     &		,10.0, 12.5
     &		,-5.0, 5.0, 5.0, -5.0, -5.0, -2.5/
C
C initialise Tek.
	CALL TKINIT(7,3)
	CALL DISMOD(1)
C
C draw an 'O' on the screen
	CALL MOVTO(OX(1),OY(1))
	  DO 200 I=2,5
	    CALL LINTO(OX(I),OY(I))
200	  CONTINUE
	CALL MOVTO(OX(6),OY(6))
	  DO 220 J=7,10
	    CALL LINTO(OX(J),OY(J))
220	  CONTINUE
	CALL MOVTO(OX(11),OY(11))
	CALL LINTO(OX(12),OY(12))
	CALL MOVTO(OX(13),OY(13))
	  DO 240 K=14,18
	    CALL LINTO(OX(K),OY(K))
240	  CONTINUE
	CALL REFRSH
	CALL LDCMPL
C
	CALL EXIT
	END
