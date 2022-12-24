/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-06-19 14:08:16.000000000 +0100
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
/************************************************************************/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    J Barber   18-May-1989					*/
/*									*/
/*		     F U N C T I O N S . H				*/
/*									*/
/* Header file for function definitions for I2GDB			*/
/*									*/
/************************************************************************/ 

/* Function to read the command line */

BOOLEAN read_cmdline(
		    char IFF_file [C_MAX_SIZ+1],
		    char GDB_file [C_MAX_SIZ+1],
		    char FRT_file [C_MAX_SIZ+1],
		    char PAR_file [C_MAX_SIZ+1]);

int process_parameter_file( FILE *f );
float area();
int seed_point();


