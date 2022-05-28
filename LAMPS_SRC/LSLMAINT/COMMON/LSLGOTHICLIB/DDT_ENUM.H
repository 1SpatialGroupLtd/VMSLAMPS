/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:03:24.000000000 +0000
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
/* $Header: /usr/users/rogera/RCS/hdr.ddt_enum.h,v 1.11 1994/11/13 20:36:57 rogera Exp $								*/
/* 									*/
/* $Log: hdr.ddt_enum.h,v $
 * Revision 1.11  1994/11/13  20:36:57  rogera
 * Version v1-10 derived from v1-9
 * see authorisation file.
 * WICC 417.
 *
 * Addition of TELETIFFLIB module allowing export of RACs
 * to TIFF Image files. WICC TELECOMMS 46.
 * some other modules also added
 *
 * Revision 1.10  1994/09/20  18:03:36  adrian
 * Version v1-9 derived from v1-8
 * Gothic WICC 323
 *
 * Include initialisation of new modules.
 *
 * Include new error codes.
 *
 * Added topological model and spatial index VAC/DED roles.
 *
 * Add DED and VDED for metalib (ADE v2 schema) plus a load of new
 * metalib error codes.
 *
 * Move definition of Lull recover directory from the local sos init file
 * to the main file sos_unix_init.lull.
 *
 * Revision 1.9  1994/05/19  15:50:11  davida
 * Version v1-8 derived from v1-7
 * Main development version.
 *
 * Add initialisation for xsapilib (See COMMERCIAL WICC 13).
 *
 * Revision 1.8  1994/04/06  20:28:55  davida
 * Version v1-7 derived from v1-5
 * See Gothic WICC 263.
 *
 * Extracted to allow ongoing additions like status codes.
 *
 * NETXLIB declarations added.
 *
 * Added SOSes for UNIX domain sockets (`port:') and for method Lull source code
 * (`methods:').
 *
 * Revision 1.2.1.6  1994/03/08  00:00:18  jon
 * Version v1-5 derived from v1-4
 * compile date and time into 'main_time.o' to avoid recompilation of test_main.c
 * every time
 *
 * Revision 1.2.1.3  1993/09/20  09:47:35  johnh
 * Version v1-4 derived from v1-3
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.2.1.2  1993/08/24  09:56:28  davida
 * Version v1-3 derived from v1-2
 * development version of main
 *
 * Revision 1.2.1.1  1993/07/16  09:26:46  davidr
 * Version v1-2 derived from v1-1
 * Current development version:
 * Add calls for FINXLIB initialisation routines
 * WICC 14
 * alterations required to implement a more comprehensive -v option
 * WICC 24
 * Removal of two memory leaks when mod_inquire_version() called.
 *
 * Revision 1.2  1993/03/15  18:02:36  davidr
 * Version v1-1 derived from v1-0
 * changes to status code handling and addition of commonly used LULL to 'main's
 * LULL directory
 *
 * Revision 1.1  1993/03/01  11:47:43  olivia
 * Version v1-0 derived from root
 * initial RCS version
 * Frozen for Telecomms System Tests
 *								*/
