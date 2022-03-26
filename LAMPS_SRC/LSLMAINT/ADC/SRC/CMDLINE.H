/************************************************************************/
/*									*/
/* Copyright © Laser-Scan Ltd, Cambridge CB4 4FY, England		*/
/* Author    JM Cadogan   4-Oct-1993					*/
/*									*/
/*		     C M D L I N E . H					*/
/*									*/
/* Header file for command line qualifiers for ADC			*/
/*									*/
/************************************************************************/ 

extern BOOLEAN  had_log;	/* TRUE if we log file open/close, etc	      */
extern BOOLEAN	had_debug;	/* TRUE if we should output debug source code */
extern BOOLEAN	had_print;	/* TRUE if we should print output source      */
extern BOOLEAN	had_append;	/* TRUE if we should append to existing file  */
extern BOOLEAN	had_thread;	/* TRUE if we should process directive lines  */
extern BOOLEAN	had_ln;		/* TRUE if we should number output lines      */
extern BOOLEAN	had_cd;		/* TRUE if dir for commons/parameters given   */
extern BOOLEAN	had_comments;	/* TRUE if we should output comments	      */
extern BOOLEAN	had_ll;		/* TRUE if line length set		      */
extern BOOLEAN	had_in;		/* TRUE if we should reinit. truth file rec   */
extern BOOLEAN	had_tr;		/* TRUE if given truth file spec	      */
extern BOOLEAN	outer_level_only; /* TRUE if comments in outer level only     */
extern int	line_length;	/* value of line length given 		      */
