! Use SRI OS, TRI OS in LITES2 as this is based on Ordnance Survey FRT


FRT	1	12	1	0	0.0	0	! layer 0 area

FRT	2	11	1	0	1.0	1	! registration point

FRT	3	12	1	0	0.0	0	! accuracy area

FRT     4       11	1	0	0.1	5       ! symbol string

FRT	5	1	1	0	0.0	0	! line

FRT	6	12	1	0	0.0	0	! area

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

   	   	 			
! that's the end of OS.FRT


ACD	TABLE	1

! AC's for the dataset as a whole

ACD	I	1	Product_type		0	5	! "5 chars"

ACD	I	2	Dataset_ID		0	20	! "20 chars"

ACD	I	3	Edition_no		0	999

ACD	D	4	Compilation_date

ACD	D	5	Revision_date

ACD	D	6	IHO_Format_date

ACD	D	7	FACS_Format_date

ACD	C	8	Data_type

ACD	C	9	Horiz_units

ACD	R	10	Horiz_resn

ACD	C	11	Geodetic_datum

ACD	C	12	Ellipsoid

ACD	C	13	Vert_units

ACD	R	14	Vert_resn

ACD	C	15	Vert_ref_code

ACD	C	16	Sounding_datum

ACD	I	17	X_false_origin

ACD	I	18	Y_false_origin

ACD	I	19	Z_false_origin

ACD	C	25	Projection

ACD	I	26	Projn_parameter_A	0	10	! "10 chars"

ACD	I	27	Projn_parameter_B	0	10	! "10 chars"

ACD	I	28	Projn_parameter_C	0	10	! "10 chars"

ACD	I	29	Projn_parameter_D	0	10	! "10 chars"

ACD	I	30	Compn_count		0	99

ACD	I	31	Revn_count		0	9

ACD	I	32	Product_spec		0	15	! "15 chars"

ACD	D	33	Product_spec_date

ACD	I	34	Spec_change_number	0	999

ACD	C	35	Country

ACD	C	36	Agency

ACD	C	37	Branch

ACD	I	38	Dig_system		0	10	! "10 chars"

ACD	I	39	Proc_system		0	10	! "10 chars"

ACD	C	40	Grid_code

ACD	I	41	Abs_horiz_acc		0	9999

ACD	I	42	Abs_vert_acc		0	9999

ACD	I	43	Rel_horiz_acc		0	9999

ACD	I	44	Rel_vert_acc		0	9999

ACD	I	45	Height_acc		0	9999

ACD	I	46	Data_gen		0	1

ACD	I	47	N_mm_number		0	9

ACD	I	48	E_mm_number		0	9

ACD	I	49	S_mm_number		0	9

ACD	I	50	W_mm_number		0	9

ACD	D	51	N_mm_date

ACD	D	52	E_mm_date

ACD	D	53	S_mm_date

ACD	D	54	W_mm_date

ACD	D	55	Earliest_source_date

ACD	D	56	Latest_source_date

ACD	I	57	Data_colln_code		0	9

ACD	I	58	Data_colln_crit		0	999

ACD	I	60	Registration_ID		0	999999

ACD	I	61	Control_X		0	999999

ACD	I	62	Control_Y		0	999999

ACD	I	63	Control_Z		0	999999

ACD	I	64	Registration_lat

ACD	I	65	Registration_long

ACD	I	66	Registration_elev

ACD	I	67	ACC_abs_horiz_acc	0	9999

ACD	I	68	ACC_abs_vert_acc	0	9999

ACD	I	69	ACC_rel_horiz_acc	0	9999

ACD	I	70	ACC_rel_vert_acc	0	9999

!  AC's for each feature

ACD	I	80	Source_code		0	99

ACD	I	81	Source_scale

ACD	D	82	Source_date

ACD	I	83	Collection_system	0	99

ACD	D	84	Maintenance_date

ACD	I	85	Feature_horiz_acc	0	9999

ACD	I	86	Feature_vert_acc	0	9999

ACD	I	87	Base_product		0	999

ACD	C	88	Security_class

ACD	C	89	Data_handling

ACD	I	90	Portrayal		0	99

ACD	C	91	FACS_prefix

ACD	C	92	FACS_code

ACD	I	101	I_FACS_attribute_A	0	99

ACD	I	102	I_FACS_attribute_B	0	99

ACD	I	103	I_FACS_attribute_C	0	99

ACD	I	104	I_FACS_attribute_D	0	99

ACD	I	105	I_FACS_attribute_E	0	99

ACD	I	106	I_FACS_attribute_F	0	99

ACD	I	107	I_FACS_attribute_G	0	99

ACD	I	108	I_FACS_attribute_H	0	99

ACD	I	109	I_FACS_attribute_I	0	99

ACD	R	110	R_FACS_attribute_J	0.0	999.0

ACD	R	111	R_FACS_attribute_K	0.0	999.0

ACD	R	112	R_FACS_attribute_L	0.0	999.0

ACD	R	113	R_FACS_attribute_M	0.0	999.0

ACD	I	114	I_FACS_attribute_N	0	99

ACD	I	115	I_FACS_attribute_O	0	99

ACD	I	116	I_FACS_attribute_P	0	99

ACD	I	117	I_FACS_attribute_Q	0	99

ACD	I	118	I_FACS_attribute_R	0	99

ACD	I	119	I_FACS_attribute_S	0	99

ACD	I	120	I_FACS_attribute_T	0	99

ACD	I	121	I_FACS_attribute_U	0	99

ACD	I	122	I_FACS_attribute_V	0	99

ACD	R	123	R_FACS_attribute_W	0.0	999.0

ACD	R	124	R_FACS_attribute_X	0.0	999.0

ACD	R	125	R_FACS_attribute_Y	0.0	999.0

ACD	R	126	R_FACS_attribute_Z	0.0	999.0

ACD	R	201	Value_attribute_A

ACD	R	202	Value_attribute_B

ACD	R	203	Value_attribute_C

ACD	R	204	Value_attribute_D

ACD	R	205	Value_attribute_E

ACD	R	206	Value_attribute_F

ACD	R	207	Value_attribute_G

ACD	R	208	Value_attribute_H

ACD	R	209	Value_attribute_I

ACD	R	210	Value_attribute_J

ACD	R	211	Value_attribute_K

ACD	R	212	Value_attribute_L

ACD     I       300     Text_attribute		10	20	! "10 or 20 chars"

