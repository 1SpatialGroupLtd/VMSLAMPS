! This is the definitive Feature Representation Table (FRT) file DMA.FRT 
! for the US Bureau DMA/DIA contract.  ATT 7/9/1985 
! NB. 4 pen plotter 1=blue, 2=red, 3=black, 4=purple
! FRT modified for LSL Cambridge 3 pen plotter.    AG 17/4/86
! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT     0       1       3       0       0       0       Corner points
FRT     1       7       7	0       1       1       Spot heights
FRT	2	1	3	0	0	0	Rivers (single)
FRT	3	1	3	0	0	0	Rivers (double)
FRT	4	1	1	0	0	0	Lakes/Coast
FRT	5	1	14	0	0	0	Interm. Contours
FRT	6	1	7	0	0	0	Index Contours
FRT	7	1	2	0	0	7	Suppl. Contours
FRT	8	1	1	0	0	8	Suppl. Drainage
FRT	9	1	20	0	0	9	Ridgelines
FRT	10	1	2	0	0	0	Cliffs
FRT	14	1	1	0	0	0	New coastline code
FRT     27      7       7	0       1       1       Spot heights again
FRT	28	10	3	0	4	1	Text Entry
FRT	64	10	2	0	4	1	Text Entry
FRT	101     1       1       0       0       0       arrow symbols
FRT	102     1       2       0       0       0       box symbols
FRT	200     7       2       0       1       3       RIV3D Spot heights

! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	2	0	Linear
SCT	1	1	0	0	1	0	Linear
SCT	2	2	0	0	0	0	arc
SCT	3	3	0	0	0	0	circ
SCT	4	4	0	0	0	0	circum arc
SCT	5	5	0	0	0	0	full circum circ
SCT	6	6	0	0	0	0	curve
SCT	7	7	0	0	0	0	uno sym
SCT	8	8	0	0	0	0	ori sym
SCT	9	9	0	0	0	0	scaled sym

! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width

PATTERN  7	 0	0      0      0      4.00    3.5    0.0    0.0    0.0
PATTERN  8	 0	0      0      0      2.00    1.7    0.0    0.0    0.0
PATTERN  9	 0	0      0      0      4.00    3.5    0.0    0.0    0.0

! that's the end of DMA.FRT
