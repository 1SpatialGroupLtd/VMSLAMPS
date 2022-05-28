! =========================================================================
!  OSTF_PLUS.FRT  -  for data from OSTF+
!
!  Written by OS R&D			March 1987
!  Revised by KJM, OS PS		21-JUL-87	< E230 col/Group >
!  ACD definitions added by RJH, LSL	26-Nov-1987
!==========================================================================
! 
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	1	0	0	0	Unknown feature type
FRT	1	1	5	0	0	0	Building (public)
FRT	2	1	2	0	0	0	Building (minor)
FRT	3	1	5	0	0	0	Building (other)
FRT	4	1	5	0	0	10	Building (open sided)					
FRT	5	1	2	0	0	10	Building division
FRT	6	1	7	0	0	10	Archway symbol
FRT	7	1	8	0	0	81	Parish boundary
FRT	8	1	8	0	0	82	District boundary
FRT	9	1	8	0	0	83	County boundary
FRT	10	1	8	0	0	84	Electoral division boundary
FRT	11	7	9	0	.5	5	Boundary post/stone
FRT	12	8	8 	0	3	11	Boundary: full mereing symbol
FRT	13	8	8	0	2	10	Boundary: half mereing symbol
FRT	14	1	3	0	0	20	Railway (narrow gauge)
FRT	15	1	3	0	0	0	Railway (std gauge)
FRT	16	1	3	0	0	12	Railway (underground)
FRT	17	1	8       0	0	7	Boundary General
FRT	18	1	8	0	0	12	Railway (disused)
FRT	19	1	8	0	0	12	Railway (dismantled)
FRT	20	1	7	0	0	0	Railway (switch)
FRT	21	1	7	0	0	5	Road edge of carriageway
FRT	23	1	5	0	0	25	Path (um)
FRT	24	7	7	0	1	1	Minor control point
FRT	25	7	9	0	1	7	Trig point
FRT	26	8	3	0	2	8	Bench mark
FRT	27	7	3	0	1	1	Surface level
FRT	28	10	9	0	1	1	Name
FRT	29	1	7	0	0	0	Fence,wall etc (road)
FRT	30	1	3	0	0	0	Fence,wall (non road)
FRT	31	1	5	0	0	25	Svyd pecks (road)
FRT	32	1	3	0	0	5	Svyd pecks (non road)
FRT	33	1	9	0	0	22	Tunnel alignment
FRT	34	1	9	0	0	12	Subway alignment
FRT	35	1	3	0	0	12	Unsvyd pecks plotted
FRT	36	1	3	0	0	12	Unsvyd pecks not plotted
FRT	37	8	3	0	.5	6	TCB (GPO)
FRT	38	8	3	0	.5	6	TCB (AA)
FRT	39	8	3	0	.5	6	TCB (RAC)
FRT	40	7	3	0	.5	5	Telephone post/pillar (GPO)
FRT	41	7	3	0	.5	5	Telephone post/pillar (AA)
FRT	42	7	3	0	.5	5	Telephone post/pillar (RAC)
FRT	43	1	2	0	0	25	Telephone line
FRT	44	1	9	0	0	0	Pipe line obstacle
FRT	45	1	9	0	0	12	Pipe line non obstacle
FRT	46	1	9	0	0	25	Aerial ropeway
FRT	47	1	3	0	0	25	Elect trans line
FRT	48	8	3	0	1	9	Elect pylon (standard)
FRT	49	9	3	0	0	9	Elect pylon (surveyed)
FRT	50	1	3	0	0	0	Elect pylon (part)
FRT	51	7	3	0	1	5	Electricity posts - surveyed
FRT	52	1	3	0	0	0	Step treads
FRT	53	8	9	0	2	5	Cave symbol
FRT	54	7	9	0	2	1	Antiquity symbol
FRT	55	1	9	0	0	25	Antiquity pecks
! what happened to 56
FRT	57	7	9	0	.5	5	Point feature (dot)
FRT	58	7	9	0	.5	5	Point feature (circle)
FRT	59	1	3	0	0	0	Bank of double river
FRT	60	1	3	0	0	0	Bank of canal
FRT	61	1	3	0	0	0	Bank of double drain
FRT	62	1	3	0	0	0	Bank of lake/pond
FRT	63	1	3	0	0	0	Bank of moat
FRT	64	1	3	0	0	0	Single stream
FRT	65	1	3	0	0	0	Single drain
FRT	66	1	7	0	0	12	Water feature CL
FRT	67	8	7	0	4	8	Flow arrow - large
FRT	68	8	7	0	3	8	Flow arrow - medium
FRT	69	8	7	0	2	8	Flow arrow - small
FRT	70	8	9	0	1	3	Culvert bar
FRT	71	1	7	0	0	0	Mean High Water line
FRT	72	1	3 	0	0	0	Mean Low  Water line
FRT	73	1	3 	0	0	25	Ferry
FRT	74	1	10 	0	0	0	Generalised coastline
FRT	75	1	2	0	0	0	Contour
! what happened to 76
FRT	77	1	8	0	0	85	Boundary - London Borough
FRT	78	1	11	0	0	84	Boundary - Ward
FRT	79	1	11	0	0	84	Boundary - Parliamentary Const
FRT	80	1	5	0	0	25	Track CL
FRT	81	1	7	0	0	25	Track
FRT	82	7	3	0	.5	5	Water point feature
FRT	83	1	7	0	0	15	Road pecks (pavement)
FRT	84	1	2	0	0	25	Unsvyd pecks plotted
FRT	85	1	3	0	0	0	CL Motorway dual c'way
FRT	86	1	3	0	0	0	CL Motorway sngle c'way
FRT	87	1	3	0	0	0	CL Motorway roundabout
FRT	88	1	3	0	0	0	CL Motorway slip road
FRT	89	1	3	0	0	0	CL Trunk/main dual c'way
FRT	90	1	3	0	0	0	CL Trunk/main sngl c'way
FRT	91	1	3	0	0	0	CL Trunk/main roundabout
FRT	92	1	3	0	0	0	CL Secondary dual c'way
FRT	93	1	3	0	0	0	CL Secondary sngle c'way
FRT	94	1	3	0	0	0	CL Secondary roundabout
FRT	95	1	3	0	0	0	CL Minor dual c'way
FRT	96	1	3	0	0	0	CL Minor s c'way > 4m
FRT	97	1	3	0	0	0	CL Minor s c'way < 4m
FRT	98	1	2	0	0	0	CL Minor other roads
FRT	99	1	3	0	0	0	CL Minor roundabout
FRT	100	1	7	0	0	0	CL Railway - multi track
FRT	101	1	7	0	0	0	CL Railway- single track
FRT	102	1	7	0	0	25	CL Railway - sidings
FRT	103	1	5	0	0	0	Alignment feature
FRT	104	1	7	0	0	10	Normal tidal limit
FRT	105	1	8	0	0	0	Rare feature code - solid
FRT	106	1	8	0	0	25	Rare feature code - pecked
FRT	107	8	8	0	2	5	Rare feature code - symbol
FRT	108	1	9	0	0	25	Surveyed pecks - type B
FRT	109	1	7	0	0	0	Railway buffers/retarders
FRT	112	1	10	0	0	0	Leader arrow (1:50000)
FRT	141	1	10	0	0	10	Path/towpath
FRT	143	1	10	0	0	0	Bridge/subway/viaduct
FRT	146	7	10	0	2	3	Footbridge
FRT	151	1	10	0	0	10	Building line (non road) squared
FRT	153	1	10	0	0	0	Vegetation bdy fenced (non road)
FRT	161	1	10	0	0	10	Cutting
FRT	162	1	10	0	0	10	Embankment
FRT	167	7	10	0	2	5	Landmark (circle)
FRT	168	7	10	0	2	6	Church (with spire)
FRT	170	7	10	0	2	7	Church (with no tower or spire)
FRT	172	1	10	0	0	0	Gate on road
FRT	175	7	10	0	2	5	Mile post/stone
FRT	176	7	10	0	2	5	TV/Wireless mast
FRT	177	7	10	0	2	2	Windmill
FRT	178	7	10	0	2	2	Windpump
FRT	189	7	10	0	.5	5	Spot height (dot)
FRT	190	7	10	0	.5	5	Spot height (circle)
FRT	193	1	10	0	0	3	Limit of sand/mud/shingle
FRT	206	7	10	0	2	5	Well
FRT	216	7	10	0	2	5	Lighthouse (used)
FRT	218	8	10	0	1	6	Single building (min size)
FRT	272	1	10	0	0	0	Mway dual cway (casing)
FRT	273	1	10	0	0	0	Mway slip road (casing)
FRT	274	1	10	0	0	0	Mway under const (casing)
FRT	275	1	10	0	0	0	Main road (casing)
FRT	276	1	10	0	0	8	Main road (casing pecks)
FRT	277	1	10	0	0	0	Main road dual cway (casing)
FRT	278	1	10	0	0	8	Main road dual cway (casing pecks)
FRT	279	1	10	0	0	0	Main road under const (casing)
FRT	280	1	10	0	0	0	Main road dual cway under const (casing)
FRT	281	1	10	0	0	0	Narrow main road (casing)
FRT	282	1	10	0	0	8	Narrow main road (casing pecks)
FRT	283	1	10	0	0	0	Secondary road (casing)
FRT	284	1	10	0	0	8	Secondary road (casing pecks)
FRT	285	1	10	0	0	0	Secondary road dual cway (casing)
FRT	286	1	10	0	0	8	Secondary road dual cway (casing pecks)
FRT	287	1	10	0	0	0	Narrow secondary road (casing)
FRT	288	1	11	0	0	84	Euro const bdy
FRT	289	1	10	0	0	0	Minor road dual cway (casing)
FRT	290	1	10	0	0	8	Minor road dual cway (casing pecks)
FRT	291	1	10	0	0	0	Minor road (+4m) (casing)
FRT	292	1	10	0	0	8	Minor road (+4m) (casing pecks)
FRT	293	1	10	0	0	0	Minor road (-4m) (casing)
FRT	294	1	10	0	0	8	Minor road (-4m) (casing pecks)
FRT	295	1	10	0	0	0	Minor road other (casing)
FRT	296	1	10	0	0	8	Minor road other (casing pecks)
FRT	297	1	10	0	0	25	Road tunnel pecks
FRT	298	1	10	0	0	25	Railway tunnel pecks
! what is 299
FRT	300	1	10	0	0	0	CL Thick single stream (.2mm)
FRT	311	1	5	0	0	5	Public building above ULC
FRT	312	1	5	0	0	10	Public building below ULC
FRT	313	1	3	0	0	5	Other building above ULC
FRT	314	1	5	0	0	10	Other building below ULC
FRT	315	9	3	0	0	6	Flare stack/Lighting tower (surveyed)
FRT	316	8	3	0	2	6	Flare stack/Lighting tower (standard)
FRT	317	1	3	0	0	0	Flare stack/Lighting tower (part)
FRT	318	1	7	0	0	5	Building Minor Pecks
FRT	319	1	5	0	0	10	Building Important Pecks
FRT	320	7	5	0	.5	2	Polygon Point-Important Building
FRT	321	7	3	0	.5	2	Polygon Point-General Building
FRT	322	7	9	0	.5	2	Polygon Point-Minor Building
FRT	323	7	4	0	.5	2	Polygon Point-Glasshouse
FRT	324	1	4	0	0	0	Building Important/Road Casing
FRT	325	1	2	0	0	0	Building General/Road Casing
FRT	326	1	4	0	0	0	Road Casing/Building Minor
FRT	327	1	4	0	0	8	Building Important Pecks/Road Casing Pecks
FRT	328	1	2	0	0	8	Building General Pecks/Road Casing Pecks
FRT	329 	1	2	0	0	8	Road Casing Pecks/Building Minor Pecks
FRT	330	1	4	0	0	0	Road Casing/Bank of Double River
FRT	331	1	4	0	0	0	Road Casing/Bank of Double Drain
FRT	332	1	4	0	0	0	Road Casing/Bank of Lake,Pond
FRT	333	1	2	0	0	8	Single Stream/Road Casing Pecks
FRT	334	1	2	0	0	8	Single Drain/Road Casing Pecks
!FRT	335	1	10	0	0	8	Building Important Above ULC/Road Casing
!FRT	336	1	10	0	0	8	Building Important Below ULC/Road Casing
!FRT	337	1	10	0	0	8	Building General Above ULC/Road Casing
!FRT	338	1	10	0	0	8	Building General Below ULC/Road Casing
FRT	339	1	11	0	0	0	Fence (non-road)/Bank of Lake,Pond
FRT	340	1	11	0	0	0	Fence (non-road)/Bank of Double River
FRT	341	1	11	0	0	0	Fence (non-road)/Bank of Double Drain
FRT	342	1	11	0	0	0	Fence (non-road)/Building Minor
FRT	343	1	2	0	0	0	MHW/MLW
FRT	344	1	2	0	0	0	MHW/Fence (non-road)
FRT	345	1	2	0	0	0	MHW/Building Important
FRT	346	1	2	0	0	0	MHW/Building General
FRT	347	1	2	0	0	0	MHW /Building Minor
FRT	348	1	10	0	0	8	MHW/Building Important Pecks
FRT	349	1	10	0	0	8	MHW/Building General Pecks
FRT	350	1	10	0	0	8	MHW/Building Minor Pecks 
FRT	351	1	2	0	0	0	MHW/Road Casing
FRT	352	1	3	0	0	0	CL Motorway dual c'way (under)
FRT	353	1	3	0	0	0	CL Motorway sngle c'way (under)
FRT	354	1	3	0	0	0	CL Motorway roundabout (under)
FRT	355	1	3	0	0	0	CL Motorway slip road (under)
FRT	356	1	3	0	0	0	CL Trunk/main dual c'way (under)
FRT	357	1	3	0	0	0	CL Trunk/main sngl c'way (under)
FRT	358	1	3	0	0	0	CL Trunk/main roundabout (under)
FRT	359	1	3	0	0	0	CL Secondary dual c'way (under)
FRT	360	1	3	0	0	0	CL Secondary sngle c'way (under)
FRT	361	1	3	0	0	0	CL Secondary roundabout (under)
FRT	362	1	3	0	0	0	CL Minor dual c'way (under)
FRT	363	1	3	0	0	0	CL Minor s c'way > 4m (under)
FRT	364	1	3	0	0	0	CL Minor s c'way < 4m (under)
FRT	365	1	2	0	0	0	CL Minor other roads (under)
FRT	366	1	3	0	0	0	CL Minor roundabout (under)
FRT	367	1	7	0	0	0	CL Railway - multi track (under)
FRT	368	1	7	0	0	0	CL Railway- single track (under)
FRT	369	1	7	0	0	25	CL Railway - sidings (under)
FRT	370	1	7	0	0	12	Water feature CL (under)
FRT	371	1	5	0	0	25	Track CL (under)
FRT	398	1	6	0	0	0	Grid lines
FRT	399	10	9	0	0	0	Plotted number
FRT	555	10	2	0	1	1	PS Blue Point Annotation
FRT	600	12	1	0	0	-1	TEST COLOURS
FRT	601	12	2	0	0	-1	TEST COLOURS
FRT	602	12	3	0	0	-1	TEST COLOURS
FRT	603	12	4	0	0	-1	TEST COLOURS
FRT	604	12	5	0	0	-1	TEST COLOURS
FRT	605	12	6	0	0	-1	TEST COLOURS
FRT	606	12	7	0	0	-1	TEST COLOURS
FRT	607	12	8	0	0	-1	TEST COLOURS
FRT	608	12	9	0	0	-1	TEST COLOURS
FRT	609	12	10	0	0	-1	TEST COLOURS
FRT	610	12	11	0	0	-1	TEST COLOURS
FRT	611	12	12	0	0	-1	TEST COLOURS
FRT	612	12	13	0	0	-1	TEST COLOURS
FRT	613	12	14	0	0	-1	TEST COLOURS
FRT	614	12	15	0	0	-1	TEST COLOURS
FRT	615	12	16	0	0	-1	TEST COLOURS
FRT	800	1	1	0	0	0	PS Blue Point(line)
FRT	801	1       4	0	0	5	PS Blue Point(pecks)
FRT	802	1	2	0	0	0	PS Blue Point(line)
FRT	803	1	2	0	0	0	PS Blue Point(line)
FRT	804	1	2	0	0	0	PS Blue Point(line)
FRT	805	1	2	0	0	0	PS Blue Point(line)
FRT	806	1	2	0	0	0	PS Blue Point(line)
FRT	807	1	2	0	0	0	PS Blue Point(line)
FRT	808	1	2	0	0	0	PS Blue Point(line)
FRT	809	1	2	0	0	0	PS Blue Point(line)
FRT	810	1	2	0	0	0	PS Blue Point(line)
FRT	899	1	2	0	0	0	PS Blue Point(line)
FRT	900	8	2	0	.5	1	PS Blue Point
FRT	901	8       2       0       .5	1	PS Blue Point
FRT	902	8	2	0	.5	1	PS Blue Point
FRT	903	8	2	0	.5	1	PS Blue Point
FRT	904	8	2	0	.5	1	PS Blue Point
FRT	905	8	2	0	.5	1	PS Blue Point
FRT	906	8	2	0	.5	1	PS Blue Point
FRT	907	8	2	0	.5	1	PS Blue Point
FRT	908	8	2	0	.5	1	PS Blue Point
FRT	909	8	2	0	.5	1	PS Blue Point
FRT	910	8	2	0	.5	1	PS Blue Point
FRT	999	8	2	0	.5	1	PS Blue Point(default)
FRT	1001	12	2	0	0	6	Special Fill Areas
FRT	1002	12	2	0	0	5	Special Fill Areas
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
SCT	65	2	0	0	0	0	! CLOCKWISE ARC
SCT	66	3	0	0	0	0	! ANTICLOCKWISE ARC
SCT	67	4	0	0	0	0	! CIRCUMCIRCLE ARC
SCT	68	5	0	0	0	0	! FULL CIRCUMCIRCLE

