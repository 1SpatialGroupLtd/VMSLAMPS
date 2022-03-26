C
C	Polygon Clipping - Temporary link in circular list
C
C Description
C
C	This is an include file for local declaration of a temporary 
C	link, the values of which may have come from or are destined for
C	a link in the circular linked list
C
C	Note that this file requires the prior inclusion of 
C	INTERSECT.CMN
C
C Fields of the link
C
	INTEGER*4	PREV_PTR	! pointer to previous link
	INTEGER*4	NEXT_PTR	! pointer to next link
	REAL*4		THIS_X		! X coordinate of intersection
	REAL*4		THIS_Y		! Y coordinate of intersection
	REAL*4		THIS_DIST	! distance from last corner
	REAL*4		THIS_ANGLE	! angle with side
	INTEGER*4	LINK_NUM	! number of link in feature
	INTEGER*4	PREV_PT		! previous point in feature
	INTEGER*4	NEXT_PT		! next point in feature
	LOGICAL*1	IN		! going into the clipping area ?
	LOGICAL*1	DONE		! done output for this link ?
C
C Now for the link itself
C
	BYTE		CURR_LINK(LINK_LEN)
C
C Equivalence the various fields onto the link
C
	EQUIVALENCE	(PREV_PTR,CURR_LINK(PREPTR))
	EQUIVALENCE	(NEXT_PTR,CURR_LINK(NXTPTR))
	EQUIVALENCE	(THIS_X,CURR_LINK(X))
	EQUIVALENCE	(THIS_Y,CURR_LINK(Y))
	EQUIVALENCE	(THIS_DIST,CURR_LINK(DIST))
	EQUIVALENCE	(THIS_ANGLE,CURR_LINK(ANGLE))
	EQUIVALENCE	(LINK_NUM,CURR_LINK(LNK))
	EQUIVALENCE	(PREV_PT,CURR_LINK(PREIND))
	EQUIVALENCE	(NEXT_PT,CURR_LINK(NXTIND))
	EQUIVALENCE	(IN,CURR_LINK(TRAN))
	EQUIVALENCE	(DONE,CURR_LINK(FLG))
