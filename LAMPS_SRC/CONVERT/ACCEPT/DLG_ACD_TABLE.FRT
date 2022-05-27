! USGS 24/50 verification plot Feature Representation Table (FRT) DLGVER.FRT
! version 2 PGH 28/1/86

! first the FRT itself
!   	FC	GT	Colour	Width	Size	SC	Description
FRT	0	1	1	0	0	0	Unknown feature type
FRT	1	7	1	0	0.5	7	areas
FRT	2	7	2	0	0.5	5	nodes
FRT	3	1	3	0	0	0	lines
FRT	4	8	4	0	0.3	6	points (degen. lines)
FRT	10	7	2	0	2.0	1	corner points
FRT	11	10	2	0	5	1	text annotation
FRT	64	1	1	0	0	0	Unknown feature type
FRT	101	10	1	0	2	1	area annotation
FRT	102	10	2	0	2	1	node annotation
FRT	103	10	3	0	2	1	line annotation
FRT	104	10	4	0	2	1	point annotation
! then the SCT which defines symbol components
!   	FC	GT	Colour	Width	Size	SC	Description
SCT	0	1	0	0	0	0	linear
SCT	1	1	0	0	0	0	linear
SCT	2	2	0	0	0	0	clockwise arc
SCT	3	3	0	0	0	0	anticlockwise arc
SCT	4	4	0	0	0	0	circumcircle arc
SCT	5	5	0	0	0	0	full circumcircle
SCT	6	6	0	0	0	0	interpolated curve

