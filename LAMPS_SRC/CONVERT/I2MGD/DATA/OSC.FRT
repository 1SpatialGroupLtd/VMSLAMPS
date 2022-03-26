! FRT for use with Ocean Sounding Charts and for the conversion to and from 
! IFF to MGD 77
!
! From Laserscan CONVERT package page 10-12
!
! R K TUHEY  30 JAN 1991
!
!   	 FC	 GT   Colour  Width    Size	SC	Flag	H/W
!
FRT	   0	 1	1	 0.0	 0.0	0    	
!
! Linestyles used for PROJ borders
!
FRT	   1	 1	1	 0.1	  0	0       1       1
FRT	   2	 1	2	 0.125	  0	0       1       0
!
! OSC symbols
!
FRT	   3	 8	3	 0.0	 1.0  	3    	           ! soundings
FRT	   4	 1	6	 0.1	 0.0	0       1       1  ! tracks
FRT	  51	 7	5	  0	 2.0	51	 	   ! corners
FRT       81     7	5	  0	 0.6	51                 ! DUMMY 
!                                                                  ! for 
!                                                                  ! GEBCO
!
!
! Symbols used by PROJ
!
FRT	 161	 9	4	  0	 3.0	51	! SW corner
FRT	 162	 9	4	  0	 3.0	51	! NW corner
FRT	 163	 9	4	  0	 3.0	51	! NE corner
FRT	 164	 9	4	  0	 3.0	51	! SE corner
FRT	 497	 9	2	  0      3.0	51      ! Geog intersections
FRT      498     9      6         0      1.0    598	! Degree symbol
FRT      499     9      6         0      2.0    599	! Multiplication sign
!
! Available Text Fonts
!
FRT	 801	10	6	  0	 0.0	2 	! UL italic
FRT	 802	10	6	  0	 0.0	1 	! UL upright
FRT	 803	10	5	  0	 0.0	2 	! UM italic
FRT	 804	10	5	  0	 0.0	1 	! UM upright
FRT      805    10      7         0      0.0    5 	! area fill 
FRT	 901	10	1	  0	 0.0	4 	! reduced soundings
FRT	 902	10	2	  0	 0.0	3 	! hairline soundings
FRT	 903	10	3	  0	 0.0	4 	! normal soundings
FRT	 904	10	5	  0	 0.0	3 	! spotheights
FRT	 905	10	1	  0	 0.0	3 	! contour labels
!
! symbol component definitions
! For the moment just provide a simple code for each
! graphical type (including a solid fill area)
!	FC	GT	Colour	Width	Size	SC
SCT	0	1	0	0	0	0
SCT	1	1	0	0	0	0
SCT	2	2	0	0	0	0
SCT	3	3	0	0	0	0
SCT	4	4	0	0	0	0
SCT	5	5	0	0	0	0
SCT	6	6	0	0	0	0
SCT	12	12	0	0	0       -1
!
!
! symbol drawing elements
!
!  	 FC	GT   Colour     Width  Size	SC	Flag	H/W
!
!
! LINES
! spots
SCT	101	1	0	0.1	0	0        1        1
SCT	102	1	0	0.125	0	0        1        0
SCT	103	1	0	0.152	0	0        1        2
SCT	104	1	0	0.178	0	0        1        3
SCT	105	1	0	0.2	0	0        1        4
SCT	106	1	0	0.229	0	0        1        5
SCT	107	1	0	0.250	0	0        1       99
SCT	108	1	0	0.275	0	0        1       98
SCT	109	1	0	0.300	0	0        1        6
SCT	110	1	0	0.350	0	0        1       97
SCT	111	1	0	0.400	0	0        1       96
SCT	112	1	0	0.450	0	0        1       95
SCT	113	1	0	0.500	0	0        1       94
SCT	114	1	0	0.550	0	0        1       93
SCT	115	1	0	0.600	0	0        1       92
SCT	116	1	0	0.650	0	0        1       91
SCT	117	1	0	0.700	0	0        1       90
SCT	118	1	0	0.800	0	0        1       29
SCT	119	1	0	0.900	0	0        1       28
SCT	120	1	0	1.000	0	0        1       27
!
! slits

