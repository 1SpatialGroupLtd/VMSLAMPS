!   	FC	GT	Colour	Width	Size	SC	Description
FRT     0       1       1       0       2       1       ! LINEAR
FRT     1       1       1       0       0       0       line
FRT     2       7       0       0       0       110     clockwise arc
FRT	3	10	6	0	1	1	Name
FRT     7       1       3       0       2       1       ! LINEAR
FRT     8       1       4       0       2       1       ! LINEAR
FRT     9       1       5       0       2       1       ! LINEAR
FRT	10 	11	2	0	2.0	1   ! POINT
FRT	11	7	3	0	1	5	Boundary post/stone
!
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
!
! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width

PATTERN	1        0      0      0      0      0.9     0.6    0.0    0.     0.
PATTERN	6        5      0      0      0      1.8     0.6    0.0    0.3    0.
PATTERN	7        12     0      0      0      2.58    1.8    0.0    0.9    0.
PATTERN	8        0      0      0      0      2.4     1.44   0.0    0.     0.
PATTERN	10       0      0      0      0      1.8     1.2    0.0    0.     0.
!
ACD TABLE 2
ACD R 1 CHAINAGE
ACD R 2 RADIUS
ACD R 3 BEARING
ACD R 4 UNKNOWN
ACD C 5 LABEL
