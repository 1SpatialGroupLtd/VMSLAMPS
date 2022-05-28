! this is the IMP acceptance test Feature Representation Table (FRT) file 
! IMPTEST.FRT
!
! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	7	1	0	6.0	1	Sheet corners/spot hts
FRT	1	1	1	0.3	0	4	Thick dot line
FRT	2	1	1	0.3	0	2	Thick dash line
FRT	3	1	2	0.1	0	0	Thin line
FRT	4	1	1	0.2	0	0	Medium line
FRT	5	1	1	0.3	0	0 	Thick line
FRT	6	1	1	0.3	0	0	V thick line
FRT	7	1	3	0.1	0	0	Red Thin line
FRT	8	1	1	0.1	0	0	Green Thin line
FRT	9	1	4	0.1	0	0	Colour 4 Thin line
FRT	10	1	5	0.1	0	0	Colour 5 Thin line
FRT	20	8	1	0	0.75	2	Big arrow head
FRT	21	7	1	0	0.40	3	Filled dot symbol
FRT	22	7	1	0	1.0	4	coincident circles
FRT	23	7	1	0.1	0.75	5	single invert V
FRT	24	7	1	0.1	0.75	10	double invert V
FRT	25	7	1	0	0.75	6	dotted circle
FRT	26	7	1	0	1.25	7	maltese cross?
FRT	27	7	1	0	1.25	8	maltese cross circle
FRT	28	7	1	0	1.25	9	blobbed circle
FRT	29	8	1	0	1.5	11	oval
FRT	30	8	1	0	1.5	12	oval with circle
FRT	50	10	6	0	1.0	1	Small text
FRT	51	10	6	0.1	1.5	1	Medium text
FRT	52	10	6	0.18	2.0	1	Big text
FRT	53	10	6	0.30	3.0	1	V big text
FRT	201	1	4	0	0	0	Contours
FRT	202	1	2	0	0	0	Lakes
FRT	204	1	2	0	0	0	Coastline
FRT     205     1       1       0       0       0       Breaklines
FRT     210     1       4       0       0       2       Form lines

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

! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width

PATTERN	 1       1      0      0      0      1.0     0.99   0.0    0.99   0.
PATTERN	 2       0      0      0      0      2.0     1.0    0.0    0.     0.
PATTERN	 3       0      0      0      0      1.75    1.25   0.0    0.     0.
PATTERN  4       0      0      0      0      1.5     0.5    0.0    0.     0. 

! that's the end of IMPTEST