SCT	121	1	0	0.127	0	0        1      109
SCT	122	1	0	0.178	0	0        1      110
SCT	123	1	0	0.2	0	0        1      111
SCT	124	1	0	0.290	0	0        1      112
SCT	125	1	0	0.4	0	0        1      118
SCT	126	1	0	0.6 	0	0        1      125
SCT	127	1	0	0.8	0	0        1      126
!
! squares
SCT	128	1	0	0.8	0	0        1      107
SCT	129	1	0	1.0	0	0        1      108
!
!
! CLOCKWISE ARCS
!
! spots
SCT	131	2	0	0.1	0	0        1        1
SCT	132	2	0	0.125	0	0        1        0
SCT	133	2	0	0.152	0	0        1        2
SCT	134	2	0	0.178	0	0        1        3
SCT	135	2	0	0.2	0	0        1        4
SCT	136	2	0	0.229	0	0        1        5
SCT	137	2	0	0.250	0	0        1       99
SCT	138	2	0	0.275	0	0        1       98
SCT	139	2	0	0.300	0	0        1        6
SCT	140	2	0	0.350	0	0        1       97
SCT	141	2	0	0.400	0	0        1       96
SCT	142	2	0	0.450	0	0        1       95
SCT	143	2	0	0.500	0	0        1       94
SCT	144	2	0	0.550	0	0        1       93
SCT	145	2	0	0.600	0	0        1       92
SCT	146	2	0	0.650	0	0        1       91
SCT	147	2	0	0.700	0	0        1       90
SCT	148	2	0	0.800	0	0        1       29
SCT	149	2	0	0.900	0	0        1       28
SCT	150	2	0	1.000	0	0        1       27
!
! slits
SCT	151	2	0	0.127	0	0        1      109
SCT	152	2	0	0.178	0	0        1      110
SCT	153	2	0	0.2	0	0        1      111
SCT	154	2	0	0.290	0	0        1      112
SCT	155	2	0	0.4	0	0        1      118
SCT	156	2	0	0.6 	0	0        1      125
SCT	157	2	0	0.8	0	0        1      126    
! 
! squares
SCT	158	2	0	0.8	0	0        1      107
SCT	159	2	0	1.0	0	0        1      108
!
! ANTI-CLOCKWISE ARCS
!
! spots
SCT	161	3	0	0.1	0	0        1        1
SCT	162	3	0	0.125	0	0        1        0
SCT	163	3	0	0.152	0	0        1        2
SCT	164	3	0	0.178	0	0        1        3
SCT	165	3	0	0.2	0	0        1        4
SCT	166	3	0	0.229	0	0        1        5
SCT	167	3	0	0.250	0	0        1       99
SCT	168	3	0	0.275	0	0        1       98
SCT	169	3	0	0.300	0	0        1        6
SCT	170	3	0	0.350	0	0        1       97
SCT	171	3	0	0.400	0	0        1       96
SCT	172	3	0	0.450	0	0        1       95
SCT	173	3	0	0.500	0	0        1       94
SCT	174	3	0	0.550	0	0        1       93
!SCT	175	3	0	0.600	0	0        1       92
!SCT	176	3	0	0.650	0	0        1       91
!SCT	177	3	0	0.700	0	0        1       90
!SCT	178	3	0	0.800	0	0        1       29
!SCT	179	3	0	0.900	0	0        1       28
SCT	180	3	0	1.000	0	0        1       27
!
! slits
SCT	181	3	0	0.127	0	0        1      109
SCT	182	3	0	0.178	0	0        1      110
SCT	183	3	0	0.2	0	0        1      111
SCT	184	3	0	0.290	0	0        1      112
SCT	185	3	0	0.4	0	0        1      118
SCT	186	3	0	0.6 	0	0        1      125
SCT	187	3	0	0.8	0	0        1      126
!
! squares
SCT	188	3	0	0.8	0	0        1      107
SCT	189	3	0	1.0	0	0        1      108
!
! LIT BEACON - ODDITY - *** no longer used 23/2/89 ***
!
SCT     192     1       0       0.1     0       0        1      116
!
!
!	SOLID FILL AREAS
!
SCT	201	12	1	0	0	-1
SCT	202	12	2	0	0	-1
SCT	203	12	3  	0	0	-1
SCT	204	12	4	0	0	-1
SCT	205	12	5	0	0	-1
SCT	206	12	6	0	0	-1
SCT	207	12	7	0	0	-1
SCT	208	12	8	0	0	-1
SCT	209	12	9	0	0	-1
SCT	210	12     10	0	0	-1
!
!       PATTERNED FILL AREA
!
SCT     211     12      7       0       0.1      2
SCT     212     12      7       0       0.5      5
SCT     213     12      7       0       0.05     101
!
!	ATTRIBUTE CODES
!
!
ACD TABLE       1
!
!       Header record codes
!       ===================
!
!   Type Code   Name                    Min     Max     Min     Additional
!	 		    	        value   value	step	text length
!       
ACD C	 1	M_Cruise_ID				      ! 8 chars
ACD C	 2 	M_Format_acronym			      ! 5 chars
ACD I	 3   	M_Data_Centre_no	0	99999999 1
ACD I	 4	M_Type_one_headers	1	4	1
ACD I	 5	M_Type_two_headers	0	0
ACD I	 6	M_Data_Parameters	29	29
ACD I	 7	M_Survey_code_bathy	0	5	1
ACD I	 8	M_Survey_code_mag	0	5	1
ACD I	 9	M_Survey_code_grav	0	5	1								
ACD I	 10	M_Survey_code_H_res	0	5	1	
ACD I	 11	M_Survey_code_D_pen	0	5	1
ACD I	 12	M_File_creation		10101	999999
ACD C	 13	M_Contributing_inst.			      ! 41 chars
ACD C	 14	M_Country			              ! 18 chars
ACD C 	 15	M_Platform_name				      ! 21 chars
ACD I	 16	M_Platform_type_code	0	9	1
ACD C 	 17	M_Platform_type				      ! 6 chars
ACD C	 18	M_Chief_scientist			      ! 32 chars
ACD C	 19 	M_Project_cruise_leg			      ! 58 chars
ACD C	 20	M_Funding				      ! 20 chars
ACD I	 21	M_Survey_departure	10101	999999
ACD C	 22	M_Port_of_departure			      ! 34 chars
ACD I	 23	M_Survey_arrival	10101	999999
ACD C 	 24	M_Port_of_arrival			      ! 32 chars
ACD C 	 25	M_Navigation_instr			      ! 40 chars
ACD C	 26	M_Pos_determ_method			      ! 38 chars
ACD C	 27	M_Bathy_instr				      ! 40 chars
ACD C	 28	M_Add_bathy_data			      ! 38 chars
ACD C	 29	M_Magnetics_instr			      ! 40 chars
ACD C	 30	M_Add_mag_data				      ! 38 chars
ACD C 	 31	M_Gravity_instr				      ! 40 chars
ACD C	 32	M_Add_gravity_data			      ! 38 chars
ACD C	 33	M_Seismic_instr				      ! 40 chars
ACD C	 34	M_Form_seismic_data			      ! 38 chars
ACD R	 35	M_Dig_rate_bathy	0.0	99.9	0.1
ACD C	 36	M_Samp_rate_bathy			      ! 12 chars
ACD R	 37	M_Assumed_sound_vel	0.0	9999.9	0.1
ACD I	 38	M_Bathy_datum_code	0	99	1
ACD C	 39	M_Interpolation		    		      ! 56 chars
ACD R	 40	M_Dig_rate_mag		0.0	99.9	0.1
ACD I	 41	M_Samp_rate_mag		0	99	1
ACD I	 42	M_Mag_sensor_towdist	0	9999	1
ACD R	 43	M_Mag_sensor_depth	0.0	9999.9	0.1	 
ACD I	 44	M_Mag_hor_sensor_sep	0	999	1
ACD I	 45	M_Mag_ref_field_code	0	99	1
ACD C	 46	M_Reference_field			       ! 12 chars
ACD C	 47	M_M_O_A_residual			       ! 47 chars
ACD R	 48	M_Dig_rate_gravity	0.0	99.9	0.1
ACD I	 49	M_Samp_rate_gravity 	0	99	1
ACD I	 50	M_Gravity_form_code	1	9	1
ACD C	 51	M_Gravity_formula			       ! 17 chars
ACD I	 52 	M_Ref_system_code	1	9	1
ACD C	 53	M_Reference_system			       ! 16 chars
ACD C	 54	M_Correction_applied			       ! 38 chars
ACD R	 55	M_Dep_base_stn_grav	0.0	999999.9 0.1
ACD C	 56	M_Dep_base_stn_descr			       ! 33 chars
ACD R	 57	M_Arr_base_stn_grav	0.0	999999.9 0.1
ACD C	 58	M_Arr_base_stn_descr			       ! 31 chars
ACD I	 59	M_Ten_degree_ident	0	9999	1
ACD C	 60	M_Additional_doc			       ! 78 chars
!
! JUST TO TEST IF TRACK WORKS IN OSC_DATACAP
!
ACD C    61     CRUISE_ID                                       
!
!  DATA REFERENCE CODES
!  ====================
!
!   Type Code	Name			Min	Max	Min	Additional
!   					value 	value	step	text length
!
ACD C	 101	M_Data_cruise_ident			       ! 8 chars
ACD R	 102	M_Data_time_zone_cor	-13.0	99.9	0.01
ACD I	 103	M_Data_date		10101	999999
ACD I	 104	M_Data_time_hours	0	99
ACD R	 105	M_Data_time_mins	0.0	99.999
ACD I	 106	M_Data_pos_type_code	1	9	1
ACD R	 107	M_Data_bathy_travel	0.0	99.9999 0.0001
ACD R	 108	M_Data_bathy_correct	0.0	99999.9 0.1
ACD I	 109	M_Data_bathy_co_code	1	99	1
ACD I	 110	M_Data_bathy_ty_code	1	9	1
ACD R	 111	M_Data_mag_total_one	0.0	99999.9 0.1
ACD R	 112	M_Data_mag_total_two	0.0	99999.9	0.1
ACD R	 113	M_Data_mag_residual	-9999.9 9999.9	0.1
ACD I	 114	M_Data_sens_residual	1	9	1
ACD R	 115	M_Data_mag_diurn_cor	-999.9	999.9	0.1
ACD I	 116	M_Data_alt_mag_sens	-99999	99999	1
ACD R	 117	M_Data_obs_gravity	0.0	999999.9 0.1
ACD R	 118	M_Data_EOTVOS_corr	-9999.9	9999.9	0.1
ACD R	 119	M_Data_free_air_anom	-999.9	999.9	0.1
ACD C	 120	M_Data_seismic_ident				 ! 8 chars
ACD I	 121	M_Data_Qcode_gravity	0	9	1
ACD I	 122	M_Data_Qcode_magnet	0	9	1
ACD I	 123	M_Data_Qcode_bathy	0	9	1
ACD I	 124	M_Data_Qcode_navigat	5	9	1
!