#ifndef _DDT_ENUM
#define _DDT_ENUM

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    GOTHIC user, 18-Sep-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			    D D T _ E N U M 				*/
/*									*/
/* Part of GOTHIC module GOTHLIB					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* TYPE ENUM GOTH_DESCRIPTOR_DATATYPE					*/
/* DESCRIPTION								*/
/* 									*/
/* The elements of this enumeration are used for identifying		*/
/* specific descriptor types within the Gothic environment. These	*/
/* elements are available in both Lull and C. Each element in this	*/
/* enumeration also has a corresponding Lull type which can be used	*/
/* in variable declarations in Lull programs.				*/
/* 									*/
/* ELEMENTS								*/
/* 									*/
/* DDT_INVALID		- An invalid descriptor type.			*/
/* 									*/
/* DDT_WINDOW		- Screen graphics window.			*/
/*			  Lull type WINDOW.				*/
/* 									*/
/* DDT_OVERLAY		- A window overlay 				*/
/*			  Lull type OVERLAY.				*/
/* 									*/
/* DDT_LIST		- A display list 				*/
/*			  Lull type LIST.				*/
/* 									*/
/* DDT_COLOUR		- A colour table				*/
/*			  Lull type COLOUR.				*/
/* 									*/
/* DDT_GRAPHIC		- OBSOLETE.					*/
/* 									*/
/* DDT_TEMPLATE		- OBSOLETE					*/
/* 									*/
/* DDT_HISTORY		- A history window				*/
/*			  Lull type HISTORY.				*/
/* 									*/
/* DDT_STATUS_LIST	- a stack of GOTH__ status codes		*/
/*			  Lull type STATUS_LIST.			*/
/* 									*/
/* DDT_OBJECT_ID	- OBSOLETE					*/
/* 									*/
/* DDT_STREAM		- OBSOLETE.					*/
/* 									*/
/* DDT_EDITOR		- A text editing window.			*/
/*			  Lull type EDITOR.				*/
/* 									*/
/* DDT_HYPER		- A hypercard.					*/
/*			  Lull type HYPER.				*/
/* 									*/
/* DDT_DEVICE		- A device description (eg, magnetic tape).	*/
/*			  Lull type DEVICE.				*/
/* 									*/
/* DDT_BUFFER		- A buffer.					*/
/*			  Lull type BUFFER.				*/
/* 									*/
/* DDT_QUERY_TREE	- A query tree.					*/
/*			  Lull type QUERY_TREE.				*/
/* 									*/
/* DDT_LOOKUP		- OBSOLETE.					*/
/* 									*/
/* DDT_COLLECTION	- A collection.					*/
/*			  Lull type COLLECTION.				*/
/* 									*/
/* DDT_BLOCKING		- A blocking context. 				*/
/*			  Lull type BLOCKING.				*/
/* 									*/
/* DDT_RESULT		- An RDB query result.				*/
/*			  Lull type RESULT.				*/
/* 									*/
/* DDT_SCANBUFFER	- A SCANLIB buffer.				*/
/*			  Lull type SCANBUFFER.				*/
/* 									*/
/* DDT_SCANENVIRON	- A SCANLIB envinronment.			*/
/*			  Lull type SCANENVIRON.			*/
/* 									*/
/* DDT_LULL_ENVIRONMENT	- A Lull compilation and execution environment.	*/
/*			  Lull type LULL_ENVIRONMENT.			*/
/* 									*/
/* DDT_PORT		- A PORTLIB datastructure.			*/
/*			  Lull type PORT.				*/
/* 									*/
/* DDT_ICODE_SEGMENT	- A compiled Lull program (ICODE segment).	*/
/*			  Lull type ICODE_SEGMENT.			*/
/* 									*/
/* DDT_BUTTON		- A BUTTONLIB datastructure.			*/
/*			  Lull type BUTTON.				*/
/* 									*/
/* DDT_VAC		- A version access context. 			*/
/*			  Lull type VAC.				*/
/* 									*/
/* DDT_USER_ADDRESS	- A user defined data type description.		*/
/*			  Lull type USER_ADDRESS.			*/
/* 									*/
/* DDT_FOLLOW_CONTEXT	- A FOLLOWLIB context.				*/
/*			  Lull type FOLLOW_CONTEXT.			*/
/* 									*/
/* DDT_MARK		- A COLNLIB collection mark.			*/
/*			  Lull type MARK.				*/
/* 									*/
/* DDT_RAC		- A raster access context.			*/
/*			  Lull type RAC.				*/
/* 									*/
/* DDT_GRID		- A surface grid.				*/
/*			  Lull type GRID.				*/
/* 									*/
/* DDT_REGION		- A raster region.				*/
/*			  Lull type REGION.				*/
/* 									*/
/* DDT_EXTENT		- A raster extent.				*/
/*			  Lull type EXTENT.				*/
/* 									*/
/* DDT_FAC		- A file access context.			*/
/*			  Lull type FAC.				*/
/* 									*/
/* DDT_GEOMETRY		- A geometry.					*/
/*			  Lull type GEOMETRY.				*/
/* 									*/
/* DDT_ARC		- An automatic redraw context.			*/
/*			  Lull type ARC.				*/
/* 									*/
/* DDT_SPATIAL_INDEX	- A spatial index.				*/
/*			  Lull type SPATIAL_INDEX.			*/
/* 									*/
/* DDT_CACHE		- A cache.					*/
/*			  Lull type CACHE.				*/
/* 									*/
/* DDT_REGISTRATION	- A persistent storage library registration.	*/
/*			  Lull type REGISTRATION.			*/
/* 									*/
/* DDT_BTRAC		- A B-tree access context.			*/
/*			  Lull type BTRAC.				*/
/* 									*/
/* DDT_FVLIB		- A file version mapping library datastructure.	*/
/*			  Lull type FVLIB.				*/
/* 									*/
/* DDT_INTERFACE	- An MMIXLIB interface.				*/
/*			  Lull type INTERFACE.				*/
/* 									*/
/* DDT_MANAGER		- A cache manager. 				*/
/*			  Lull type MANAGER.				*/
/* 									*/
/* DDT_SPACE_KIND	- A space kind.					*/
/*			  Lull type SPACE_KIND.				*/
/* 									*/
/* DDT_TRANS_KIND	- A transformation kind.			*/
/*			  Lull type TRANS_KIND.				*/
/* 									*/
/* DDT_SPACE		- A space.					*/
/*			  Lull type SPACE.				*/
/* 									*/
/* DDT_VARIANT		- A variable type, matching any other.		*/
/* 									*/
/* DDT_FOLLOW_TYPE	- Line following overall parameters.		*/
/*			  Lull type FOLLOW_TYPE.			*/
/* 									*/
/* DDT_USER_PARAM	- Line following user parameters.		*/
/*			  Lull type USER_PARAM.				*/
/* 									*/
/* DDT_SYSTEM_PARAM	- Line following system parameters.		*/
/*			  Lull type SYSTEM_PARAM.			*/
/* 									*/
/* DDT_WIZARD_PARAM	- Line following wizard parameters.		*/
/*			  Lull type WIZARD_PARAM.			*/
/* 									*/
/* DDT_DOPE		- A dedicated object processing environment.	*/
/*			  Lull type DOPE.				*/
/* 									*/
/* DDT_TB_SQ		- A tolerance block required for squaring.	*/
/*			  Lull type TB_SQ.				*/
/* 									*/
/* DDT_VTREE		- A version tree snapshot. 			*/
/*			  Lull type VTREE.				*/
/* 									*/
/* DDT_JAB		- A junction access block. 			*/
/*			  Lull type JAB.				*/
/* 									*/
/* DDT_VTB		- A version tree browser.			*/
/*			  Lull type VTB.				*/
/* 									*/
/* DDT_FILTER		- A raster processing filter.			*/
/*			  Lull type FILTER.				*/
/* 									*/
/* DDT_SMART_USER	- A user of the RAE SMART system. 		*/
/*			  Lull type SMART_USER.				*/
/* 									*/
/* DDT_SMDB_AC		- RAE SMART system database access context.	*/
/*			  Lull type SMDB_AC.				*/
/* 									*/
/* DDT_VTBF		- A version tree browser filter.		*/
/*			  Lull type VTBF.				*/
/* 									*/
/* DDT_TRANSFER		- A CONVLIB transfer id (conversion context).	*/
/*			  Lull type TRANSFER.				*/
/* 									*/
/* DDT_SMART_PROJECT	- An RAE SMART system "Project". 		*/
/*			  Lull type SMART_PROJECT.			*/
/* 									*/
/* DDT_SMART_JOB	- An RAE SMART system "Job". 			*/
/*			  Lull type SMART_JOB.				*/
/* 									*/
/* DDT_OBSERVATION_SET	- A set of observations to relate one space to 	*/
/*			  another.					*/
/*			  Lull type OBSERVATION_SET.			*/
/* 									*/
/* DDT_VR		- A value record.				*/
/*			  Lull type VR.					*/
/* 									*/
/* DDT_DR		- A description record.				*/
/*			  Lull type DR.					*/
/* 									*/
/* DDT_ATB		- An attribute browser form.			*/
/*			  Lull type ATB.				*/
/* 									*/
/* DDT_TOPO_MODEL	- A topological model.				*/
/*			  Lull type TOPO_MODEL.				*/
/* 									*/
/* DDT_STB		- A structure browser.				*/
/*			  Lull type STB.				*/
/* 									*/
/* DDT_TABULATE		- A resampling tabulation points structure.	*/  
/*			  Lull type TABULATE.				*/
/* 									*/
/* DDT_BI		- A browser interaction interface.		*/
/*			  Lull type BI.					*/
/* 									*/
/* DDT_MATRIX		- A sparse matrix.				*/
/*			  Lull type MATRIX.				*/
/* 									*/
/* DDT_MATRIX_EQUATION	- A sparse matrix equation.			*/
/*			  Lull type MATRIX_EQUATION.			*/
/* 									*/
/* DDT_TRANSFORM	- A transform object.				*/
/*			  Lull type TRANSFORM.				*/
/* 									*/
/* DDT_TRANSFORM_COLLECTION - An transform collection object.		*/
/*			  Lull type TRANSFORM_COLLECTION.		*/
/* 									*/
/* DDT_CPT		- A control point object.			*/
/*			  Lull type CPT.				*/
/* 									*/
/* DDT_CPT_SET		- A control point set object.			*/
/*			  Lull type CPT_SET.				*/
/* 									*/
/* DDT_CPT_COLLECTION	- A control point set collection object.	*/
/*			  Lull type CPT_COLLECTION.			*/
/* 									*/
/* DDT_RESIDUALS	- A transform residuals object.			*/
/*			  Lull type RESIDUALS.				*/
/* 									*/
/* DDT_SCB		- A schema browser.				*/
/*			  Lull type SCB.				*/
/* 									*/
/* DDT_SCBC		- A schema class browser.			*/
/*			  Lull type SCBC.				*/
/* 									*/
/* DDT_SCBP		- A schema property browser.			*/
/*			  Lull type SCBP.				*/
/* 									*/
/* DDT_SCBM		- A schema method browser.			*/
/*			  Lull type SCBM.				*/
/* 									*/
/* DDT_SCBPP		- A schema property pair browser.		*/
/*			  Lull type SCBPP.				*/
/* 									*/
/* DDT_SMART_IMAGE	- An RAE SMART system image.			*/
/*			  Lull type SMART_IMAGE.			*/
/* 									*/
/* DDT_SPACE_TREE	- A tree for stringing spaces together.		*/
/*			  Lull type SPACE_TREE.				*/
/* 									*/
/* DDT_SCBCP		- A schema class property browser.		*/
/*			  Lull type SCBCP.				*/
/* 									*/
/* DDT_SCBPC		- A schema property class browser.		*/
/*			  Lull type SCBPC.				*/
/* 									*/
/* DDT_SCBPD		- A schema property define.			*/
/*			  Lull type SCBPD.				*/
/* 									*/
/* DDT_SCBS		- A schema sort interface.			*/
/*			  Lull type SCBS.				*/
/* 									*/
/* DDT_NET		- A network analysis model.			*/
/*			  Lull type NET.				*/
/* 									*/
/* DDT_SCBPPA		- A schema browser property pair add class.	*/
/*			  Lull type SCBPPA.				*/
/* 									*/
/* DDT_SCBPPB		- A schema browser property pair class browser. */
/*			  Lull type SCBPPB.				*/
/* 									*/
/* DDT_GLOBAL_INDEX	- A global control point index.			*/
/*			  Lull type GLOBAL_INDEX.			*/
/* 									*/
/* DDT_SCBCM		- A Schema Browser Class Method Browser.	*/
/*			  Lull type SCBCM.				*/
/* 									*/
/* DDT_SCBMC		- A Schema Browser Method Class Interface.	*/
/*			  Lull type SCBMC.				*/
/* 									*/
/* DDT_SCBCMP		- A Schema Browser Class Method Parameters	*/
/*			  Interface.					*/
/*			  Lull type SCBCMP.				*/
/* 									*/
/* DDT_SCBMD		- A Schema Browser Method Define Interface.	*/
/*			  Lull type SCBMD.				*/
/* 									*/
/* DDT_TRANSFORM_SPEC	- An RAE SMART Transformation Specification.	*/
/*			  Lull type TRANSFORM_SPEC.			*/
/* 									*/
/* DDT_SCBCPP		- A Schema Browser Class Property Parameter 	*/
/*			  Interface.					*/
/*			  Lull type SCBCPP.				*/
/* 									*/
/* DDT_OBJ_INFO		- AN RAE SMART generic object information.	*/
/*			  Lull type OBJ_INFO.				*/
/* 									*/
/* DDT_COLOUR_TABLE	- A colour table manager.			*/
/*			  Lull type COLOUR_TABLE.			*/
/* 									*/
/* DDT_BIB		- A database browser.				*/
/*			  Lull type BIB.				*/
/* 									*/
/* DDT_COMM		- A communication description.			*/
/*			  Lull type COMM.				*/
/* 									*/
/* DDT_SMART_IMAGE_COLN	- An RAE SMART image collection.		*/
/*			  Lull type SMART_IMAGE_COLN.			*/
/* 									*/
/* DDT_STDOUT		- The standard output for goth_printf().	*/
/*			  Lull type STDOUT.				*/
/* 									*/
/* DDT_MAIN_WIDGET	- The application's main widget for application.*/
/*			  Lull type MAIN_WIDGET.			*/
/* 									*/
/* DDT_GCP		- A ground control point.			*/
/*			  Lull type GCP.				*/
/* 									*/
/* DDT_HISTOGRAM	- A histogram.					*/
/*			  Lull type HISTOGRAM.				*/
/* 									*/
/* DDT_GENF		- A generic form handler.			*/
/*			  Lull type GENF.				*/
/* 									*/
/* DDT_ITEM_INTERFACE	- A Generic SMART Item Selector.		*/
/*			  Lull type ITEM_INTERFACE.			*/
/* 									*/
/* DDT_PE_INTERFACE	- A SMART Project Editor.			*/
/*			  Lull type PE_INTERFACE.			*/
/* 									*/
/* DDT_JE_INTERFACE	- A SMART Job Editor.				*/
/*			  Lull type JE_INTERFACE.			*/
/* 									*/
/* DDT_IS_INTERFACE	- A SMART Image Selector.			*/
/*			  Lull type IS_INTERFACE.			*/
/* 									*/
/* DDT_LIC_INTERFACE	- A licensing interface.			*/
/*			  Lull type LIC_INTERFACE.			*/
/* 									*/
/* DDT_TEXT		- Long textual information. 			*/
/*			  Lull type TEXT.				*/
/* 									*/
/* DDT_ISIC		- An Information Storage and Interrogation 	*/
/*			  Context.					*/
/*			  Lull type ISIC.				*/
/* 									*/
/* DDT_QF_INTERFACE	- A Query Form Interface.			*/
/*			  Lull type QF_INTERFACE.			*/
/* 									*/
/* DDT_GEOCODER		- A geocoder data descriptor.			*/
/*			  Lull type GEOCODER.				*/
/* 									*/
/* DDT_TDTEMPLATE	- A SMART Tape Data Template.			*/
/*			  Lull type TDTEMPLATE.				*/
/* 									*/
/* DDT_COLLIB_TAG	- A UIL tag update datastructure.		*/
/*			  Lull type COLLIB_TAG.				*/
/* 									*/
/* DDT_TDT		- A SMART Tape Data Template specification.	*/
/*			  Lull type TDT.				*/
/* 									*/
/* DDT_SMART_PRIVILEGE	- A SMART privilge object (grants access to	*/
/*			  objects).					*/
/*			  Lull type SMART_PRIVILEGE.			*/
/* 									*/
/* DDT_TAPE_WINDOW	- A SMART window on tape buffer for text 	*/
/*			  reading returns.				*/
/*			  Lull type TAPE_WINDOW.			*/
/* 									*/
/* DDT_CLIENT		- An IPC client.				*/
/*			  Lull type CLIENT.				*/
/* 									*/
/* DDT_SERVER		- An IPC server.				*/
/*			  Lull type SERVER.				*/
/* 									*/
/* DDT_PROTOCOL		- A IPC protocol.				*/
/*			  Lull type PROTOCOL.				*/
/* 									*/
/* DDT_CLIENT_GROUP	- An IPC client group.				*/
/*			  Lull type CLIENT_GROUP.			*/
/* 									*/
/* DDT_TAPEHD_ITEM	- A SMART tape header data item.		*/ 
/*			  Lull type TAPEHD_ITEM.			*/
/* 									*/
/* DDT_SMART_DEFAULT	- A SMART default object.			*/
/*			  Lull type SMART_DEFAULT.			*/
/* 									*/
/* DDT_TAPEHD		- A SMART tape header.				*/
/*			  Lull type TAPEHD.				*/
/* 									*/
/* DDT_SPACE_INSTANCE	- An instance of a space kind.			*/
/*			  Lull type SPACE_INSTANCE.			*/
/* 									*/
/* DDT_MMID_INTERFACE	- An MMIDLIB Interface.				*/
/*			  Lull type MMID_INTERFACE.			*/
/* 									*/
/* DDT_SAT_BITMAP	- A Satellite bitmap reader/writer library.	*/
/*			  Lull type SAT_BITMAP.				*/
/* 									*/
/* DDT_TPRAG		- A SMART tape pragma dictionary.		*/
/*			  Lull type TPRAG.				*/
/* 									*/
/* DDT_TPRAG_FN		- SMART tape pragma function.			*/
/*			  Lull type TPRAG_FN.				*/
/* 									*/
/* DDT_LCC		- A Lull Calling Context.			*/
/*			  Lull type LCC.				*/
/* 									*/
/* DDT_CLASSIFIER	- A classification interface.			*/
/*			  Lull type CLASSIFIER.				*/
/* 									*/
/* DDT_DTB		- An IPC data transmission block.		*/
/*			  Lull type DTB.				*/
/* 									*/
/* DDT_CLASS_LINEAR	- Classification linear scheme interface.	*/
/*			  Lull type CLASS_LIN.				*/
/* 									*/
/* DDT_PLOT_PS		- A PostScript plot.				*/
/*			  Lull type PLOT_PS.				*/
/* 									*/
/* DDT_SPIN		- Space Browser Interface.			*/
/*									*/
/* DDT_GEN_HISTOGRAM	- General purpose histogram.			*/
/*									*/
/* DDT_PAINTOUT		- Raster paintout.				*/
/*									*/
/* DDT_ZONE		- Search zone.					*/
/*									*/
/* DDT_FRAME_MANAGER	- Frame-Manager					*/
/*									*/
/* DDT_FRAME		- Instance of a frame				*/
/*									*/
/* DDT_KEYBOARD		- Keyboard interface				*/
/*									*/
/* DDT_TTY		- Used same way as DDT_STDOUT but for a terminal*/
/*									*/
/* DDT_CLASS_SCHEME	- CLASSLIB Classification Scheme.		*/
/*									*/
/* DDT_CLASS_LINEAR_UNIT- Classification linear unit interface.		*/
/* 									*/
/* DDT_CLASS_HISTOGRAM	- Classification histogram interface.		*/
/* 									*/
/* DDT_CLASS_USER	- Classification user defined interface.	*/
/*									*/
/* DDT_TRANSFER_INST	- Transfer format instance			*/
/* 									*/
/* DDT_TRANSFER_SPEC	- Transfer format specification			*/
/* 									*/
/* DDT_SURF             - A 2.5D surface interpolated over a grid       */
/* 									*/
/* DDT_REP_SCHEME	- A REPLIB Representation Scheme.		*/
/*			  Lull type REP_SCHEME.				*/
/* DDT_DTM             - A DTM model.					*/
/* 									*/
/* DDT_GUIDE		- A Guidance File substitute			*/
/*									*/
/* DDT_CHIP		- A GCP chip (ie small extract of raster) 	*/
/*									*/
/* DDT_TXTREC		- A text record - used by FINLIB using transfer	*/
/*			  format modules, to hold text records being	*/
/*			  interpreted.					*/
/*									*/
/* DDT_GV_ARRAY		- an array of typed GOTH_VALUEs			*/
/*									*/
/* DDT_UES		- a User Environment Storage id.		*/
/* 									*/
/* DDT_UES_INTERNAL	- an internal User Environment Storage id.	*/
/* 									*/
/* DDT_DIB		- A Device Independent Buffer.			*/
/* 			  Lull type DIB.				*/
/*									*/
/* DDT_ORTHOIMAGE	- A transform specification for generating	*/
/*			  ortho-images					*/
/* 									*/
/* DDT_DEVNULL		- Used for NULL output device for goth_printf().*/
/*									*/
/* DDT_DIB_MARK		- A mark on a Device Indepedent Buffer.		*/
/*									*/
/* DDT_SYMBOL           - Symbol id used for representation		*/
/* 									*/
/* DDT_MEASUREMENT_SET	- A set of measurements to relate spaces to 	*/
/*			  one another.					*/
/*			  Lull type MEASUREMENT_SET.			*/
/*									*/
/* DDT_DRB		- Description Record Browser.			*/
/*								        */
/* DDT_OBJECT_COLN 	- Collection of objects to be saved with     	*/
/*			  SMSRLIB.					*/
/*									*/
/* DDT_MAGIC_NOS	- Magic numbers associated with a raster	*/
/*									*/
/* DDT_TRANS		- A transformation.				*/
/*			  Lull type TRANS. - a transformation		*/
/* 									*/
/* DDT_SPACE_ROUTE_PLAN	- A structure that holds data about the routes	*/
/*			  between two spaces				*/
/*			  Lull type SPACE_ROUTE_PLAN			*/
/* 									*/
/* DDT_GATEWAY          - Gateway to external RDBMS for attribute	*/
/*                        storage					*/
/* 									*/
/* DDT_RASTER_COMB	- Data structure to handle combination of two	*/
/* 			  raster datasets				*/
/* 									*/
/* DDT_TRANSFORM_DEFINER- Registration Infrastructure Library. Transform*/
/*			  definition interface.				*/
/*									*/
/* DDT_MEASUREMENT_DEFINER- Registration Infrastructure Library.	*/
/*			  Measurement Set definition interface.		*/
/*									*/
/* DDT_POINT_DEFINER	- Registration Infrastructure Library. Point	*/
/*			  definition interface.				*/
/*									*/
/* DDT_DTM_QUALITY	- A quality which may be attached to a DTM.     */
/*									*/
/* DDT_DASH		- Something or other.				*/
/*									*/
/* DDT_SMART_DTM	- A SMART DTM descriptor.  Encapsulates a DTM	*/
/* 			  and information on the tape from which it was	*/
/* 			  loaded into the SMART system.			*/
/*									*/
/* DDT_ORBIT_MODEL	- Data structure which defines a model for a	*/
/*			  spacecraft orbital track			*/
/*									*/
/* DDT_BULK_TFORM_DEFN	- Data structure which defines a complex bulk	*/
/*                        transformation				*/
/*									*/
/* DDT_CP_SET		- A data structure that allows access to the	*/
/*			  control points in a version.			*/
/*                        Lull type CP_SET				*/
/*									*/
/* DDT_GLIN		- A global indexing data structure		*/
/*									*/
/* DDT_SMART_TRANSFORM	- A SMART transformation.  Only used by the	*/
/* 			  SMART database.				*/
/*									*/
/* DDT_LAYOUT		- A layout for hardcopy plots.			*/
/* 									*/
/* DDT_RASSCAN		- Data for the rasterization of geometries.	*/
/*									*/
/* DDT_FIN_STORE	- Format Infrastructure storage DED, to be	*/
/* 			  attached to the relevant VAC DED.		*/
/*									*/
/* DDT_QUEUE		- Data for batch queueing			*/
/* 									*/
/* DDT_SCRATCH		- Scratch-pad defined by Annotation Module	*/
/* 									*/
/* DDT_LSREDIT		- Environmnet for editing LSR files.		*/
/* 									*/
/* DDT_COLLIB_AUTO	- Added for SMART project after creating the 	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_COLLIB_CS	- Added for SMART project after creating the 	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_COLLIB_CS_RGB	- Added for SMART project after creating the 	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_COLLIB_CS_GREY	- Added for SMART project after creating the 	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_COLLIB_HISTOGRAM	- Added for SMART project after creating the 	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_HISTOGRAM_GRAPH	- Added for SMART project after creating the	*/
/*			  shell-devt alternatives.			*/
/*									*/
/* DDT_DRAC		- Dynamic RAC					*/
/* 									*/
/* DDT_PROP_MODEL       - Propagation model for telecomms.		*/
/* 									*/
/* DDT_PROFILE		- DTM profile.					*/
/* 									*/
/* DDT_LOS		- Line-Of-Sight Transmission-Model		*/
/*									*/
/* DDT_RAL		- Rutherford-Appleton Labs Transmission-Model	*/
/*									*/
/* DDT_LR		- Longley Rice Transmission-Model		*/
/*									*/
/* DDT_MERGE_CONTEXT	- Context for merging versions			*/
/*									*/
/* DDT_BIGCOLN		- BIG collection (may be cached...)		*/
/*									*/
/* DDT_TIMER		- Timer ID, used to invoke LULLX functions.	*/
/*									*/
/* DDT_REPIN		- Representation interface for REPINLIB.	*/
/*									*/
/* DDT_REPIN_COLOUR	- Colour interface for REPINLIB.		*/
/*									*/
/* DDT_REPIN_BACK_COLOUR- Background Colour interface for REPINLIB.	*/
/*									*/
/* DDT_NET_TREE		- Tree built during Network Analysis		*/
/* 									*/
/* DDT_REPIN_SYMBOL	- Symbol interface for REPINLIB.		*/
/*                        OBSELETE after v1-0 or repinlib.		*/
/*			  Replaced by REPIN_BM_SYMBOL, REPIN_RW_SYMBOL.	*/
/* 									*/
/* DDT_REPIN_DASH	- Dash interface for REPINLIB.			*/
/* 									*/
/* DDT_TRN_GRID		- Transform interpolation grid			*/
/* 									*/
/* DDT_TRAC		- Text Recognition Access Context		*/
/*									*/
/* DDT_RASTER_EXPORT	- Access to Raster data for export		*/
/* 									*/
/* DDT_REPIN_FONT_FAMILY- Font Family Interface for REPINLIB.		*/
/*                        OBSELETE after v1-0 or repinlib.		*/
/*			  Replaced by REPIN_FONT.			*/
/*									*/
/* DDT_MMID_PALETTE	- Palette interface in MMIDLIB.			*/
/*									*/
/* DDT_MMID_BITMAP	- Bitmap chooser interface in MMIDLIB.		*/
/*									*/
/* DDT_QUERY		- OQL query graph.				*/
/*									*/
/* DDT_ICONBOX		- Icon Box interface.				*/
/* 									*/
/* DDT_REPIN_FONT	- Font interface for REPINLIB.			*/
/* 									*/
/* DDT_REPIN_BM_SYMBOL	- Bitmap Symbol interface for REPINLIB.		*/
/* 									*/
/* DDT_REPIN_RW_SYMBOL	- Real World Symbol interface for REPINLIB.	*/
/* 									*/
/* DDT_TREC_SYMSET	- Storage descriptor for TRECLIB.		*/
/*									*/
/* DDT_SEG_INFO		- Internal DED for SEGLIB (accessed from VAC)	*/
/* 									*/
/* DDT_REPIN_BOOELAN	- Generic Boolean interface for REPINLIB.	*/
/* 									*/
/* DDT_REPIN_INTEGER	- Generic Integer interface for REPINLIB.	*/
/* 									*/
/* DDT_REPIN_REAL	- Generic Real interface for REPINLIB.		*/
/* 									*/
/* DDT_REPIN_STRING	- Generic String interface for REPINLIB.	*/
/* 									*/
/* DDT_RASCLASS_SPEC	- Image classification specification for	*/
/*			  RASCLASSLIB					*/
/* 									*/
/* DDT_RASCLASS_FEATURE - Feature class for RASCLASSLIB			*/
/* 									*/
/* DDT_RASCLASS_AREA    - training area for RASCLASSLIB			*/
/* 									*/
/* DDT_VIS    		       - Visibility calculation ded.		*/
/* 									*/
/* DDT_PLOT_CALHCBS	- A CalComp HCBS plot.				*/
/*			  Lull type PLOT_CALHCBS.			*/
/* 									*/
/* DDT_TEST		- TESTLIB descriptor  type.			*/
/*									*/
/* DDT_BBD		- Block buffer data type.			*/
/*									*/
/* DDT_POLYFORM		- POLYFORM ded					*/
/*									*/
/* DDT_VERB		- VERsion Browser ded				*/
/*									*/
/* DDT_NET_SUPPORT	- NETLIB support descriptor for methods		*/
/* 									*/
/* DDT_VERB_COLUMN	- VERsion Browser Column Definer ded		*/
/*									*/
/* DDT_VERB_METADATA	- VERsion Browser MetaData Browser ded		*/
/*									*/
/* DDT_VERB_FILTER	- VERsion Browser Filter Definer ded		*/
/*									*/
/* DDT_SPATIAL_ITERATOR - Iterator for spatial searches			*/
/* 									*/
/* DDT_MORTON_KEY	- Morton Key					*/
/* 									*/
/* DDT_XBAE_TEST	- Test for Xbae Widgets library			*/
/*									*/
/* DDT_GAZETTEER	- GAZETTEER ded					*/
/*									*/
/* DDT_TOPO_PRIM	- TOPOlogy PRIMitive DED			*/
/*									*/
/* DDT_RCLUSTER_SPEC	- Clustering specification - defined in		*/
/*			  RCLUSTERLIB.					*/
/*									*/
/* DDT_RCLUSTER_CLUSTER	- Spectral cluster - defined in RCLUSTERLIB.	*/
/*									*/
/* DDT_RCLUSTER_ALGORITHM - Generic clustering algorithm version 	*/
/*			    container - defined in RCLUSTERLIB.		*/
/*									*/
/* DDT_RCLUSTER_ISODATA_ALOGRITHM - ISODATA clustering algorithm 	*/
/*				    parameter setup - defined in	*/
/*				    RCLUSTERLIB.			*/
/*									*/
/* DDT_RASCLASS_IMAGE	- Image descriptor encapsulating a collection	*/
/*			  of data RACs, a collection of band indices	*/
/*			  (1 band - 1 data plane), optional collections	*/
/*			  of RASCLASSLIB training areas (each defining	*/
/*			  a collection of GEOMETRIES), and an optional	*/
/*			  code RAC holding pixel codings. Defined	*/
/*			  in RASCLASSLIB.				*/
/*									*/
/* DDT_RASCLASS_MEASURE	- Classification distance measure parameters.	*/
/*			  Defined in RASCLASSLIB.			*/
/*									*/
/* DDT_RASCLASS_STATISTICS - Pixel cluster statistics. Defined in	*/
/*			     RASCLASSLIB.				*/
/*									*/
/* DDT_MMIT_TABLE	- MMITLIB Table Interface.			*/
/*									*/
/* DDT_RASTER_IMPORT	- RASTUTLIB raster import.			*/
/*									*/
/* DDT_MMIT_TABLE_CONTROL - MMITLIB Table Control Interface.		*/
/*									*/
/* DDT_COMPOSITE_VINFO	- COMPOSITELIB version information.		*/
/*									*/
/* DDT_API		- APILIB datastructure				*/
/*									*/
/* DDT_NET_LINK		- A network link description.			*/
/*			  Lull type NET_LINK.				*/
/*									*/
/* DDT_NET_NODE		- A network node description.			*/
/*			  Lull type NET_NODE.				*/
/*									*/
/* DDT_NET_ROOT		- A network root description.			*/
/*			  Lull type NET_ROOT.				*/
/*									*/
/* DDT_TABIO		- Tabular input / output.			*/
/*									*/
/* DDT_SOCKET		- Unix BSD Socket.				*/
/*									*/
/* DDT_PLATE		- PLATELIB colour table generator session	*/
/*									*/
/* DDT_PLATE_COLOUR	- RGB colour value for platelib combinations	*/
/*									*/
/* DDT_PLATE_BASE	- Colour base for platelib colour table 	*/
/*			  generator					*/
/*									*/
/* DDT_PLATE_COMBINATION - Legal colour combination collection for use 	*/
/*			   in platelib colour table generation mechanism*/
/*									*/
/* DDT_ISO8211		- ISO8211 file descriptor			*/
/*									*/
/* DDT_DIGIT_TABLE	- Digitising table data structure		*/
/*									*/
/* DDT_DIGIT_AREA	- Area on a digitising table			*/
/*									*/
/* DDT_MMIT_CONTENT	- MMITLIB Table Control Content Sort Interface	*/
/*									*/
/* DDT_REPINX_CONTENT	- REPINXLIB Content (Lookup) interface.		*/
/*									*/
/* DDT_ANSI_TAC		- ANSI Tape Access Context.		      	*/
/*									*/
/* DDT_GENIO		- Generic io device                             */
/*                                                                      */
/* DDT_DBIO		- Database io device                            */
/*                                                                      */
/* DDT_BLOCK		- Block                            		*/
/*                                                                      */
/* DDT_EXAMPLE		- Developer example DED				*/
/*                                                                      */
/* DDT_FRAST_COMP	- File raster data compression info		*/
/*									*/
/* DDT_FILE_RASTER	- File raster data info				*/
/*									*/
/* DDT_STORE		- Internal STORELIB.                            */
/*                                                                      */
/* DDT_META		- Metalib data dictionary.                      */
/*                                                                      */
/* DDT_OBJX		- OBJXLIB descriptor				*/
/*                                                                      */
/* DTT_REDCON		- Redistribution context			*/
/*									*/
/* DDT_PAULRA		- Training example DED for paulra		*/
/*                                                                      */
/* DDT_TONYA		- Training example DED for tonya		*/
/*                                                                      */
/* DDT_USER_PLOT	- PLOTLIB user plot				*/
/*                                                                      */
/* DDT_JOHNWA		- Training example DED for johnwa		*/
/*									*/
/* DDT_BCK		- Database backup and restore context.		*/
/*                                                                      */
/* DDT_BLOCK_LIST	- Block list I/O				*/
/*                                                                      */
/* DDT_PBIDX            - Persistent block and index storage context.   */
/*                                                                      */
/* DDT_BILL		- Training example DED for bill			*/
/*									*/
/* DDT_CATCHMENT	- Catchment area descriptor			*/
/* 									*/ 
/* DDT_DANIEL		- Training example DED for daniel      		*/
/*									*/
/* DDT_SYLVAIN		- Training example DED for sylvain		*/
/*									*/
/* DDT_REPIN_OPTION	- REPINLIB OPTION interface			*/
/*									*/
/* DDT_AUDIT		- Used for audit rail maintenance.		*/
/*									*/
/* DDT_SCALE		- Internal SCALELIB DDT.			*/
/*									*/
/* DDT_SALES_MODEL	- Market Analysis Sales forecasting model	*/
/* 									*/ 
/* DDT_RDB_ITERATOR     - RDB cursor iterator				*/
/* 									*/ 
/* DDT_METACLASS	- Metaclass descriptor.				*/
/* 									*/ 
/* DDT_AFM		- Internal AFMLIB DDT.				*/
/*									*/
/* DDT_RASLINE		- Finding grid points which a geometry crosses	*/
/* 									*/ 
/* DDT_GATE          	- GATELIB Gateway to external RDBMS for 	*/
/*                        attribute storage				*/
/*									*/
/* DDT_DIOX		- Jacket around DIOLIB device and buffer deds,	*/
/* 			  which is registered with IOLIB, to allow	*/
/*			  simple use of magnetic tape			*/
/* 									*/
/* DDT_CLASSGROUP	- Internal CLASSGROUP DDT.			*/
/*									*/
/* DDT_CLUSTERGROUP	- Internal CLUSTERGROUP DDT.			*/
/*									*/
/* DDT_ENDMARKER	- Used for internal housekeeping.		*/
/*----------------------------------------------------------------------*/

