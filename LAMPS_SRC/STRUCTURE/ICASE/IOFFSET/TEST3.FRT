! This is the MALVERN Feature Representation Table (FRT) file MALVERN.FRT
! Version 1 MAX 03/07/1991
!
! First the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	2	0.2	0	0	Unknown feature type
FRT	1	1	4	0.3	0	0	Important buildings
FRT	2	1	3	0.15	0	0	All other buildings
FRT	3	1	3	0.15	0	0	All other buildings
FRT	4	1	3	0.15	0	2	Building Pecks
FRT	14	1	5	0.15	0	0	Residential road solid
FRT	15	1	1	0.30	0	0	Railway Track
FRT	21	1	4	0.2	0	9	A/B Road Pecks
FRT	22	10	1	0.2	5	1	Name for plotting title
FRT	28	10	1	0.2	1	1	Name
FRT	29	1	4	0.2	0	0	A/B Road Solid
FRT	30	1	1	0.15	0	0	General Line Detail
FRT	32	1	8	0.15	0	9	General Peck Detail
FRT	33	1	5	0.15	0	9	Residential road pecks
FRT	36	1	5	0.15	0	12	Vegetation/Landform Limit
FRT	43	1	1	0.15	0	84	Overhead Peck Detail
FRT	49	9	1	0.15	0	9	Pylon
FRT	52	1	4	0.15	0	0	Minor Line Detail
FRT	57	7	3	0.15	0.5	5	Point Feature 
FRT	59	1	3	0.15	0	84	Water Feature
FRT	69	8	3	0.15	2	8	Flow arrow
FRT	98	1	6	0.2	0	0	CL A/B Road
FRT	99	1	5	0.2	0	0	CL Residential Road
FRT	370	1	5	0.2	0	0	Wooded area (edge of)
FRT	372	7	4	0.15	0.5	1	Coniferous tree
FRT	373	7	5	0.15	0.5	1	Non-coniferous tree
FRT	398	1	1	0.15	0	0	Grid Lines
FRT	399	10	6	0.15	0	0	Plotted Number
FRT     401     12      0       0.0     0       -1 
! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	0	0	! LINEAR
SCT	1	1	0	0	0	0	line
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT	5	5	0	0	0	0	full circumcircle
SCT	6	6	0	0	0	0	interpolated curve
!
!SCT	5	6	0	0	0	0	! INTERPOLATED CURVE
SCT	65	2	0	0	0	0	! CLOCKWISE ARC
SCT	66	3	0	0	0	0	! ANTICLOCKWISE ARC
SCT	67	4	0	0	0	0	! CIRCUMCIRCLE ARC
SCT	68	5	0	0	0	0	! FULL CIRCUMCIRCLE
SCT     400     12      1       0.0     0       -1      ! FILL AREA!
! then the group definitions
!	name	   range,range
GROUP	IMPORTANT_BUILDINGS	1
GROUP	BUILDINGS		2,4
GROUP	WATER			59
GROUP	FLOW_ARROW		69
GROUP	RESIDROADS		14,33
GROUP	MAIN_ROADS		21,29
GROUP	CENTRELINES 		98
GROUP	GENLINE 		30
GROUP	GENPECKS 		32
GROUP	VEG_LANDFORM		36
GROUP	OVERHEAD_DETAIL 	43
GROUP	PYLON		 	49
GROUP	MINOR_DETAIL	 	52
GROUP	GENPOINT 		57
GROUP	TEXT			28
GROUP	GRID			398,998
!
! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width
PATTERN 1	 0	0      0      0	     1.8     1.4    0.0    0.	  0.
PATTERN 2	 0      0      0      0      1.2     0.8    0.0    0.     0.
PATTERN 3	 0	0      0      0	     3.0     2.7    0.0    0.0    0.0	
PATTERN	5        0      0      0      0      0.9     0.6    0.0    0.     0.
PATTERN	6        5      0      0      0      1.8     0.6    0.0    0.3    0.
PATTERN	7        12     0      0      0      2.58    1.8    0.0    0.9    0.
PATTERN	8        0      0      0      0      2.4     1.44   0.0    0.     0.
PATTERN	9        0      0      0      0      0.7     0.5    0.0    0.     0.
PATTERN	10       0      0      0      0      1.8     1.2    0.0    0.     0.
PATTERN	12       0      0      0      0      1.0     0.5    0.0    0.     0.
PATTERN	15       0      0      0      0      2.7     1.8    0.0    0.     0.
PATTERN	20       1      0      0      0      4.0     3.99   0.0    2.0    0.
PATTERN	22	 0      0      0      0      3.0     2.5    0.0    0.     0.
PATTERN	25       0      0      0      0      4.5     3.5    0.0    0.     0.
PATTERN	28       0      5      0      0      5.4     3.6    0.6    3.6    0.3
PATTERN	30       0      0      0      0      5.4     3.6    0.0    0.     0.
PATTERN	32       5      0      0      0      5.4     3.6    0.0    1.8    0.
PATTERN	80       0      0      0      0      14.4    9.6    0.0    0.     0.
PATTERN 81	 5	0      0      0      5.0     0.6    0.0    0.3    0.0
PATTERN 82	 0	0      0      0      9.0     6.0    0.0    0.0    0.0
PATTERN 83	 0	0      0      0      11.0    6.0    2.0    0.0    0.0
PATTERN 84	 0	0      0      0      1.2     1.0    0.0    0.0    0.0
PATTERN 85	 1      0      0      0      6.0     5.99   0.0    1.5    0.0
!  	 			
! That's the end of the MALVERN.FRT	
