/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1987-05-27 15:39:26.000000000 +0100
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
/************************************************************************//* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*//* Author    TJ Ibbs, 26 May 1987     					*//*									*//*		   F I L E N A M E . H					*//*									*//* this header file is a C version of the LSLLIB 'common block' file	*//* FILENAME.CMN, which is used by the file-spec parsing parts of the	*//* library								*//************************************************************************/ /************************************************************************/ /* In order, for each common block, the FORTRAN definitions are:	*//*									*//* for /LSL_FNAM_STR/							*//*	CHARACTER*(C_NOD_SIZ)	STR_NOD		! node name		*//*	CHARACTER*(C_DEV_SIZ)	STR_DEV		! device name		*//*	CHARACTER*(C_DIR_SIZ)	STR_DIR		! directory name	*//*	CHARACTER*(C_NAM_SIZ)	STR_NAM		! name string		*//*	CHARACTER*(C_EXT_SIZ)	STR_EXT		! extension		*//*	CHARACTER*(C_VER_SIZ)	STR_VER		! version number	*//*									*//* for /LSL_FNAM_LOG/							*//*	LOGICAL*4	HAD_NOD						*//*	LOGICAL*4	HAD_DEV						*//*	LOGICAL*4	HAD_DIR						*//*	LOGICAL*4	HAD_NAM						*//*	LOGICAL*4	HAD_EXT						*//*	LOGICAL*4	HAD_VER						*//*									*//* for /LSL_FNAM_LEN/							*//*	INTEGER*4	LEN_NOD						*//*	INTEGER*4	LEN_DEV						*//*	INTEGER*4	LEN_DIR						*//*	INTEGER*4	LEN_NAM						*//*	INTEGER*4	LEN_EXT						*//*	INTEGER*4	LEN_VER						*//*									*//************************************************************************/ #define	C_NOD_SIZ	  6#define	C_DEV_SIZ	 20#define	C_DIR_SIZ	100#define	C_NAM_SIZ	 39#define	C_EXT_SIZ	 39#define	C_VER_SIZ	  6#define	C_MAX_SIZ	C_NOD_SIZ + C_DEV_SIZ + C_DIR_SIZ + C_NAM_SIZ + \			C_EXT_SIZ + C_VER_SIZ + 7extern struct	{	char	STR_NOD[C_NOD_SIZ];	char	STR_DEV[C_DEV_SIZ];	char	STR_DIR[C_DIR_SIZ];	char	STR_NAM[C_NAM_SIZ];	char	STR_EXT[C_EXT_SIZ];	char	STR_VER[C_VER_SIZ];	} LSL_FNAM_STR;extern struct	{   	BOOLEAN		HAD_NOD;	BOOLEAN		HAD_DEV;	BOOLEAN		HAD_DIR;	BOOLEAN		HAD_NAM;	BOOLEAN		HAD_EXT;	BOOLEAN		HAD_VER;	} LSL_FNAM_LOG;extern struct	{	INT_4		LEN_NOD;	INT_4		LEN_DEV;	INT_4		LEN_DIR;	INT_4		LEN_NAM;	INT_4		LEN_EXT;	INT_4		LEN_VER;	} LSL_FNAM_LEN;