/************************************************************************/
/* An enumeration of the possible types of descriptor.			*/
/* Associated macros used to define description strings for this	*/
/* macro, and the names of the Lull constants corresponding to the	*/
/* elements in the enumeration.						*/
/*									*/
/* RULES FOR AMENDMENT:							*/
/*									*/
/* By its very nature, this enumeration and the associated macros will	*/
/* alter over time, as new things need to be added, and old things 	*/
/* become obsolete. 							*/
/* 									*/
/* Any enumeration entries which do not conform to these rules for	*/
/* amendment will cause problems for the code which makes use of the	*/
/* macros defined here. If any such problems do arise, the only	way	*/
/* to correct them, in the short term, may be to remove the offending	*/
/* enumeration entry.							*/
/* 									*/
/* The rules for changing the enumeration are quite simple:		*/
/* 									*/
/* 1) adding a new value						*/
/*									*/
/* 	a) Add the new enumeration element to the enumeration		*/
/* 	   (GOTH_DESCRIPTOR_DATATYPE). If there is an entry of the	*/
/* 	   form OBSOLETE_<n> then you can replace the lowest numbered	*/
/* 	   such with your new item. Otherwise, add the new value to 	*/
/* 	   the end of the list (but before the value DDT_ENDMARKER,	*/
/* 	   which is `anchored')						*/
/* 									*/
/*	+++ IGNORE (b) +++						*/
/*	+++ GOTH_LAST_DDT should always be set to DDT_ENDMARKER	+++	*/
/* 	[[[b) Alter the definition of the GOTH_LAST_DDT macro to be]]]	*/
/* 	[[[   this new element.					   ]]]	*/
/*	+++ IGNORE (b) +++						*/
/* 									*/
/* 	c) Add a textual description of the new element to the		*/
/* 	   macro GOTH_DDT_DESCRIPTION list, in the position 		*/
/* 	   corresponding to that at which the element was added		*/
/* 	   to the enumeration.						*/
/*	   (NB: this list has a comment at the end of it containing	*/
/*	        the word ENDMARKER)					*/
/* 									*/
/* 	d) Add the name of the corresponding Lull constant to the	*/
/* 	   GOTH_DDT_LULL_CONSTANT list, again at the position		*/
/* 	   corresponding to the position of the new element in the	*/
/* 	   enumeration.							*/
/* 									*/
/*	e) The Lull constant names and description strings should not 	*/
/*	   exceed GOTH_DDT_MAX_CHAR-1 characters in length.		*/
/*									*/
/*	f) Add a GD_<name> typedef for your new descriptor		*/
/*	   (NB: the set of these typedefs has a comment at the end,	*/
/*		again containing the word ENDMARKER)			*/
/* 									*/
/* 2) removing a value							*/
/*									*/
/*    After checking that nothing, anywhere at all, in GOTHIC refers	*/
/*    to the old item, replace it by OBSOLETE_<n>, where <n> is one	*/
/*    greater than any other <n> already present in the list (whether	*/
/*    that item occurs before OR after the item being removed). <n>	*/
/*    is thus crudely sensitive to how recently something was removed.	*/
/*    For instance, if the list were					*/
/* 									*/
/*			DDT_INVALID,					*/
/*			DDT_OBSOLETE_2,					*/
/*			DDT_EDITOR,					*/
/*			DDT_WOMBLE,					*/
/*			DDT_OBSOLETE_4					*/
/*									*/
/*    and you wanted to remove `WOMBLE', you would simply replace it	*/
/*    with `OBSOLETE_5'.						*/
/*									*/
/*    (Also, if this leaves a contiguous list of OBSOLETE_<n> entries	*/
/*     at the end of the enumeration, it isn't going to hurt anything	*/
/*     if you remove them - and it will make the thing tidier)		*/
/*									*/
/*    Corresponding changes should be made to the macros:		*/
/* 									*/
/* 			GOTH_LAST_DDT					*/
/* 			GOTH_DDT_DESCRIPTION				*/
/* 			GOTH_DDT_LULL_CONSTANT				*/
/*									*/
/* REMEMBER TO CHANGE THE DOCUMENTATION COMMENT PRECEDING THIS ONE	*/
/* TO REFLECT THE CHANGES MADE TO THE ENUMERATION.			*/
/************************************************************************/

