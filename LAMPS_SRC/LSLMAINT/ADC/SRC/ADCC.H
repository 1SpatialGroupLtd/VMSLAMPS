/* Header file for ADCC - common blocks program */
/* special function names */
# define F_IF	  1	/* IF */
# define F_UNL	  2	/* UNLESS */
# define F_END	  3	/* ENDC */
# define F_COM	  4	/* COMMON */
# define F_IFF	  5	/* IFF */
# define F_IFT	  6	/* need I say? */
# define F_FTF	  7	/* IFTF */
# define F_PAR	  8	/* PARAMETER */
# define F_DEF	  9	/* DEFPAR */
# define F_SET	 10	/* SETVAR */
# define F_INC	 11	/* INCLUDE */
# define F_DAT	 12	/* DATA */
# define F_ID	 13	/* IDENT */
# define F_MOD	 14	/* MODULE/END */

/* Logical unit numbers */
# define ADC_LUN_1   1
# define ADC_LUN_2   2
# define ADC_LUN_3   3

/* filename and record length limits */
# define MAXVARS  100
# define MAXFILES 50
# define MAXFILENAM  256
# define MAXLINELEN  256
# define MAXMODLEN  63
# define MAXIDLEN  10
# define LINE_LEN_DFLT  73

/* Funtions */
void copystream();

