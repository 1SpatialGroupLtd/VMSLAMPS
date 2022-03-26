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