/* begin-def */

typedef enum
{
   DDT_INVALID,
   DDT_WINDOW,
   DDT_OVERLAY,
   DDT_LIST,
   DDT_COLOUR,
   DDT_GRAPHIC,
   DDT_TEMPLATE,
   DDT_HISTORY,
   DDT_STATUS_LIST,
   DDT_OBJECT_ID,
   DDT_STREAM,
   DDT_EDITOR,
   DDT_HYPER,
   DDT_DEVICE,
   DDT_BUFFER,
   DDT_QUERY_TREE,
   DDT_LOOKUP,
   DDT_COLLECTION,
   DDT_BLOCKING,
   DDT_RESULT,
   DDT_SCANBUFFER,
   DDT_SCANENVIRON,
   DDT_LULL_ENVIRONMENT,
   DDT_PORT,
   DDT_ICODE_SEGMENT,
   DDT_BUTTON,
   DDT_VAC,
   DDT_USER_ADDRESS,
   DDT_FOLLOW_CONTEXT,
   DDT_MARK,
   DDT_RAC,
   DDT_GRID,
   DDT_REGION,
   DDT_EXTENT,
   DDT_FAC,
   DDT_GEOMETRY,
   DDT_ARC,
   DDT_SPATIAL_INDEX,
   DDT_CACHE,
   DDT_REGISTRATION,
   DDT_BTRAC,
   DDT_FVLIB,
   DDT_INTERFACE,
   DDT_MANAGER,
   DDT_SPACE_KIND,
   DDT_TRANS_KIND,
   DDT_SPACE,
   DDT_VARIANT,
   DDT_FOLLOW_TYPE,
   DDT_USER_PARAM,
   DDT_SYSTEM_PARAM,
   DDT_WIZARD_PARAM,
   DDT_DOPE,
   DDT_TB_SQ,
   DDT_VTREE,
   DDT_JAB,
   DDT_VTB,
   DDT_FILTER,
   DDT_SMART_USER,
   DDT_SMDB_AC,
   DDT_VTBF,
   DDT_TRANSFER,
   DDT_SMART_PROJECT,
   DDT_SMART_JOB,
   DDT_OBSERVATION_SET,
   DDT_VR,
   DDT_DR,
   DDT_ATB,
   DDT_TOPO_MODEL,
   DDT_STB,
   DDT_TABULATE,
   DDT_BI,
   DDT_MATRIX,
   DDT_MATRIX_EQUATION,
   DDT_TRANSFORM,
   DDT_TRANSFORM_COLLECTION,
   DDT_CPT,
   DDT_CPT_SET,
   DDT_CPT_COLLECTION,
   DDT_RESIDUALS,
   DDT_SCB,
   DDT_SCBC,
   DDT_SCBP,
   DDT_SCBM,
   DDT_SCBPP,
   DDT_SMART_IMAGE,
   DDT_SPACE_TREE,
   DDT_SCBCP,
   DDT_SCBPC,
   DDT_SCBPD,
   DDT_SCBS,
   DDT_NET,
   DDT_SCBPPA,
   DDT_SCBPPB,
   DDT_GLOBAL_INDEX,
   DDT_SCBCM,
   DDT_SCBMC,
   DDT_SCBCMP,
   DDT_SCBMD,
   DDT_TRANSFORM_SPEC,
   DDT_SCBCPP,
   DDT_OBJ_INFO,
   DDT_COLOUR_TABLE,
   DDT_BIB,
   DDT_COMM,
   DDT_SMART_IMAGE_COLN,
   DDT_STDOUT,
   DDT_MAIN_WIDGET,
   DDT_GCP,
   DDT_HISTOGRAM,
   DDT_GENF,
   DDT_ITEM_INTERFACE,
   DDT_PE_INTERFACE,
   DDT_JE_INTERFACE,
   DDT_IS_INTERFACE,
   DDT_LIC_INTERFACE,
   DDT_TEXT,
   DDT_ISIC,
   DDT_QF_INTERFACE,
   DDT_GEOCODER,
   DDT_TDTEMPLATE,
   DDT_COLLIB_TAG,
   DDT_TDT,
   DDT_SMART_PRIVILEGE,
   DDT_TAPE_WINDOW,
   DDT_CLIENT,
   DDT_SERVER,
   DDT_PROTOCOL,
   DDT_CLIENT_GROUP,
   DDT_TAPEHD_ITEM,
   DDT_SMART_DEFAULT,
   DDT_TAPEHD,
   DDT_SPACE_INSTANCE,
   DDT_MMID_INTERFACE,
   DDT_SAT_BITMAP,
   DDT_TPRAG,
   DDT_TPRAG_FN,
   DDT_LCC,
   DDT_CLASSIFIER,
   DDT_DTB,
   DDT_CLASS_LINEAR,
   DDT_PLOT_PS,
   DDT_SPIN,
   DDT_GEN_HISTOGRAM,
   DDT_PAINTOUT,
   DDT_ZONE,
   DDT_FRAME_MANAGER,
   DDT_FRAME,
   DDT_KEYBOARD,
   DDT_TTY,
   DDT_CLASS_SCHEME,
   DDT_CLASS_LINEAR_UNIT,
   DDT_CLASS_HISTOGRAM,
   DDT_CLASS_USER,
   DDT_TRANSFER_INST,
   DDT_TRANSFER_SPEC,
   DDT_SURF,
   DDT_REP_SCHEME,
   DDT_DTM,
   DDT_GUIDE,
   DDT_CHIP, 
   DDT_TXTREC,
   DDT_GV_ARRAY,
   DDT_UES,
   DDT_UES_INTERNAL,
   DDT_DIB,
   DDT_ORTHOIMAGE,
   DDT_DEVNULL,
   DDT_DIB_MARK,
   DDT_SYMBOL,
   DDT_MEASUREMENT_SET,
   DDT_DRB,
   DDT_OBJECT_COLN,
   DDT_MAGIC_NOS,
   DDT_TRANS,
   DDT_SPACE_ROUTE_PLAN,
   DDT_GATEWAY,
   DDT_RASTER_COMB,
   DDT_TRANSFORM_DEFINER,
   DDT_MEASUREMENT_DEFINER,
   DDT_POINT_DEFINER,
   DDT_DTM_QUALITY,
   DDT_DASH,
   DDT_SMART_DTM,
   DDT_ORBIT_MODEL,
   DDT_BULK_TFORM_DEFN,
   DDT_CP_SET,
   DDT_GLIN,
   DDT_MSCAN_BUFFER,
   DDT_SMART_TRANSFORM,
   DDT_LAYOUT,
   DDT_RASSCAN,
   DDT_FIN_STORE,
   DDT_QUEUE,
   DDT_SCRATCH,
   DDT_LSREDIT,
   DDT_COLLIB_AUTO,
   DDT_COLLIB_CS,
   DDT_COLLIB_CS_RGB,
   DDT_COLLIB_CS_GREY,
   DDT_COLLIB_HISTOGRAM,
   DDT_HISTOGRAM_GRAPH,
   DDT_DRAC,
   DDT_PROP_MODEL,
   DDT_PROFILE,
   DDT_LOS,
   DDT_RAL,
   DDT_LR,
   DDT_MERGE_CONTEXT,
   DDT_BIGCOLN,
   DDT_TIMER,
   DDT_REPIN,
   DDT_REPIN_COLOUR,
   DDT_REPIN_BACK_COLOUR,
   DDT_NET_TREE,
   DDT_REPIN_SYMBOL,
   DDT_REPIN_DASH,
   DDT_TRN_GRID,
   DDT_TRAC,
   DDT_RASTER_EXPORT,
   DDT_REPIN_FONT_FAMILY,
   DDT_MMID_PALETTE,
   DDT_MMID_BITMAP,
   DDT_QUERY,
   DDT_ICONBOX,
   DDT_REPIN_FONT,
   DDT_REPIN_BM_SYMBOL,
   DDT_REPIN_RW_SYMBOL,
   DDT_TREC_SYMSET,
   DDT_SEG_INFO,
   DDT_REPIN_BOOLEAN,
   DDT_REPIN_INTEGER,
   DDT_REPIN_REAL,
   DDT_REPIN_STRING,
   DDT_RASCLASS_SPEC,
   DDT_RASCLASS_FEATURE,
   DDT_RASCLASS_AREA,
   DDT_VIS,
   DDT_PLOT_CALHCBS,
   DDT_TEST,
   DDT_BBD,
   DDT_POLYFORM,
   DDT_VERB,
   DDT_NET_SUPPORT,
   DDT_VERB_COLUMN,
   DDT_VERB_METADATA,
   DDT_VERB_FILTER,
   DDT_SPATIAL_ITERATOR,
   DDT_MORTON_KEY,
   DDT_XBAE_TEST,
   DDT_GAZETTEER,
   DDT_TOPO_PRIM,
   DDT_RCLUSTER_SPEC,
   DDT_RCLUSTER_CLUSTER,
   DDT_RCLUSTER_ALGORITHM,
   DDT_RCLUSTER_ISODATA_ALGORITHM,
   DDT_RASCLASS_IMAGE,
   DDT_RASCLASS_MEASURE,
   DDT_RASCLASS_STATISTICS,
   DDT_MMIT_TABLE,
   DDT_RASTER_IMPORT,
   DDT_MMIT_TABLE_CONTROL,
   DDT_COMPOSITE_VINFO,
   DDT_API,
   DDT_NET_LINK,
   DDT_NET_NODE,
   DDT_NET_ROOT,
   DDT_TABIO,
   DDT_SOCKET,
   DDT_PLATE,
   DDT_PLATE_COLOUR,
   DDT_PLATE_BASE,
   DDT_PLATE_COMBINATION,
   DDT_ISO8211,
   DDT_DIGIT_TABLE,
   DDT_DIGIT_AREA,
   DDT_MMIT_CONTENT,
   DDT_REPINX_CONTENT,
   DDT_ANSI_TAC,
   DDT_GENIO,
   DDT_BLOCK,
   DDT_DBIO,
   DDT_EXAMPLE,
   DDT_FRAST_COMP,
   DDT_FILE_RASTER,
   DDT_STORE,
   DDT_META,
   DDT_OBJX,
   DDT_REDCON,
   DDT_PAULRA,
   DDT_TONYA,
   DDT_USER_PLOT,
   DDT_JOHNWA,
   DDT_BCK,
   DDT_BLOCK_LIST,
   DDT_PBIDX,
   DDT_BILL,
   DDT_CATCHMENT,
   DDT_DANIEL,
   DDT_SYLVAIN,
   DDT_REPIN_OPTION,
   DDT_AUDIT,
   DDT_SCALE,
   DDT_SALES_MODEL,
   DDT_RDB_ITERATOR,
   DDT_METACLASS,
   DDT_AFM,
   DDT_RASLINE,   
   DDT_GATE,
   DDT_DIOX,
   DDT_CLASSGROUP,
   DDT_SORT,
   DDT_CLUSTERGROUP,
   DDT_ENDMARKER
} GOTH_DESCRIPTOR_DATATYPE;

