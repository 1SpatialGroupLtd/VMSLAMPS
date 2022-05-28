
! this is the Structure/Polygons demo Feature Representation Table (FRT) file 
! version 1 FRT by PGH 17/7/87

! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	1	0	0	0	! Unknown feature type
FRT	1	1	1	0	0	0	! Sheet edge
FRT	2	1	2	0	0	0	! polygon links
FRT	3	1	3	0	0	0	! more polygon links
FRT	4	1	4	0	0	0	! multiple polygon links
FRT	28	10	5	0       1       1       ! texts
FRT	103	1	6	0	0	0	! roads
FRT	104	1	8	0	0	0	! roads
FRT	200	1	9	0	0	0	! closed polygons
FRT	300	12	10	0       0       -1	! fill area
FRT	301	12	11	0       1       101	! fill area
FRT	302	12	12	0       1       102	! fill area
FRT	303	12	13	0       1       103	! fill area
FRT	304	12	14	0       1       104	! fill area
FRT	305	12	15	0       1       105	! fill area
FRT	306	12	10	0       1       106	! fill area
FRT	310	12	10	0       1       -2	! fill area
FRT	311	12	11	0       1       -2	! fill area
FRT	312	12	12	0       1       -2	! fill area
FRT	320	12	11	0       0       -1	! fill area


! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	0	0	! LINEAR
SCT	1	1	0	0	0	0	line
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT	5	5	0	0	0	0	full circumcircle
SCT	6	6	0	0	0	0	interpolated curve

!SCT	5	6	0	0	0	0	! INTERPOLATED CURVE
SCT	65	2	0	0	0	0	! CLOCKWISE ARC
SCT	66	3	0	0	0	0	! ANTICLOCKWISE ARC
SCT	67	4	0	0	0	0	! CIRCUMCIRCLE ARC
SCT	68	5	0	0	0	0	! FULL CIRCUMCIRCLE

! then the group definitions
!	name	   range,range
GROUP	links		1-4
GROUP	texts		28
GROUP	roads		103
GROUP	polygons	200
GROUP	areas		300

! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width

PATTERN	5        0      0      0      0      0.9     0.6    0.0    0.     0.
PATTERN	102      7      0      0      0      1.0     0.5    0.0    0.3    0.
!
! fill area
!        Index     Hatch      Fillsc
FILL      -2         103        102
