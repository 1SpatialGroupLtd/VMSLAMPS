!
! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
!
FRT	0	1	6	0	0	0	river
!
FRT	5	10	5	0	5	1	river
!
FRT	14	10	1	0	6	1	capital<100000
FRT	15	10	1	0	8	1	capital 100000-500000
FRT	16	10	1	0	10	1	capital 500000-1000000
FRT	17	10	1	0	12	1	capital 1000000-5000000
FRT	18	10	1	0	14	1	capital>5000000
!
FRT	19	10	1	0	6	1	town<100000
FRT	20	10	1	0	8	1	town 100000-500000
FRT	21	10	1	0	10	1	town 500000-1000000
FRT	22	10	1	0	12	1	town 1000000-5000000
FRT	23	10	1	0	14	1	town>5000000
!
FRT	29	10	2	0	12	1	country
!
FRT	30	10	3	0	9	1	admin area
!
FRT	99	10	4	0	7	1	physical
!
!***********************************************************************
! this is the OS Feature Representation Table (FRT) file OS.FRT
! version 2 DDE 6/6/84
! version 3 OS from DOUG.FRT by PGH and DDE  8/11/84
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