/* end-def */

#define GOTH_FIRST_DDT DDT_INVALID
#define GOTH_LAST_DDT DDT_ENDMARKER

#define GOTH_DDT_MAX_CHAR 101

#ifdef DDT_DESC_INIT
static char *goth_ddt_description[] = { 
   "Invalid Descriptor", 
   "Graphics window", 
   "Overlay", 
   "Display list", 
   "Colour table", 
   "Graphic", 
   "Template", 
   "History window", 
   "Status code list", 
   "Object id", 
   "Stream", 
   "Editor window", 
   "Hypercard", 
   "Device", 
   "Device buffer", 
   "Query tree", 
   "Lookup", 
   "Collection", 
   "Blocking context", 
   "RDB result", 
   "Scan buffer", 
   "Scan environment", 
   "LULL environment", 
   "Port", 
   "Icode segment", 
   "Button box", 
   "Version access context", 
   "User defined", 
   "Follow context", 
   "Collection mark", 
   "Raster access context", 
   "Raster grid", 
   "Raster region", 
   "Raster extent", 
   "File access context", 
   "Geometry", 
   "Automatic redraw context", 
   "Spatial index", 
   "Cache", 
   "Registration", 
   "B-tree access context", 
   "File/Version linkage", 
   "MMIX & MMID interface", 
   "Cache manager", 
   "Space kind", 
   "Transformation kind", 
   "Space", 
   "Variant descriptor type", 
   "Overall line following parameters", 
   "User line following parameters", 
   "System line following parameters", 
   "Wizard line following parameters", 
   "Dedicated object processing environment", 
   "Tolerance block", 
   "Version tree snapshot", 
   "Junction access block", 
   "Version Tree Browser", 
   "Raster process filter", 
   "RAE SMART system user", 
   "RAE SMART system database access context", 
   "Version Tree Browser Filter", 
   "CONVERT transfer id (conversion context)", 
   "RAE SMART system project", 
   "RAE SMART system job", 
   "Set of observations", 
   "Value record", 
   "Description record", 
   "Attribute Browser", 
   "Topological model",
   "Structure Browser",
   "Resampling tabulation points structure",
   "Browser Interaction Interface",
   "Sparse Matrix object",
   "Sparse Matrix Equation object",
   "Transform object, RAE project",
   "Transform Collection object, RAE project",
   "Control Point object, RAE project",
   "Control Point Set object, RAE project",
   "Control Point Set Collection object, RAE project",
   "Transform Residuals object, RAE project",
   "Schema Browser",
   "Schema Class Browser",
   "Schema Property Browser",
   "Schema Method Browser",
   "Schema Property Pair Browser",
   "RAE SMART system image",
   "Tree for stringing transformations between spaces together",
   "Schema Class Property Browser",
   "Schema Property Class Browser",
   "Schema Property Define",
   "Schema Sort Interface",
   "Network Analysis Model",
   "Property Pair Add Class Interface",
   "Property Pair Class Browser",
   "Global control point indexing",
   "Schema Class Method Interface",
   "Schema Method Class Interface",
   "Schema Class Method Parameters Interface",
   "Schema Method Define Interface",
   "RAE SMART Transformation Specification",
   "Schema Class Property Parameter Interface",
   "Database object information",
   "Colour table manager",
   "Database Browser",
   "Communication description",
   "RAE SMART image collection",
   "Standard output for GOTHIC",
   "Main widget for GOTHIC",
   "RAE SMART Ground Control Point",
   "Histogram of image data",
   "Generic Form Handler",
   "Generic SMART Item Selector",
   "SMART Project Editor",
   "SMART Job Editor",
   "SMART Image Selector",
   "Licensing interface",
   "Database interface for long textual information", 
   "Information Storage and Interrogation Context", 
   "Query Form Interface",
   "Geocoding parameters",
   "SMART Tape Data Template", 
   "COLLIB UIL Tag", 
   "SMART Tape Data Template Specification", 
   "SMART privilege object", 
   "SMART window on tape buffer for text reading", 
   "IPC client data", 
   "IPC server data", 
   "IPC protocol data", 
   "IPC client group", 
   "SMART Tape header item", 
   "SMART default object", 
   "SMART Tape header", 
   "Instance of space kind", 
   "MMID library interface type", 
   "Satellite bitmap reader/writer library", 
   "SMART tape pragma dictionary", 
   "SMART tape pragma function", 
   "Lull Calling Context", 
   "Classification interface", 
   "IPC data transmission block", 
   "Linear Classification Scheme interface", 
   "PostScript plot", 
   "Space Browser Interface", 
   "Histogram of general purpose data", 
   "Raster paintout", 
   "Search zone", 
   "Frame manager", 
   "Frame instance", 
   "Keyboard interface", 
   "Terminal version of goth_stdout", 
   "Classification Scheme Datastructure", 
   "Classification Scheme linear unit interface", 
   "Classification Scheme histogram interface", 
   "Classification Scheme user defined interface", 
   "Transfer format instance", 
   "Transfer format specification", 
   "A 2.5D surface interpolated over a grid",
   "Representation Scheme",
   "A DTM model for storing qualities and access methods for qualities",
   "A Guidance File substitute",
   "A GCP Chip ie a small extract of raster", 
   "Text record for use in transfer format modules", 
   "An array of typed GOTH_VALUEs", 
   "A User Environment Storage component", 
   "An internal User Environment Storage component", 
   "A Device Independent Buffer", 
   "A transformation specification for generating ortho-images", 
   "Null output device for goth_printf()", 
   "A mark on a Device Independent Buffer", 
   "Symbol for representaion", 
   "Set of measurements", 
   "Description Record Browser", 
   "Collection of objects to be saved by SMSRLIB", 
   "Magic numbers to be used in raster display", 
   "Transformation", 
   "Possible transformation routes between two spaces", 
   "RDBMS Gateway", 
   "Raster combination structure", 
   "Transform Definer ", 
   "Measurement Definer", 
   "Point Definer", 
   "DTM quality", 
   "Dash Specification", 
   "SMART Digital Terrain Model", 
   "Spacecraft Orbital Track Model", 
   "Complex Bulk Transformation Definition Data Structure", 
   "Access mechanism for control points held in a version", 
   "Global Index", 
   "Multiscanlib Buffer", 
   "SMART transformation", 
   "Layout for hardcopy plots", 
   "Data for the rasterization of geometries", 
   "Format storage", 
   "Batch Queue management", 
   "Scratch-Pad", 
   "DDT_LSREDIT - description is missing(again!)", 
   "Collib (auto) for shell-devt upgrade", 
   "Collib (cs) for shell-devt upgrade", 
   "Collib (cs_rgb) for shell-devt upgrade", 
   "Collib (cs_grey) for shell-devt upgrade", 
   "Collib (hist) for shell-devt upgrade", 
   "HISTOLIB for shell-devt upgrade", 
   "Dynamic RAC", 
   "DDT_PROP_MODEL - description is missing(again!)", 
   "DTM Profile", 
   "Line-Of-Sight", 
   "Rutherford-Appleton Labs", 
   "DDT_LR - description is missing(again!)", 
   "Version merging context", 
   "Big Collection", 
   "Timers for Lullx", 
   "Representation Scheme Interface", 
   "Representation Scheme Colour Interface", 
   "Representation Scheme Background Colour Interface", 
   "Tree built during Network Analysis", 
   "Representation Scheme Symbol Interface", 
   "Representation Scheme Dash Interface", 
   "Transformation interpolation grid" ,
   "Text recognition access context", 
   "Access to raster data during export", 
   "Representation Scheme Font Family Interface", 
   "MMIDLIB Palette interface for 8 bit systems", 
   "MMIDLIB Bitmap interface", 
   "OQL query", 
   "Icon Box interface", 
   "REPINLIB font interface", 
   "REPINLIB bitmap symbol interface", 
   "REPINLIB real world symbol interface", 
   "DDT_TREC_SYMSET someone forgot to add the description...", 
   "DDT_SEG_INFO someone forgot to add the description...", 
   "REPINLIB generic boolean interface", 
   "REPINLIB generic integer interface", 
   "REPINLIB generic real interface", 
   "REPINLIB generic string interface", 
   "RASCLASSLIB image classification specification", 
   "RASCLASSLIB image classification feature class", 
   "RASCLASSLIB image classification pixel area/buffer", 
   "VIS visibility calculation data", 
   "CalComp HCBS plot", 
   "TESTLIB testing object", 
   "DDT_BBD forgot description", 
   "DDT_POLYFORM forgot description", 
   "Version Browser interface", 
   "NETLIB Method Support", 
   "Version Browser Column Interface", 
   "Version Browser Meta-Data Interface", 
   "Version Browser Filter Interface", 
   "Spatial Iterator", 
   "Morton Key", 
   "Test Xbae descriptor", 
   "Gazetteer descriptor", 
   "TOPOlogy PRIMitive descriptor",
   "RCLUSTERLIB image pixel clustering specification", 
   "RCLUSTERLIB statistical spectral cluster", 
   "RCLUSTERLIB generic clustering algorithm container", 
   "RCLUSTERLIB ISODATA clustering algorithm parameters", 
   "RASCLASSLIB image descriptor - RACS, bands, GEOMETRIES", 
   "RASCLASSLIB distance measure parameters", 
   "RASCLASSLIB pixel cluster statistics" ,
   "Raster Import",
   "MMIT table",
   "Application Programmer descriptor",
   "Network analysis link description",
   "Network analysis node description",
   "Network analysis root description",
   "Unix Socket",
   "Platelib colour table generation session",
   "Platelib base pure colour description",
   "Platelib base colour description",
   "Platelib legal combination of bases",
   "ISO8211 file descriptor",
   "Digitising table descriptor",
   "Area of a digitising table",
   "Table control content sort interface",
   "Extended Repinlib interface for text contents",
   "ANSI Standard Tape Access Context",
   "Generic IO",
   "Block",
   "Database IO",
   "Example",
   "Raster file data compression information",
   "Raster file data information",
   "Storelib",
   "Data dictionary",
   "OBJXLIB descriptor",
   "redistribution context",
   "Training example for paulra",
   "Training example for tonya",
   "PLOTLIB user plot",
   "Training example for johnwa",
   "Database backup and restore context",
   "block list IO descriptor",
   "Persistent block and index storage context",
   "Training example for bill",
   "Market Analysis catchment area"
   "Training example for daniel",
   "Training example for sylvain",
   "REPIN option interface for generic REPINLIB use",
   "Audit trail context.",
   "Scale Range descriptor",
   "Market Analysis Sales forecasting model",
   "RDB cursor iterator",
   "Metaclass descriptor",
   "AFM descriptor",
   "Descriptor to return iteratively grid points covered by a line",
   "RDBMS Gate Definition", 
   "DIOXLIB ded - Direct magnetic tape I/O for use with IOLIB",
   "Class group",
   "Sorter",
   "Cluster group"
};
#endif

