/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:03:34.000000000 +0000
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
#ifndef _MAIN_VDED_DEFNS
#define _MAIN_VDED_DEFNS

/*----------------------------------------------------------------------*/
/* TYPE ENUM DICT_VAC_DED_ROLE                                          */
/* DESCRIPTION                                                          */
/*                                                                      */
/* The DICT_VAC_DED_ROLE enumeration is used for specifying the		*/
/* role of a DED which can be acquired by a Version Access		*/
/* Context DED. Typically, DED acquired by a VAC will hold information	*/
/* relating to the data, or about accessing the data, held in the	*/
/* version corresponding to the VAC.					*/
/* 									*/
/* The DEDs acquired by a VAC can be of any descriptor type.		*/
/* 									*/
/* The ability to store any type of DED inside a VAC provides a 	*/
/* convenient mechanism to group together the various sorts of DED	*/
/* which may hold information derived from a specific version and to	*/
/* access them via that version. In particular, this mechanism is	*/
/* used by other database libraries to hold DEDs used when accessing	*/
/* data stored in the particular version.				*/
/*                                                                      */
/* ELEMENTS                                                             */
/*                                                                      */
/* VDED_INVALID		-	An invalid VAC DED role.		*/
/* 									*/
/* VDED_PERSISTENT	-	A DED used by the OBDB persistent	*/
/* 				storage libraries.			*/
/*									*/
/* VDED_RDBMS_GATEWAY	-	A DED holding information to map the	*/
/* 				object based model of the Gothic	*/
/* 				database onto data held in a relational	*/
/* 				database.				*/
/* 									*/
/* VDED_RASTDB		-	A DED used to hold information		*/
/* 				relating to raster data held in		*/
/* 				the version.				*/
/*									*/
/* VDED_FIN		-	A DED used to hold information		*/
/* 				relating to format infrastructure	*/
/* 				data held in the version.		*/
/*									*/
/* VDED_UES		-	A DED used to hold information		*/
/* 				relating to the User Environment	*/
/* 				Storage system.				*/
/*									*/
/* VDED_METHSUPP	-	A DED used by method support		*/
/* 									*/
/* VDED_COMPOSITE	-	A DED used to hold information		*/
/* 				relating to the storage of composite	*/
/* 				objects.				*/
/*									*/
/* VDED_STORE		-	Storage manager DED.			*/
/*									*/
/* VDED_TOPO_MODEL	-	DED to store topological model (TOPOLIB)*/
/*									*/
/* VDED_SPATIAL_INDEX	-	DED to store spatial index (QUADLIB)	*/
/*									*/
/* VDED_OBJX		-	OBJXLIB DED 				*/
/*									*/
/* VDED_FRAME 		-	DED to initialise callbacks to a frame  */
/*       			so the frames are updated with VACs	*/
/*									*/
/* VDED_META 		-	Data dictionary (schema) descriptor 	*/
/*				maintained by metalib.			*/
/*									*/
/* VDED_AUDIT 		-	Audit trail descriptor maintained by	*/
/*				auditlib.				*/
/*									*/
/* VDED_SCALE		-	Scale range descriptor.			*/
/*									*/
/* VDED_METACLASS	-	Meta-class descriptor.			*/
/*									*/
/* VDED_RDBMS_GATE	-	A DED holding information to map the	*/
/* 				object based model of the Gothic	*/
/* 				database onto data held in a relational	*/
/* 				database.				*/
/* 									*/
/* VDED_CLASSGROUP	-	Classgroup descriptor.			*/
/*									*/
/* VDED_CLUSTERGROUP	-	Clustergroup descriptor.		*/
/*									*/
/* VDED_ENDMARKER	-	An element to mark the end of the	*/
/* 				enumeration.				*/
/*                                                                      */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   VDED_INVALID,
   VDED_PERSISTENT,
   VDED_RDBMS_GATEWAY,
   VDED_RASTDB,
   VDED_FIN,
   VDED_SEGMENT,
   VDED_UES,
   VDED_METHSUPP,
   VDED_COMPOSITE,
   VDED_STORE,
   VDED_TOPO_MODEL,
   VDED_SPATIAL_INDEX,
   VDED_OBJX,
   VDED_FRAME,
   VDED_META,
   VDED_AUDIT,
   VDED_SCALE,
   VDED_METACLASS,
   VDED_RDBMS_GATE,
   VDED_CLASSGROUP,
   VDED_CLUSTERGROUP,
   VDED_ENDMARKER
} DICT_VAC_DED_ROLE;

/* end-def */

#define DICT_VDED_MAX_CHAR 51

#define DICT_VDED_DESCRIPTION \
{ \
   "Invalid", \
   "Persistent storage library", \
   "RDBMS Gateway", \
   "Raster/Database integration", \
   "Format infrastructure", \
   "Segment", \
   "User environment storage", \
   "Methods", \
   "Composiste", \
   "Storage manager", \
   "Topological Model", \
   "Spatial Index",\
   "OBJXLIB", \
   "frame manager library", \
   "Schema", \
   "Audit", \
   "Scale", \
   "Metaclass", \
   "RDBMS Gatelib gateway", \
   "Class Group", \
   "Cluster Group", \
   "Endmarker" \
}

#define DICT_VDED_LULL_CONSTANT \
{ \
   "VDED_INVALID", \
   "VDED_PERSISTENT", \
   "VDED_RDBMS_GATEWAY", \
   "VDED_RASTDB", \
   "VDED_FIN", \
   "VDED_SEGMENT", \
   "VDED_UES", \
   "VDED_METHSUPP", \
   "VDED_COMPOSITE", \
   "VDED_STORE", \
   "VDED_TOPO_MODEL", \
   "VDED_SPATIAL_INDEX", \
   "VDED_OBJX", \
   "VDED_FRAME", \
   "VDED_META", \
   "VDED_AUDIT", \
   "VDED_SCALE", \
   "VDED_METACLASS", \
   "VDED_RDBMS_GATE", \
   "VDED_CLASSGROUP", \
   "VDED_CLUSTERGROUP", \
   "VDED_ENDMARKER" \
}

extern GOTH_INTEGER main_vded_count();
extern GOTH_STRING main_vded_description(GOTH_INTEGER vded);
extern GOTH_STRING main_vded_lull_constant(GOTH_INTEGER vded);

/* $Header: /usr/users/rogera/RCS/hdr.main_vded_defns.h,v 1.11 1994/11/13 20:37:08 rogera Exp $								*/
#endif

