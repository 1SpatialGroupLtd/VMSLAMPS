! Assume colour 1=black, 2=green, 3=blue, 4=red
!
! first the primary feature definitions.
!
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	100	1	1	1.0	0	0	A Rd. Dual C/way
FRT	110	12	3	0	0	3	Built up area
!
! now the supplementary representations
!
FRT	900	1	1	1.0	0	0	Black road casing
FRT	901	1	2	0.8	0	0	Green road infill
FRT	902	1	4	0.1	0	0	Red centre line
FRT	911	12	3	0	2	3	45° hatch - blue
FRT	912	12	4	0	0	0	Hollow - red border
!
! now the multi-representations
!
!   	FC	Prio	Repr	Prio	Repr	Prio	Repr	Prio	Repr
MUL	100	1	900	2	901	3	902
MUL	110	1	110	2	911	3	912
!