/* ENDMARKER - this comment inserted for searching purposes */
#ifdef DEFFILE
/* this data structure should only be compiled into test_main.o */
static char *goth_ddt_lull[] = {
   "DDT_INVALID", 
   "DDT_WINDOW", 
   "DDT_OVERLAY", 
   "DDT_LIST", 
   "DDT_COLOUR", 
   "DDT_GRAPHIC", 
   "DDT_TEMPLATE", 
   "DDT_HISTORY", 
   "DDT_STATUS_LIST", 
   "DDT_OBJECT_ID", 
   "DDT_STREAM", 
   "DDT_EDITOR", 
   "DDT_HYPER", 
   "DDT_DEVICE", 
   "DDT_BUFFER", 
   "DDT_QUERY_TREE", 
   "DDT_LOOKUP", 
   "DDT_COLLECTION", 
   "DDT_BLOCKING", 
   "DDT_RESULT", 
   "DDT_SCANBUFFER", 
   "DDT_SCANENVIRON", 
   "DDT_LULL_ENVIRONMENT", 
   "DDT_PORT", 
   "DDT_ICODE_SEGMENT", 
   "DDT_BUTTON", 
   "DDT_VAC", 
   "DDT_USER_ADDRESS", 
   "DDT_FOLLOW_CONTEXT", 
   "DDT_MARK", 
   "DDT_RAC", 
   "DDT_GRID", 
   "DDT_REGION", 
   "DDT_EXTENT", 
   "DDT_FAC", 
   "DDT_GEOMETRY", 
   "DDT_ARC", 
   "DDT_SPATIAL_INDEX", 
   "DDT_CACHE", 
   "DDT_REGISTRATION", 
   "DDT_BTRAC", 
   "DDT_FVLIB", 
   "DDT_INTERFACE", 
   "DDT_MANAGER", 
   "DDT_SPACE_KIND", 
   "DDT_TRANS_KIND", 
   "DDT_SPACE", 
   "DDT_VARIANT", 
   "DDT_FOLLOW_TYPE", 
   "DDT_USER_PARAM", 
   "DDT_SYSTEM_PARAM", 
   "DDT_WIZARD_PARAM", 
   "DDT_DOPE", 
   "DDT_TB_SQ", 
   "DDT_VTREE", 
   "DDT_JAB", 
   "DDT_VTB", 
   "DDT_FILTER", 
   "DDT_SMART_USER", 
   "DDT_SMDB_AC", 
   "DDT_VTBF", 
   "DDT_TRANSFER", 
   "DDT_PROJECT", 
   "DDT_JOB", 
   "DDT_OBSERVATION_SET", 
   "DDT_VR", 
   "DDT_DR", 
   "DDT_ATB", 
   "DDT_TOPO_MODEL", 
   "DDT_STB", 
   "DDT_TABULATE", 
   "DDT_BI",
   "DDT_MATRIX", 
   "DDT_MATRIX_EQUATION", 
   "DDT_TRANSFORM", 
   "DDT_TRANSFORM_COLLECTION", 
   "DDT_CPT", 
   "DDT_CPT_SET", 
   "DDT_CPT_COLLECTION", 
   "DDT_RESIDUALS",
   "DDT_SCB",
   "DDT_SCBC",
   "DDT_SCBP",
   "DDT_SCBM",
   "DDT_SCBPP",
   "DDT_SMART_IMAGE",
   "DDT_SPACE_TREE",
   "DDT_SCBCP",
   "DDT_SCBPC",
   "DDT_SCBPD",
   "DDT_SCBS",
   "DDT_NET",
   "DDT_SCBPPA",
   "DDT_SCBPPB",
   "DDT_GLOBAL_INDEX",
   "DDT_SCBCM",
   "DDT_SCBMC",
   "DDT_SCBCMP",
   "DDT_SCBMD",
   "DDT_TRANSFORM_SPEC",
   "DDT_SCBCPP",
   "DDT_OBJ_INFO",
   "DDT_COLOUR_TABLE",
   "DDT_BIB",
   "DDT_COMM",
   "DDT_SMART_IMAGE_COLN",
   "DDT_STDOUT",
   "DDT_MAIN_WIDGET",
   "DDT_GCP",
   "DDT_HISTOGRAM",
   "DDT_GENF",
   "DDT_ITEM_INTERFACE",
   "DDT_PE_INTERFACE",
   "DDT_JE_INTERFACE",
   "DDT_IS_INTERFACE",
   "DDT_LIC_INTERFACE",
   "DDT_TEXT",
   "DDT_ISIC",
   "DDT_QF_INTERFACE",
   "DDT_GEOCODER",
   "DDT_TDTEMPLATE", 
   "DDT_COLLIB_TAG", 
   "DDT_TDT", 
   "DDT_SMART_PRIVILEGE", 
   "DDT_TAPE_WINDOW", 
   "DDT_CLIENT", 
   "DDT_SERVER", 
   "DDT_PROTOCOL", 
   "DDT_CLIENT_GROUP", 
   "DDT_TAPEHD_ITEM", 
   "DDT_SMART_DEFAULT", 
   "DDT_TAPEHD", 
   "DDT_SPACE_INSTANCE", 
   "DDT_MMID_INTERFACE", 
   "DDT_SAT_BITMAP", 
   "DDT_TPRAG", 
   "DDT_TPRAG_FN", 
   "DDT_LCC", 
   "DDT_CLASSIFIER", 
   "DDT_DTB", 
   "DDT_CLASS_LINEAR", 
   "DDT_PLOT_PS", 
   "DDT_SPIN", 
   "DDT_GEN_HISTOGRAM", 
   "DDT_PAINTOUT", 
   "DDT_ZONE", 
   "DDT_FRAME_MANAGER", 
   "DDT_FRAME", 
   "DDT_KEYBOARD", 
   "DDT_TTY", 
   "DDT_CLASS_SCHEME", 
   "DDT_CLASS_LINEAR_UNIT", 
   "DDT_CLASS_HISTOGRAM", 
   "DDT_CLASS_USER", 
   "DDT_TRANSFER_INST", 
   "DDT_TRANSFER_SPEC", 
   "DDT_SURF", 
   "DDT_REP_SCHEME", 
   "DDT_DTM", 
   "DDT_GUIDE", 
   "DDT_CHIP", 
   "DDT_TXTREC", 
   "DDT_GV_ARRAY", 
   "DDT_UES", 
   "DDT_UES_INTERNAL", 
   "DDT_DIB", 
   "DDT_ORTHOIMAGE", 
   "DDT_DEVNULL", 
   "DDT_DIB_MARK", 
   "DDT_SYMBOL", 
   "DDT_MEASUREMENT_SET", 
   "DDT_DRB", 
   "DDT_OBJECT_COLN", 
   "DDT_MAGIC_NOS", 
   "DDT_TRANS", 
   "DDT_SPACE_ROUTE_PLAN", 
   "DDT_GATEWAY", 
   "DDT_RASTER_COMB", 
   "DDT_TRANSFORM_DEFINER", 
   "DDT_MEASUREMENT_DEFINER", 
   "DDT_POINT_DEFINER", 
   "DDT_DTM_QUALITY", 
   "DDT_DASH", 
   "DDT_SMART_DTM", 
   "DDT_ORBIT_MODEL", 
   "DDT_BULK_TFORM_DEFN", 
   "DDT_CP_SET", 
   "DDT_GLIN", 
   "DDT_MSCAN_BUFFER", 
   "DDT_SMART_TRANSFORM", 
   "DDT_LAYOUT", 
   "DDT_RASSCAN", 
   "DDT_FIN_STORE", 
   "DDT_QUEUE", 
   "DDT_SCRATCH", 
   "DDT_LSREDIT", 
   "DDT_COLLIB_AUTO", 
   "DDT_COLLIB_CS", 
   "DDT_COLLIB_CS_RGB", 
   "DDT_COLLIB_CS_GREY", 
   "DDT_COLLIB_HISTOGRAM", 
   "DDT_HISTOGRAM_GRAPH", 
   "DDT_DRAC", 
   "DDT_PROP_MODEL", 
   "DDT_PROFILE", 
   "DDT_LOS", 
   "DDT_RAL", 
   "DDT_LR", 
   "DDT_MERGE_CONTEXT", 
   "DDT_BIGCOLN", 
   "DDT_TIMER", 
   "DDT_REPIN", 
   "DDT_REPIN_COLOUR", 
   "DDT_REPIN_BACK_COLOUR", 
   "DDT_NET_TREE", 
   "DDT_REPIN_SYMBOL", 
   "DDT_REPIN_DASH", 
   "DDT_TRN_GRID", 
   "DDT_TRAC", 
   "DDT_RASTER_EXPORT", 
   "DDT_REPIN_FONT_FAMILY", 
   "DDT_MMID_PALETTE", 
   "DDT_MMID_BITMAP", 
   "DDT_QUERY", 
   "DDT_ICONBOX", 
   "DDT_REPIN_FONT", 
   "DDT_REPIN_BM_SYMBOL", 
   "DDT_REPIN_RW_SYMBOL", 
   "DDT_TREC_SYMSET", 
   "DDT_SEG_INFO", 
   "DDT_REPIN_BOOLEAN", 
   "DDT_REPIN_INTEGER", 
   "DDT_REPIN_REAL", 
   "DDT_REPIN_STRING", 
   "DDT_RASCLASS_SPEC", 
   "DDT_RASCLASS_FEATURE", 
   "DDT_RASCLASS_AREA", 
   "DDT_VIS", 
   "DDT_PLOT_CALHCBS", 
   "DDT_TEST", 
   "DDT_BBD", 
   "DDT_POLYFORM", 
   "DDT_VERB", 
   "DDT_NET_SUPPORT", 
   "DDT_VERB_COLUMN", 
   "DDT_VERB_METADATA", 
   "DDT_VERB_FILTER", 
   "DDT_SPATIAL_ITERATOR", 
   "DDT_MORTON_KEY", 
   "DDT_XBAE_TEST", 
   "DDT_GAZETTERR", 
   "DDT_TOPO_PRIM", 
   "DDT_RCLUSTER_SPEC", 
   "DDT_RCLUSTER_CLUSTER", 
   "DDT_RCLUSTER_ALGORITHM", 
   "DDT_RCLUSTER_ISODATA_ALGORITHM", 
   "DDT_RASCLASS_IMAGE", 
   "DDT_RASCLASS_MEASURE", 
   "DDT_RASCLASS_STATISTICS", 
   "DDT_MMIT_TABLE",
   "DDT_RASTER_IMPORT",
   "DDT_MMIT_TABLE_CONTROL",
   "DDT_COMPOSITE_VINFO",
   "DDT_API",
   "DDT_NET_LINK",
   "DDT_NET_NODE",
   "DDT_NET_ROOT",
   "DDT_TABIO",
   "DDT_SOCKET",
   "DDT_PLATE",
   "DDT_PLATE_COLOUR",
   "DDT_PLATE_BASE",
   "DDT_PLATE_COMBINATION",
   "DDT_ISO8211",
   "DDT_DIGIT_TABLE",
   "DDT_DIGIT_AREA",
   "DDT_MMIT_CONTENT",
   "DDT_REPINX_CONTENT",
   "DDT_ANSI_TAC",
   "DDT_GENIO",
   "DDT_BLOCK",
   "DDT_DBIO",
   "DDT_EXAMPLE",
   "DDT_FRAST_COMP",
   "DDT_FILE_RASTER",
   "DDT_STORE",
   "DDT_META",
   "DDT_OBJX",
   "DDT_REDCON",
   "DDT_PAULRA",
   "DDT_TONYA",
   "DDT_USER_PLOT",
   "DDT_JOHNWA",
   "DDT_BCK",
   "DTT_BLOCK_LIST",
   "DDT_PBIDX",
   "DDT_BILL",
   "DDT_CATCHMENT",
   "DDT_DANIEL",
   "DDT_SYLVAIN",
   "DDT_REPIN_OPTION",
   "DDT_AUDIT",
   "DDT_SCALE",
   "DDT_SALES_MODEL",
   "DDT_RDB_ITERATOR",
   "DDT_METACLASS",
   "DDT_AFM",
   "DDT_RASLINE",
   "DDT_GATE",
   "DDT_DIOX",
   "DDT_CLASSGROUP",
   "DDT_SORT",
   "DDT_CLUSTERGROUP",
   "DDT_ENDMARKER"
};
#endif

