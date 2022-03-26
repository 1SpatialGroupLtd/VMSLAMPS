! NWW Feature Representation Table (FRT) file NWW.FRT
! ===================================================
!
! Created	MJQ		14-Jun-1990
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	1	0.0	0	0	Null
FRT	1	1	4	0.7	0	0	Trunk main
FRT	2	1	2	0.5	0	0	Distribution main
FRT	3	1	1	0.5	0	0	Temp invisible segment
FRT	50	1	3	0.35	0	0	Service pipe
FRT	51	1	3	0.25	0	10	Private pipe
FRT	60	1	2	0.5	0	10	Abandoned main
FRT	70	7	3	0.15	1	23	System Node (T-junct)
FRT	71	7	5	0.15	1	23	Termination node
FRT	72	8	1	0.15	2	20	End Cap
FRT	100	8	1	0.15	1	13	Sluice Valve (anti)
FRT	101	8	1	0.15	1	34	Sluice Valve (clockwise)
FRT	102	8	1	0.15	1	27	Closed Valve
FRT	103	8	3	0.15	2	40	Emptying valve
FRT	104	8	6	0.15	2	19	Pressure Reducing Valve
FRT	105	8	2	0.15	2	18	Reflux Valve
FRT	110	8	4	0.15	1	14	Air Valve
FRT	120	8	2	0.15	1	28	Fire Hydrant
FRT	121	7	2	0.15	1	15	Hydrant Washout
FRT	122	8	5	0.15	1	16	Meter (noded, with 123)
FRT	123	8	6	0.15	0.8	17	Meter (unnoded)
FRT	131	8	4	0.15	2	41	Anode
FRT	132	8	1	0.15	1	42      Booster Pump
FRT	140	8	2	0.15	1	50	Pipe Change
FRT	141	8	1	0.15	1	43	Stop Cock
FRT	150	8	3	0.15	1	44	Confined Space
FRT	160	8	3	0.15	1	45	Dialysis unit
FRT	161	8	3	0.15	1	51	Intermediate
FRT	163	8	3	0.15	1	46	Telemetry Station
FRT	202	10	1	0.15	1	1	Street Names
FRT	210	7	4	0.15	1	23	Edge node
!
FRT	397	10	1	0.50	6	1	Titles
FRT	398	1	1	0.15	0	0	Grid lines
FRT	399	10	1	0.15	0	0	Plotted number
FRT	400	10	1	0.50	1	1	Titles
FRT	401	10	5	0.15	1	1	Attribute Data
!
! JOHN BURROWS SYMBOLS
FRT	402	7	2	0.15	1	15	Hydrant
FRT	403	1	2	0.30	0	0	Pipe Line
FRT	404	8	2	0.15	1	13	Sluice Valve
FRT	405	8	2	0.15	2	19	Pressure Reducing Valve
FRT	420	8	2	0.15	1	14	Air Valve
FRT	427	8	2	0.15	1	17	Meter
FRT	428	8	2	0.15	1	16	Hatch Box
FRT	429	8	2	0.15	2	18	Reflux Valve
FRT	430	8	2	0.15	2	20	Cap End
FRT	431	8	2	0.15	2	21	Pipe Change
FRT	432	8	2	0.15	2	22	Mains Crossing
FRT	433	7	3	0.15	1	23	System Node
FRT	434	9	2	0.15	10	24	Compass Logo
FRT	435	8	2	0.15	1	25	Double Air Valve
FRT	436	8	2	0.15	1	26	Washout Valve
FRT	437	8	2	0.15	1	27	Closed Valve
FRT	438	8	2	0.15	1	28	Fire Hydrant
FRT	439	8	2	0.15	1	29	Washout Hydrant
FRT	440	8	2	0.15	1	30	Swabbing Pit
FRT	441	8	2	0.15	1	31	Pipe Change (Legend)
FRT	442	8	2	0.15	500	32	LSL Logo
FRT	443	9	2	0.15	1	33	JBP Logo
FRT	444	8	2	0.15	1	34	Sluice Valve (Clockwise)
FRT	445	7	3	0.15	1	23	Edge Node
FRT	446	10	2	0.15	1	1	Compass N
FRT	447	10	2	0.15	1	1	Associated Symbol Text
FRT	448	9	5	0.15	2	8	Pointer
FRT	449	1	5	0.15	0	95	Pointer
!
FRT	999	7	5	0.15	1	1	Symbol point for text
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
SCT	10	12	0	0	0	-1	fill symbol
SCT	65	2	0	0	0	0	! CLOCKWISE ARC
SCT	66	3	0	0	0	0	! ANTICLOCKWISE ARC
SCT	67	4	0	0	0	0	! CIRCUMCIRCLE ARC
SCT	68	5	0	0	0	0	! FULL CIRCUMCIRCLE
!
! then the group definitions
!	name	   range,range
GROUP	WATER		59,60-65,67-72,74,82,104
GROUP	IMPORTANT	1
GROUP	GENERAL		3,4
GROUP	SYMBOLS		24-27,37-51,53,57,58,73,315,316
GROUP	GRID		398,998
!
! then the pattern definitions
!	Pattern  Major  Minor  Major  Minor  Overall Major  Minor  Major  Minor
!	Index	 UC     UC     Repeat Repeat Size    Size   Size   Width  Width
!
PATTERN	1	 0	0      0      0      1.8     1.4    0      0	  0
PATTERN	2        0      0      0      0      1.2     0.8    0.0    0.     0.
PATTERN	3        0      0      0      0      3.0     2.7    0.0    0.     0.
PATTERN	5        0      0      0      0      0.9     0.6    0.0    0.     0.
PATTERN	6        5      0      0      0      1.8     0.6    0.0    0.3    0.
PATTERN	7        12     0      0      0      2.58    1.8    0.0    0.9    0.
PATTERN	8        0      0      0      0      2.4     1.44   0.0    0.     0.
PATTERN 9	 0	0      0      0      1.5     1.0    0.0    0.     0.
PATTERN	10       0      0      0      0      1.8     1.2    0.0    0.     0.
!
!
ACD TABLE	0	
!
!
!     number    name
ACD I	100	Attribute Code pointer
ACD I	101	Collect Attribute
ACD I	102	Complete Feature ref
ACD I	103	Furniture Suffix
ACD I	104	Imperial size
ACD I	105	Location status
ACD I	106	Lining type
ACD I	107	Mains Material
ACD I	108	Metric Main size
ACD I	109	Pipe Type
ACD I	110	Name text
ACD I	111	Owning Main Name
ACD I	112	Parent node type
ACD I	113	Street name
ACD I	114	Symbol/Text Attribute
ACD I	115	Trade Main
ACD I	116	Traceable Status
ACD I	117	Confined Space Number
ACD I	118	Type of Confined Space
ACD I	119	Year Laid
ACD I	120	Reconditioned Year
ACD I	121	fred
!	
! that's the end of NWW.FRT
