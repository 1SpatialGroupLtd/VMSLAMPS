/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-05-16 12:21:42.000000000 +0100
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
/************************************************************************//* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*//* Author    TJ Ibbs, 16 May 1988       				*//*									*//*		        R E A D S T R . H				*//*									*//* This header file is a C version of the Fortran include file		*//* READSTR.PAR. It defines values for passing to the LSLLIB routine	*//* READSTR().								*//************************************************************************/ /************************************************************************/ /* Define termination condition values for READSTR, etc			*//*									*//*	ON_CMD		terminate as for commands - on any		*//*			character that is not alphabetic or '_'		*//*									*//*	ON_CHAR		terminate on the character TERM_CHAR		*//*									*//*	ON_CHAR2	as for ON_CH, but the sequence			*//*									*//*				TERM_CHAR TERM_CHAR			*//*									*//*			inserts TERM_CHAR into STRING			*//*									*//*	ON_SPACE	terminate on space or tab (as well as on	*//*			TERM_CHAR, if it is non-zero)			*//*									*//*	ON_EOL		terminate at end of line only			*//*									*//************************************************************************/ #define  ON_CMD		1#define  ON_CHAR	2#define  ON_CHAR2	3#define  ON_SPACE	4#define  ON_EOL		5