/* typedefs for each descriptor type */

typedef GOTH_DESCRIPTOR GD_WINDOW;
typedef GOTH_DESCRIPTOR GD_OVERLAY;
typedef GOTH_DESCRIPTOR GD_LIST;
typedef GOTH_DESCRIPTOR GD_COLOUR;
typedef GOTH_DESCRIPTOR GD_GRAPHIC;
typedef GOTH_DESCRIPTOR GD_TEMPLATE;
typedef GOTH_DESCRIPTOR GD_HISTORY;
typedef GOTH_DESCRIPTOR GD_STATUS_LIST;
typedef GOTH_DESCRIPTOR GD_OBJECT_ID;
typedef GOTH_DESCRIPTOR GD_STREAM;
typedef GOTH_DESCRIPTOR GD_EDITOR;
typedef GOTH_DESCRIPTOR GD_HYPER;
typedef GOTH_DESCRIPTOR GD_DEVICE;
typedef GOTH_DESCRIPTOR GD_BUFFER;
typedef GOTH_DESCRIPTOR GD_QUERY_TREE;
typedef GOTH_DESCRIPTOR GD_LOOKUP;
typedef GOTH_DESCRIPTOR GD_COLLECTION;
typedef GOTH_DESCRIPTOR GD_BLOCKING;
typedef GOTH_DESCRIPTOR GD_RESULT;
typedef GOTH_DESCRIPTOR GD_SCANBUFFER;
typedef GOTH_DESCRIPTOR GD_SCANENVIRON;
typedef GOTH_DESCRIPTOR GD_LULL_ENVIRONMENT;
typedef GOTH_DESCRIPTOR GD_PORT;
typedef GOTH_DESCRIPTOR GD_ICODE_SEGMENT;
typedef GOTH_DESCRIPTOR GD_BUTTON;
typedef GOTH_DESCRIPTOR GD_VAC;
typedef GOTH_DESCRIPTOR GD_USER_ADDRESS;
typedef GOTH_DESCRIPTOR GD_FOLLOW_CONTEXT;
typedef GOTH_DESCRIPTOR GD_MARK;
typedef GOTH_DESCRIPTOR GD_RAC;
typedef GOTH_DESCRIPTOR GD_GRID;
typedef GOTH_DESCRIPTOR GD_REGION;
typedef GOTH_DESCRIPTOR GD_EXTENT;
typedef GOTH_DESCRIPTOR GD_FAC;
typedef GOTH_DESCRIPTOR GD_GEOMETRY;
typedef GOTH_DESCRIPTOR GD_ARC;
typedef GOTH_DESCRIPTOR GD_SPATIAL_INDEX;
typedef GOTH_DESCRIPTOR GD_CACHE;
typedef GOTH_DESCRIPTOR GD_REGISTRATION;
typedef GOTH_DESCRIPTOR GD_BTRAC;
typedef GOTH_DESCRIPTOR GD_FVLIB;
typedef GOTH_DESCRIPTOR GD_INTERFACE;
typedef GOTH_DESCRIPTOR GD_MANAGER;
typedef GOTH_DESCRIPTOR GD_SPACE_KIND;
typedef GOTH_DESCRIPTOR GD_TRANS_KIND;
typedef GOTH_DESCRIPTOR GD_SPACE;
typedef GOTH_DESCRIPTOR GD_VARIANT;
typedef GOTH_DESCRIPTOR GD_FOLLOW_TYPE;
typedef GOTH_DESCRIPTOR GD_USER_PARAM;
typedef GOTH_DESCRIPTOR GD_SYSTEM_PARAM;
typedef GOTH_DESCRIPTOR GD_WIZARD_PARAM;
typedef GOTH_DESCRIPTOR GD_DOPE;
typedef GOTH_DESCRIPTOR GD_TB_SQ;
typedef GOTH_DESCRIPTOR GD_VTREE;
typedef GOTH_DESCRIPTOR GD_JAB;
typedef GOTH_DESCRIPTOR GD_VTB;
typedef GOTH_DESCRIPTOR GD_FILTER;
typedef GOTH_DESCRIPTOR GD_SMART_USER;
typedef GOTH_DESCRIPTOR GD_SMDB_AC;
typedef GOTH_DESCRIPTOR GD_VTBF;
typedef GOTH_DESCRIPTOR GD_TRANSFER;
typedef GOTH_DESCRIPTOR GD_SMART_PROJECT;
typedef GOTH_DESCRIPTOR GD_SMART_JOB;
typedef GOTH_DESCRIPTOR GD_OBSERVATION_SET;
typedef GOTH_DESCRIPTOR GD_VR;
typedef GOTH_DESCRIPTOR GD_DR;
typedef GOTH_DESCRIPTOR GD_ATB;
typedef GOTH_DESCRIPTOR GD_TOPO_MODEL;
typedef GOTH_DESCRIPTOR GD_STB;
typedef GOTH_DESCRIPTOR GD_TABULATE;
typedef GOTH_DESCRIPTOR GD_BI;
typedef GOTH_DESCRIPTOR GD_MATRIX;
typedef GOTH_DESCRIPTOR GD_MATRIX_EQUATION;
typedef GOTH_DESCRIPTOR GD_TRANSFORM;
typedef GOTH_DESCRIPTOR GD_TRANSFORM_COLLECTION;
typedef GOTH_DESCRIPTOR GD_CPT;
typedef GOTH_DESCRIPTOR GD_CPT_SET;
typedef GOTH_DESCRIPTOR GD_CPT_COLLECTION;
typedef GOTH_DESCRIPTOR GD_RESIDUALS;
typedef GOTH_DESCRIPTOR GD_SCB;
typedef GOTH_DESCRIPTOR GD_SCBC;
typedef GOTH_DESCRIPTOR GD_SCBP;
typedef GOTH_DESCRIPTOR GD_SCBM;
typedef GOTH_DESCRIPTOR GD_SCBPP;
typedef GOTH_DESCRIPTOR GD_SMART_IMAGE;
typedef GOTH_DESCRIPTOR GD_SPACE_TREE;
typedef GOTH_DESCRIPTOR GD_SCBCP;
typedef GOTH_DESCRIPTOR GD_SCBPC;
typedef GOTH_DESCRIPTOR GD_SCBPD;
typedef GOTH_DESCRIPTOR GD_SCBS;
typedef GOTH_DESCRIPTOR GD_NET;
typedef GOTH_DESCRIPTOR GD_SCBPPA;
typedef GOTH_DESCRIPTOR GD_SCBPPB;
typedef GOTH_DESCRIPTOR GD_GLOBAL_INDEX;
typedef GOTH_DESCRIPTOR GD_SCBCM;
typedef GOTH_DESCRIPTOR GD_SCBMC;
typedef GOTH_DESCRIPTOR GD_SCBCMP;
typedef GOTH_DESCRIPTOR GD_SCBMD;
typedef GOTH_DESCRIPTOR GD_TRANSFORM_SPEC;
typedef GOTH_DESCRIPTOR GD_SCBCPP;
typedef GOTH_DESCRIPTOR GD_OBJ_INFO;
typedef GOTH_DESCRIPTOR GD_COLOUR_TABLE;
typedef GOTH_DESCRIPTOR GD_BIB;
typedef GOTH_DESCRIPTOR GD_COMM;
typedef GOTH_DESCRIPTOR GD_SMART_IMAGE_COLN;
typedef GOTH_DESCRIPTOR GD_STDOUT;
typedef GOTH_DESCRIPTOR GD_MAIN_WIDGET;
typedef GOTH_DESCRIPTOR GD_GCP;
typedef GOTH_DESCRIPTOR GD_HISTOGRAM;
typedef GOTH_DESCRIPTOR GD_GENF;
typedef GOTH_DESCRIPTOR GD_ITEM_INTERFACE;
typedef GOTH_DESCRIPTOR GD_PE_INTERFACE;
typedef GOTH_DESCRIPTOR GD_JE_INTERFACE;
typedef GOTH_DESCRIPTOR GD_IS_INTERFACE;
typedef GOTH_DESCRIPTOR GD_LIC_INTERFACE;
typedef GOTH_DESCRIPTOR GD_TEXT;
typedef GOTH_DESCRIPTOR GD_ISIC;
typedef GOTH_DESCRIPTOR GD_QF_INTERFACE;
typedef GOTH_DESCRIPTOR GD_GEOCODER;
typedef GOTH_DESCRIPTOR GD_TDTEMPLATE;
typedef GOTH_DESCRIPTOR GD_COLLIB_TAG;
typedef GOTH_DESCRIPTOR GD_TDT;
typedef GOTH_DESCRIPTOR GD_SMART_PRIVILEGE;
typedef GOTH_DESCRIPTOR GD_TAPE_WINDOW;
typedef GOTH_DESCRIPTOR GD_CLIENT;
typedef GOTH_DESCRIPTOR GD_SERVER;
typedef GOTH_DESCRIPTOR GD_PROTOCOL;
typedef GOTH_DESCRIPTOR GD_CLIENT_GROUP;
typedef GOTH_DESCRIPTOR GD_TAPEHD_ITEM;
typedef GOTH_DESCRIPTOR GD_SMART_DEFAULT;
typedef GOTH_DESCRIPTOR GD_TAPEHD;
typedef GOTH_DESCRIPTOR GD_SPACE_INSTANCE;
typedef GOTH_DESCRIPTOR GD_MMID_INTERFACE;
typedef GOTH_DESCRIPTOR GD_SAT_BITMAP;
typedef GOTH_DESCRIPTOR GD_TPRAG;
typedef GOTH_DESCRIPTOR GD_TPRAG_FN;
typedef GOTH_DESCRIPTOR	GD_LCC;
typedef GOTH_DESCRIPTOR	GD_CLASSIFIER;
typedef GOTH_DESCRIPTOR	GD_DTB;
typedef GOTH_DESCRIPTOR	GD_CLASS_LIN;
typedef GOTH_DESCRIPTOR	GD_PLOT_PS;
typedef GOTH_DESCRIPTOR	GD_SPIN;
typedef GOTH_DESCRIPTOR	GD_GEN_HISTOGRAM;
typedef GOTH_DESCRIPTOR GD_PAINTOUT;
typedef GOTH_DESCRIPTOR GD_ZONE;
typedef GOTH_DESCRIPTOR GD_FRAME_MANAGER;
typedef GOTH_DESCRIPTOR GD_FRAME;
typedef GOTH_DESCRIPTOR GD_KEYBOARD;
typedef GOTH_DESCRIPTOR GD_TTY;
typedef GOTH_DESCRIPTOR GD_CLASS_SCHEME;
typedef GOTH_DESCRIPTOR GD_CLASS_LINEAR_UNIT;
typedef GOTH_DESCRIPTOR GD_CLASS_HISTOGRAM;
typedef GOTH_DESCRIPTOR GD_CLASS_USER;
typedef GOTH_DESCRIPTOR GD_TRANSFER_INST;
typedef GOTH_DESCRIPTOR GD_TRANSFER_SPEC;
typedef GOTH_DESCRIPTOR GD_SURF;
typedef GOTH_DESCRIPTOR GD_REP_SCHEME;
typedef GOTH_DESCRIPTOR GD_DTM;
typedef GOTH_DESCRIPTOR GD_GUIDE;
typedef GOTH_DESCRIPTOR GD_CHIP;
typedef GOTH_DESCRIPTOR GD_TXTREC;
typedef GOTH_DESCRIPTOR	GD_GV_ARRAY;
typedef GOTH_DESCRIPTOR	GD_UES;
typedef GOTH_DESCRIPTOR	GD_UES_INTERNAL;
typedef GOTH_DESCRIPTOR	GD_DIB;
typedef GOTH_DESCRIPTOR	GD_ORTHOIMAGE;
typedef GOTH_DESCRIPTOR	GD_DEVNULL;
typedef GOTH_DESCRIPTOR	GD_DIB_MARK;
typedef GOTH_DESCRIPTOR	GD_SYMBOL;
typedef GOTH_DESCRIPTOR GD_MEASUREMENT_SET;
typedef GOTH_DESCRIPTOR	GD_DRB;
typedef GOTH_DESCRIPTOR	GD_OBJECT_COLN;
typedef GOTH_DESCRIPTOR GD_MAGIC_NOS;
typedef GOTH_DESCRIPTOR GD_TRANS;
typedef GOTH_DESCRIPTOR GD_SPACE_ROUTE_PLAN;
typedef GOTH_DESCRIPTOR GD_GATEWAY;
typedef GOTH_DESCRIPTOR GD_RASTER_COMB;
typedef GOTH_DESCRIPTOR GD_TRANSFORM_DEFINER;
typedef GOTH_DESCRIPTOR GD_MEASUREMENT_DEFINER;
typedef GOTH_DESCRIPTOR GD_POINT_DEFINER;
typedef GOTH_DESCRIPTOR GD_DTM_QUALITY;
typedef GOTH_DESCRIPTOR GD_DASH;
typedef GOTH_DESCRIPTOR GD_SMART_DTM;
typedef GOTH_DESCRIPTOR GD_ORBIT_MODEL;
typedef GOTH_DESCRIPTOR GD_BULK_TFORM_DEFN;
typedef GOTH_DESCRIPTOR GD_CP_SET;
typedef GOTH_DESCRIPTOR GD_GLIN;
typedef	GOTH_DESCRIPTOR GD_MSCAN_BUFFER;
typedef	GOTH_DESCRIPTOR GD_SMART_TRANSFORM;
typedef GOTH_DESCRIPTOR	GD_LAYOUT;
typedef GOTH_DESCRIPTOR	GD_RASSCAN;
typedef GOTH_DESCRIPTOR GD_FIN_STORE;
typedef GOTH_DESCRIPTOR GD_QUEUE;
typedef GOTH_DESCRIPTOR GD_SCRATCH;
typedef GOTH_DESCRIPTOR	GD_LSREDIT;
typedef GOTH_DESCRIPTOR	GD_COLLIB_AUTO;
typedef GOTH_DESCRIPTOR	GD_COLLIB_CS;
typedef GOTH_DESCRIPTOR	GD_COLLIB_CS_RGB;
typedef GOTH_DESCRIPTOR	GD_COLLIB_CS_GREY;
typedef GOTH_DESCRIPTOR	GD_COLLIB_HISTOGRAM;
typedef GOTH_DESCRIPTOR GD_HISTOGRAM_GRAPH;
typedef GOTH_DESCRIPTOR GD_DRAC;
typedef GOTH_DESCRIPTOR	GD_PROP_MODEL;
typedef GOTH_DESCRIPTOR	GD_PROFILE;
typedef GOTH_DESCRIPTOR	GD_LOS;
typedef GOTH_DESCRIPTOR	GD_RAL;
typedef GOTH_DESCRIPTOR	GD_LR;
typedef GOTH_DESCRIPTOR	GD_MERGE_CONTEXT;
typedef GOTH_DESCRIPTOR GD_BIGCOLN;
typedef GOTH_DESCRIPTOR GD_TIMER;
typedef GOTH_DESCRIPTOR GD_REPIN;
typedef GOTH_DESCRIPTOR GD_REPIN_COLOUR;
typedef GOTH_DESCRIPTOR GD_REPIN_BACK_COLOUR;
typedef GOTH_DESCRIPTOR GD_NET_TREE;
typedef GOTH_DESCRIPTOR GD_REPIN_SYMBOL;
typedef GOTH_DESCRIPTOR GD_REPIN_DASH;
typedef GOTH_DESCRIPTOR GD_TRN_GRID;
typedef GOTH_DESCRIPTOR GD_TRAC;
typedef GOTH_DESCRIPTOR GD_RASTER_EXPORT;
typedef GOTH_DESCRIPTOR GD_REPIN_FONT_FAMILY;
typedef GOTH_DESCRIPTOR GD_MMID_PALETTE;
typedef GOTH_DESCRIPTOR GD_MMID_BITMAP;
typedef GOTH_DESCRIPTOR	GD_QUERY;
typedef GOTH_DESCRIPTOR	GD_ICONBOX;
typedef GOTH_DESCRIPTOR GD_REPIN_FONT;
typedef GOTH_DESCRIPTOR GD_REPIN_BM_SYMBOL;
typedef GOTH_DESCRIPTOR GD_REPIN_RW_SYMBOL;
typedef GOTH_DESCRIPTOR GD_TREC_SYMSET;
typedef GOTH_DESCRIPTOR GD_SEG_INFO;
typedef GOTH_DESCRIPTOR GD_REPIN_BOOLEAN;
typedef GOTH_DESCRIPTOR GD_REPIN_INTEGER;
typedef GOTH_DESCRIPTOR GD_REPIN_REAL;
typedef GOTH_DESCRIPTOR GD_REPIN_STRING;
typedef GOTH_DESCRIPTOR GD_RASCLASS_SPEC;
typedef GOTH_DESCRIPTOR GD_RASCLASS_FEATURE;
typedef GOTH_DESCRIPTOR GD_RASCLASS_AREA;
typedef GOTH_DESCRIPTOR GD_VIS ;
typedef GOTH_DESCRIPTOR GD_PLOT_CALHCBS ;
typedef GOTH_DESCRIPTOR GD_TEST ;
typedef GOTH_DESCRIPTOR GD_BBD ;
typedef GOTH_DESCRIPTOR GD_POLYFORM ;
typedef GOTH_DESCRIPTOR GD_VERB;
typedef GOTH_DESCRIPTOR GD_NET_SUPPORT ;
typedef GOTH_DESCRIPTOR GD_VERB_COLUMN;
typedef GOTH_DESCRIPTOR GD_VERB_METADATA;
typedef GOTH_DESCRIPTOR GD_VERB_FILTER;
typedef GOTH_DESCRIPTOR GD_SPATIAL_ITERATOR;
typedef GOTH_DESCRIPTOR GD_MORTON_KEY;
typedef GOTH_DESCRIPTOR GD_XBAE_TEST;
typedef	GOTH_DESCRIPTOR	GD_GAZETTEER;
typedef	GOTH_DESCRIPTOR	GD_TOPO_PRIM;
typedef GOTH_DESCRIPTOR GD_RCLUSTER_SPEC;
typedef GOTH_DESCRIPTOR GD_RCLUSTER_CLUSTER;
typedef GOTH_DESCRIPTOR GD_RCLUSTER_ALGORITHM;
typedef GOTH_DESCRIPTOR GD_RCLUSTER_ISODATA_ALGORITHM;
typedef GOTH_DESCRIPTOR GD_RASCLASS_IMAGE;
typedef GOTH_DESCRIPTOR GD_RASCLASS_MEASURE;
typedef GOTH_DESCRIPTOR GD_RASCLASS_STATISTICS;
typedef GOTH_DESCRIPTOR GD_MMIT_TABLE;
typedef GOTH_DESCRIPTOR GD_RASTER_IMPORT;
typedef GOTH_DESCRIPTOR GD_MMIT_TABLE_CONTROL;
typedef GOTH_DESCRIPTOR GD_COMPOSITE_VINFO;
typedef GOTH_DESCRIPTOR GD_API;
typedef GOTH_DESCRIPTOR GD_NET_LINK;
typedef GOTH_DESCRIPTOR GD_NET_NODE;
typedef GOTH_DESCRIPTOR GD_NET_ROOT;
typedef GOTH_DESCRIPTOR GD_TABIO;
typedef GOTH_DESCRIPTOR GD_SOCKET;
typedef GOTH_DESCRIPTOR GD_PLATE;
typedef GOTH_DESCRIPTOR GD_PLATE_COLOUR;
typedef GOTH_DESCRIPTOR GD_PLATE_BASE;
typedef GOTH_DESCRIPTOR GD_PLATE_COMBINATION;
typedef GOTH_DESCRIPTOR GD_ISO8211;
typedef GOTH_DESCRIPTOR GD_DIGIT_TABLE;
typedef GOTH_DESCRIPTOR GD_DIGIT_AREA;
typedef GOTH_DESCRIPTOR GD_MMIT_CONTENT;
typedef GOTH_DESCRIPTOR GD_REPINX_CONTENT;
typedef GOTH_DESCRIPTOR GD_ANSI_TAC;
typedef GOTH_DESCRIPTOR GD_GENIO;
typedef GOTH_DESCRIPTOR GD_BLOCK;
typedef GOTH_DESCRIPTOR GD_DBIO;
typedef GOTH_DESCRIPTOR GD_EXAMPLE;
typedef GOTH_DESCRIPTOR GD_FRAST_COMP;
typedef GOTH_DESCRIPTOR GD_FILE_RASTER;
typedef GOTH_DESCRIPTOR GD_STORE;
typedef GOTH_DESCRIPTOR GD_META;
typedef GOTH_DESCRIPTOR GD_OBJX;
typedef GOTH_DESCRIPTOR GD_REDCON;
typedef GOTH_DESCRIPTOR GD_PAULRA;
typedef GOTH_DESCRIPTOR GD_TONYA;
typedef GOTH_DESCRIPTOR GD_USER_PLOT;
typedef GOTH_DESCRIPTOR GD_JOHNWA;
typedef GOTH_DESCRIPTOR GD_BCK;
typedef GOTH_DESCRIPTOR GD_BLOCK_LIST;
typedef GOTH_DESCRIPTOR GD_PBIDX;
typedef GOTH_DESCRIPTOR GD_BILL;
typedef GOTH_DESCRIPTOR GD_CATCHMENT;
typedef GOTH_DESCRIPTOR GD_DANIEL;
typedef GOTH_DESCRIPTOR GD_SYLVAIN;
typedef GOTH_DESCRIPTOR GD_REPIN_OPTION;
typedef GOTH_DESCRIPTOR GD_AUDIT;
typedef GOTH_DESCRIPTOR GD_SCALE;
typedef GOTH_DESCRIPTOR GD_SALES_MODEL;
typedef GOTH_DESCRIPTOR GD_RDB_ITERATOR;
typedef GOTH_DESCRIPTOR GD_METACLASS;
typedef GOTH_DESCRIPTOR GD_AFM;
typedef GOTH_DESCRIPTOR GD_RASLINE;
typedef GOTH_DESCRIPTOR GD_GATE;
typedef	GOTH_DESCRIPTOR	GD_DIOX;
typedef	GOTH_DESCRIPTOR	GD_CLASSGROUP;
typedef	GOTH_DESCRIPTOR	GD_SORT;
typedef	GOTH_DESCRIPTOR	GD_CLUSTERGROUP;

/* typedef GOTH_DESCRIPTOR GD_ENDMARKER - plainly not needed! */

#endif /* _DDT_ENUM */









