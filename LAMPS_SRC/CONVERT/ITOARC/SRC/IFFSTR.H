/*
 These logicals are set by IFFNXT or IFFPKE onto a ST,ZS, or CB
 SIMPLE_XY is set true if the entry is really an ST, or it is a CB
 with only X and Y columns (in that order) so that it's data part
 is identical to that of an ST, otherwise it is set false.
 SIMPLE_XYZ is similar, but for ZS, or CB resembling a ZS.
 Both are always set.
*/

struct iffstr_tag {
	unsigned int
		simple_xy,
		simple_xyz;
	} iffstr;