! then the group definitions
!	name	   range,range
GROUP	ROADS		29,31,324-338,351
GROUP	BUILDING	1,2,3,4,5,311-314,318,319,324-329,335,336,337,338,342,345-350
GROUP	POLYPT		320,321,322,323			
GROUP	FENCES		30,108,344,324-342,351
GROUP	WATER		59,60-65,67-72,74,82,104,330,331-334,339,340,341,343,351
GROUP	IMPORTANT	1,311,312,319,320,336,335,345,348,324,327
GROUP	GENERAL		3,4,321,325,346,349,314,328,313
GROUP	RAILWAYS	14-16,20,109
GROUP	BOUNDARIES	7-13,17,77-79,288
GROUP	ARCHAEOLOGY	54,55
GROUP	SYMBOLS		24-27,37-51,53,57,58,73,315,316
GROUP	CENTRES		66,80,85-102,352-371
GROUP	PECKS		33-35,84,23,108,31,16
GROUP	MDETAIL		2,32,36,52,81,103,105,106,107,21,83,318
GROUP	CLUNDER		352-371
GROUP	GRID		398
GROUP   PSBLUE          800-899

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
   	   	 			
! Attribute codes
!
!	Code	Name		Minimum		Maximum

ACD TABLE	1		! OSTF+ definitions
!
ACD D	1	SURVEY_DATE	17-NOV-1858	31-DEC-9999
ACD D	2	CHANGE_DATE	17-NOV-1858	31-DEC-9999
ACD I	3	CHANGE_TYPE	48		54
ACD I	4	CAPTURE_XY	48		79
ACD I	5	CAPTURE_Z	48		79
ACD I	6	SECURITY_MARKER	0		1

! that's the end of OSTF_PLUS.FRT
