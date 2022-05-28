!
! FRT Table for the conversion to and from IFF, and the display in IFF,
! of data in 'The Marine Geophysical Data Exchange Format' (MGD77).
!
! Created: F J Brown				26-July-1988
!
! Copyright: Laser-Scan Laboratories Ltd.,Cambridge, CB4 4FY, ENGLAND
!
!
! Just one simple type of point symbol required to base attribute data on 
!
!	FC	GT	COL	WIDTH	SIZE	SC	FLAG	H/W DESCRIPTION
!
FRT	1	7	1	0	0	1	0	0  !control pts
FRT	10	7	1	0	0	0	0	0  !sample pts
!
!
! Attribute codes:
! ================
!
!
ACD TABLE	3		! Header record codes
!
!	Code	Name			Minimum	Maximum		Min. step
!                                                                   
ACD C	1	M_Cruise_ID             			! 8 chars
ACD C	2	M_Format_acronym				! 5 chars(MGD77)
ACD I	3	M_Data_Centre_no	0	99999999 1
ACD I	4	M_Type_one_headers	1	4       1
ACD I	5	M_Type_two_headers	0	0
ACD I	6	M_Data_Parameters	29	29
ACD I	7	M_Survey_code_bathy	0	5       1 
ACD I	8	M_Survey_code_mag	0	5       1
ACD I	9	M_Survey_code_grav	0	5       1
ACD I	10	M_Survey_code_H_res	0	5       1
ACD I	11	M_Survey_code_D_pen	0	5       1
ACD I	12	M_File_creation         10101   999999
ACD C	13	M_Contributing_inst.    			! 41 chars 
ACD C	14	M_Country               			! 18 chars 
ACD C	15	M_Platform_name         			! 21 chars 
ACD I	16	M_Platform_type_code	0	9       1
ACD C	17	M_Platform_type					! 6 chars
ACD C	18	M_Chief_scientist       			! 32 chars
ACD C	19	M_Project_cruise_leg    			! 58 chars
ACD C	20	M_Funding               			! 20 chars
ACD I	21	M_Survey_departure	10101	999999
ACD C	22	M_Port_of_departure				! 34 chars
ACD I	23	M_Survey_arrival	10101	999999
ACD C	24	M_Port_of_arrival				! 32 chars
ACD C	25	M_Navigation_instr				! 40 chars
ACD C 	26	M_Pos_determ_method				! 38 chars
ACD C 	27	M_Bathy_instr					! 40 chars
ACD C	28	M_Add_bathy_data				! 38 chars
ACD C	29	M_Magnetics_instr				! 40 chars
ACD C	30	M_Add_mag_data					! 38 chars
ACD C	31	M_Gravity_instr					! 40 chars
ACD C	32	M_Add_gravity_data				! 38 chars
ACD C	33	M_Seismic_instr					! 40 chars
ACD C	34	M_Form_seismic_data				! 38 chars
ACD R 	35	M_Dig_rate_bathy	0.0	99.9	0.1
ACD C	36	M_Samp_rate_bathy				! 12 chars
ACD R	37	M_Assumed_sound_vel	0.0	9999.9	0.1
ACD I	38	M_Bathy_datum_code	0	88      1
ACD C	39	M_Interpolation					! 56 chars
ACD R	40	M_Dig_rate_mag		0.0	99.9	0.1
ACD I	41	M_Samp_rate_mag		0	99	1
ACD I	42	M_Mag_sensor_towdist	0	9999	1
ACD R	43	M_Mag_sensor_depth      0.0	9999.9	0.1
ACD I	44	M_Mag_hor_sensor_sep	0	999	1
ACD I	45	M_Mag_ref_field_code	0	88      1
ACD C	46	M_Reference_field				! 12 chars
ACD C	47	M_M_O_A_residual				! 47 chars
ACD R	48	M_Dig_rate_gravity	0.0	99.9	0.1
ACD I	49	M_Samp_rate_gravity	0	99	1
ACD I	50	M_Gravity_form_code	1	8       1
ACD C	51	M_Gravity_formula				! 17 chars
ACD I	52	M_Ref_system_code	1	9       1
ACD C	53	M_Reference_system				! 16 chars
ACD C	54	M_Correction_applied				! 38 chars
ACD R	55	M_Dep_base_stn_grav	0.0	999999.9 0.1
ACD C	56	M_Dep_base_stn_descr				! 33 chars
ACD R	57	M_Arr_base_stn_grav	0.0	999999.9 0.1
ACD C	58	M_Arr_base_stn_descr				! 31 chars
ACD I	59	M_Ten_degree_ident	0	9999    1
ACD C	60	M_Additional_doc				! 78 chars
ACD C	101	M_Data_cruise_ident				! 8 chars
ACD R	102	M_Data_time_zone_cor	-13.0	12.0	0.01
ACD I	103	M_Data_date		10101	999999
ACD I	104	M_Data_time_hours       0	99
ACD R	105	M_Data_time_mins        0.0	99.999
ACD I	106	M_Data_pos_type_code	1	9       1
ACD R	107	M_Data_bathy_travel	0.0	99.9999	0.0001
ACD R	108	M_Data_bathy_correct	0.0	99999.9	0.1
ACD I	109	M_Data_bathy_co_code	1	99      1
ACD I	110	M_Data_bathy_ty_code	1	9       1
ACD R	111	M_Data_mag_total_one	0.0	99999.9	0.1
ACD R	112	M_Data_mag_total_two	0.0	99999.9 0.1
ACD R	113	M_Data_mag_residual	-9999.9	9999.9	0.1
ACD I	114	M_Data_sens_residual	1	9       1
ACD R	115	M_Data_mag_diurn_cor	-999.9	999.9	0.1
ACD I	116	M_Data_alt_mag_sens	-99999	99999	1
ACD R	117	M_Data_obs_gravity	0.0	999999.9 0.1
ACD R	118	M_Data_EOTVOS_corr	-9999.9	9999.9	0.1
ACD R	119	M_Data_free_air_anom	-999.9	999.9	0.1
ACD C	120	M_Data_seismic_ident				! 8 chars
ACD I	121	M_Data_Qcode_gravity	0	9	1
ACD I	122	M_Data_Qcode_magnet	0	9       1
ACD I	123	M_Data_Qcode_bathy	0	9       1
ACD I	124	M_Data_Qcode_navigat	5	9       1
!
