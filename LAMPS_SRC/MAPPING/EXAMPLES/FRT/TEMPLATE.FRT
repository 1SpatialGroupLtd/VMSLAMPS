! this is the template Feature Representation Table (FRT) file TEMPLATE.FRT

! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	30	1	2	0	0	0	Minor Building
FRT	32	1	3	50	0	5	Parish Boundary
FRT	35	7	1	0	20	13	Trig Point
FRT	38	10	2	0	10	3	Water text


! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	1	1	0	0	0	0	line
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT	5	5	0	0	0	0	full circumcircle
SCT	6	6	0	0	0	0	interpolated curve

! then the group definitions
!	name	   range,range
GROUP	ROADS      29,31
GROUP	FENCES     23,30,108
GROUP	WATER      59,60-65,67-72,74,82,104
GROUP	GRID       398,998

! then the pattern definitions
!   	Pattern	Major	Minor	Major	Minor	Overall	Major	Minor	Major	Minor
!   	Index	UC	UC	Repeat	Repeat	Size	Size	Size	Width	Width
PATTERN	5	82	0	0	0	1.8	0.6	0.0	0.5	0.0
PATTERN	10	0	0	0	0	1.8	1.2	0.0	0.0	0.0
PATTERN	15	0	82	0	0	5.4	3.6	0.6	0.0	0.6

! that's the end of TEMPLATE.FRT
