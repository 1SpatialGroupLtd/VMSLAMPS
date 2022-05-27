!
! I2IMAP_DEC_GRAP.FRT
!
! Created 13 July 1992 RWH
!
! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	1	0.17	0	0	Unknown feature type
FRT	1	1	1	0.17	0	0	Building (public)
FRT	30	1	1	0	0	0	Fence,wall (non road)
FRT	321	7	2	0	1	1	Polygon Point-General Building
FRT	398	1	1	0	0	0	Grid lines
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

PATTERN	5        0      0      0      0      0.9     0.6    0.0    0.     0.
PATTERN	6        5      0      0      0      1.8     0.6    0.0    0.3    0.
PATTERN	7        12     0      0      0      2.58    1.8    0.0    0.9    0.
PATTERN	8        0      0      0      0      2.4     1.44   0.0    0.     0.
PATTERN	10       0      0      0      0      1.8     1.2    0.0    0.     0.
PATTERN	12       0      0      0      0      2.76    2.16   0.0    0.     0.
PATTERN	15       0      0      0      0      2.7     1.8    0.0    0.     0.
PATTERN	20       1      0      0      0      4.0     3.99   0.0    2.0    0.
PATTERN	22	 0      0      0      0      3.0     2.5    0.0    0.     0.
PATTERN	25       0      0      0      0      4.5     3.0    0.0    0.     0.
PATTERN	28       0      5      0      0      5.4     3.6    0.6    3.6    0.3
PATTERN	30       0      0      0      0      5.4     3.6    0.0    0.     0.
PATTERN	32       5      0      0      0      5.4     3.6    0.0    1.8    0.
PATTERN	80       0      0      0      0      14.4    9.6    0.0    0.     0.
PATTERN 81	 5	0      0      0      5.0     0.6    0.0    0.3    0.0
PATTERN 82	 0	0      0      0      9.0     6.0    0.0    0.0    0.0
PATTERN 83	 0	0      0      0      11.0    6.0    2.0    0.0    0.0
PATTERN 84	 0	0      0      0      6.0     4.0    0.0    0.0    0.0
PATTERN 85	 1      0      0      0      6.0     5.99   0.0    1.5    0.0
!
ACD TABLE 2
!
ACD R 1 STARTX
ACD R 2 STARTY
ACD R 3 ENDX
ACD R 4 ENDY
ACD C 5 FEATURE
!