! then the group definitions
!	name	   range,range
!GROUP	CENTRES		66,80,85-102,352-371

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
!==============================================================================
!
!   A T T R I B U T E   C O D E S
!
!==============================================================================
!
!
ACD TABLE 0
ACD I	120	HYDROGRAPHYTEST
!
!
!==============================================================================
!
!
ACD TABLE	1		! Header record contents ( 1:24,000 scale)
!
!********************************************************************
! DO NOT ALTER THE NAMES IN THIS TABLE AS THEY ARE ENCODED IN I2DLG
!********************************************************************
!
!	Code	Name
!
! A.1 record
ACD I     1	CARTO_UNIT		! held in text string (A40)
ACD I	  2	SOURCE_MATER            ! held in text string (A10)
ACD C	  3	DATE_QUAL		! P, L or I
ACD I	  4	SOURCE_SCALE
ACD C	  5	QUAD_NUMBER
ACD C	  6	CONT_INT_L
ACD C	  8	BATHY_INT_L
ACD C	  9	CONT_INT_S
ACD C	 11	BATHY_INT_S
ACD C	 12	FLAG_A
ACD C	 13	FLAG_B
ACD C	 14	FLAG_C
ACD C	 15	EDGE_FLAG
ACD C	 16	EDGEWS
ACD C	 17	EDGEWR
ACD C	 18	EDGENS
ACD C	 19	EDGENR
ACD C	 20	EDGEES
ACD C	 21	EDGEER
ACD C	 22	EDGESS
ACD C	 23	EDGESR
ACD I	 24	REG_SW_LONG             ! held in text string (A24)
ACD I	 25	REG_SW_LAT		! held in text string (A24)
ACD I	 26	REG_NW_LONG             ! held in text string (A24)
ACD I	 27	REG_NW_LAT		! held in text string (A24)
ACD I	 28	REG_NE_LONG		! held in text string (A24)
ACD I	 29	REG_NE_LAT		! held in text string (A24)
ACD I	 30	REG_SE_LONG		! held in text string (A24)
ACD I	 31	REG_SE_LAT		! held in text string (A24)
ACD I	 32	PROJ_A_ONE  		! held in text string (A24)
ACD I	 33	PROJ_A_TWO   		! held in text string (A24)
ACD I	 34	PROJ_A_THREE		! held in text string (A24)
ACD I	 35	PROJ_A_FOUR  		! held in text string (A24)
!
! Special Areas
!
ACD I   998	OUTSIDE_AREA
ACD I   999	BACKGROUND_AREA
!
!=======================================================================
!
ACD TABLE	2		! DLG base categories on 1:24,000 scale
!
! The codes and names in this table are user defineable.
!
!	Code	Name			Minimum	Maximum	Min. Step
!
!               01234567890123456789
ACD I	020	HYPSOGRAPHY	    	0	614
ACD I	021	HYPSOGRAPHY_ELEV_A      0	9999
ACD I	022	HYPSOGRAPHY_ELEV_B      0	9999
ACD I	023	HYPSOGRAPHY_ELEV_C      0	9999
ACD I	024	HYPSOGRAPHY_ELEV_D      0	9999
ACD I	025	HYPSOGRAPHY_ELEV_E      0	9999
ACD I	026	HYPSOGRAPHY_ELEV_F      0	9999
ACD I	027	HYPSOGRAPHY_ELEV_G      0	9999
ACD I	028	HYPSOGRAPHY_ELEV_H      0	9999
ACD I	029	HYPSOGRAPHY_COINC       0	99
ACD I	050	HYDROGRAPHY      	0	618
ACD I	051	HYDROGRAPHY_ELEV_FT	0	9999
ACD I	052	HYDROGRAPHY_ELEV_M      0	9999
ACD I	053	HYDROGRAPHY_ANGLE       0	999
ACD I	055	HYDROGRAPHY_RIV_MILE  	0	9999
ACD I	056	HYDROGRAPHY_FT_BELOW	0	9999
ACD I	057	HYDROGRAPHY_M_BELOW	0	9999
ACD I	058	HYDROGRAPHY_BEST_EST	0	0
ACD I	059	HYDROGRAPHY_COINC       0	99
ACD I	070	SURFACE_COVER		0	201
ACD I	078	SURFACE_COVER_BEST	0	0
ACD I	079	SURFACE_COVER_COINC	0	99
ACD I	080	NON_VEG_SUFACE_COVER	0	300
ACD I	088	NON_VEG_SUFACE_BEST     0	0
ACD I	089	NON_VEG_SUFACE_COINC	0	99
ACD I	090	BOUNDARIES		0	301
ACD I	091	BOUNDARIES_FIPS_CODE	0	99
ACD I	092	BOUNDARIES_CNTY_FIPS    0	999
ACD I	095	BOUNDARIES_MONUMENT	0	9999
ACD I	099	BOUNDARIES_COINC	0	99
ACD I	150	SURVEY_CONTROL		0	609
ACD I	151	SURVEY_CONTROL_A		
ACD I	152	SURVEY_CONTROL_B
ACD I	153	SURVEY_CONTROL_C
ACD I	154	SURVEY_CONTROL_D
ACD I	156	SURVEY_CONTROL_E
ACD I	159	SURVEY_CONTROL_F
ACD I	170	TRANSPORT_ROAD
ACD I	171	TRANSPORT_ROAD_A
ACD I	172	TRANSPORT_ROAD_B
ACD I	173	TRANSPORT_ROAD_C
ACD I	174	TRANSPORT_ROAD_D
ACD I	175	TRANSPORT_ROAD_E
ACD I	176	TRANSPORT_ROAD_F
ACD I	177	TRANSPORT_ROAD_G
ACD I	178	TRANSPORT_ROAD_H
ACD I	179	TRANSPORT_ROAD_I
ACD I	180	TRANSPORT_RAIL
ACD I	181	TRANSPORT_RAIL_A
ACD I	188	TRANSPORT_RAIL_B
ACD I	189	TRANSPORT_RAIL_C
ACD I	190	TRANSPORT_SYSTEMS
ACD I	193	TRANSPORT_SYSTEMS_A
ACD I	198	TRANSPORT_SYSTEMS_B
ACD I	199	TRANSPORT_SYSTEMS_C
ACD I	200	MANMADE_STRUCTURES
ACD I	202	MANMADE_STRUCTURES_A
ACD I	203	MANMADE_STRUCTURES_B
ACD I	208	MANMADE_STRUCTURES_C
ACD I	209	MANMADE_STRUCTURES_D
ACD I	300	US_PLSS
ACD I	301	US_PLSS_A
ACD I	302	US_PLSS_B
ACD I	303	US_PLSS_C
ACD I	304	US_PLSS_D
ACD I	305	US_PLSS_E
ACD I	306	US_PLSS_F
ACD I	307	US_PLSS_G
ACD I	308	US_PLSS_H
ACD I	309	US_PLSS_I
!
