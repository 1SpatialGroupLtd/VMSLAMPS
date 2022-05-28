! this is the LITES2 Feature Representation Table (FRT) file LITES2CMD2.FRT

! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	2	0.1	0	0	LOGO	
FRT	1	1	2	0.75	0	0	OUTLINE
FRT	2	1	3	0.3	0	0	BLOCKS
FRT     3       1       1       0.05	0       0       MENU BLOCKS
FRT	4	10 	1	0.2	4.0	1	TITLE TEXT
FRT	5	10	1	0.1	2.5	1	MENU TITLE TEXT
FRT	6	10	3	0.05	1.8	1	MENU TEXT
FRT	7	10	1	0	1	1	ADDRESS TEXT
FRT	8	9	1	0	4	5	LS LOGO
FRT	49	9	1	0	0	9	CORNER TICKS

! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	0	0	line
SCT	1	1	0	0	0	0	line
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT	5	5	0	0	0	0	full circumcircle
SCT	6	6	0	0	0	0	interpolated curve

! then the group definitions
!	name	   range,range
GROUP	CONTROL    0                                    ! control data  ov 1
GROUP   CONTOUR    10,14                                ! relief topo   ov 1
GROUP   RIVERS     20,25                                ! water topo    ov 2
GROUP   ROADS      30,34                                ! roads         ov 3
GROUP   TEXT       40,41                                ! Text          ov 4

