$	set noon				! ignore $status settings
$	on control_y then exit 			! <CTRL/Y> is fatal
$!
$! ****************************************************************************
$! STANDARD_RNO - this command file is to runoff a Laser-Scan standard
$!		  document.
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 6 May 1987 sqq
$!
$! ****************************************************************************
$! Modification	 8-Mar-1988	TJ Ibbs
$!	Change the documentation for the .SPEC file to reflect the changes
$!	in STANDARD_RNO_SUB.COM
$! ****************************************************************************
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$	wsb
$	ws "			    STANDARD_RNO"
$	wsb
$	ws "    Laser-Scan standard runoff procedure (v1.4, 8-March-1988)"
$	wsb
$!
$! check whether they are asking for help
$!
$	if P1.nes."?" then goto no_help_required
$	   gosub help_user
$	   exit
$!
$no_help_required:
$! ----------------------------------------------------------------------------
$! define our standard abbreviations
$!
$	TRUE     = 1
$	FALSE	 = 0
$!
$! return values (for $status) from subroutines, etc
$! (note that HAD_EOF and HAD_CTRL are also 'failures')
$!
$	SUCCESS	 = %x10000001		! routine succeeded
$	FAILURE	 = %x10000000		! routine failed
$	HAD_EOF  = %x10000002		! user replied <CTRL/Z> to a question
$	HAD_CTRL = %x10000004		! user interrupted with a <CTRL/Y>
$!
$! and printers that we support
$!
$	DOC$LQprinter   = "LETTER QUALITY PRINTER"
$	DOC$Lineprinter = "LINE PRINTER"
$	DOC$Terminal    = "TERMINAL"
$	DOC$Noprinter   = "NOTHING TO PRINT"
$	DOC$LN03printer = "LN03 PRINTER"
$!
$!
$! and a question length
$!
$	a$len = 40
$!
$! we also have some global symbols that we use
$!
$	on control_y then continue
$	   DOC$RESULT  == 0			! procedure return
$	   DOC$PRINTER == DOC$Noprinter		! where to print to
$	   DOC$WIDTH   == 80			! 80 character lines
$	   DOC$SCREEN  == FALSE			! mangled screen?
$	   DOC$SMOOTH  == TRUE			! TYPE smoothly
$	on control_y then goto final_exit
$!
$! ............................................................................
$! check whether we have a document name
$!
$	DOC$original := 'P1		! upper-case it
$!
$	if DOC$original.nes."" then goto got_document_name
$	   call ASKRNO 'a$len' "Document to run off:"
$	   if .not.$status then goto final_exit
$	   DOC$original := 'DOC$result
$!
$got_document_name:
$!
$! check that they have specified only the document name - nothing else
$!
$	t$doc = f$parse(DOC$original,,,"NAME")
$ 	if t$doc.eqs.DOC$original then goto the_name_is_OK
$	   ws "%RNO-E-FILENAME," + -
	      " only specify the NAME part of the file to be runoff"
$	   ws "-RNO-I-SPECIFY," + -
	      " in this case that would be ''t$doc', instead of ''DOC$original'"
$	   goto final_exit
$!
$the_name_is_OK:
$! ............................................................................
$! so we are ready to call the command file
$!
$	CtrlZ = "exit STANDARD_RNO"
$	CtrlC = "exit STANDARD_RNO"
$!
$	@lsl$doc_command:standard_rno_sub
$!
$! ............................................................................
$final_exit:
$	on control_y then continue
$	if "''DOC$RESULT'".eqs."" then goto no_globals_defined
$	   delete/symbol/global  DOC$RESULT
$	   delete/symbol/global  DOC$PRINTER
$	   delete/symbol/global  DOC$WIDTH
$	   delete/symbol/global  DOC$SCREEN
$	   delete/symbol/global  DOC$SMOOTH
$no_globals_defined:
$	exit

$! =========================================================================
$! HELP_USER
$! write out some help information for the user
$! -------------------------------------------------------------------------
$help_user:
$	set noon
$  	on control_y then goto final_exit
$!
$  	type sys$input:

This command file is designed for use in running off Laser-Scan documentation
in a standard manner. It is primarily aimed at the production of user guides
and reference manuals - chapter oriented documents, with a standard structure
and layout.

For example .SPEC files, see LSL$DOC_ROOT:[LSLMAINT.LSLLIB]LSLLIB.SPEC
			 and LSL$DOC_ROOT:[CONVERT.GUIDE]CONVERT.SPEC

This procedure provides two main options:

	(1) to produce a full version of the document, called 'document'.MEM
	    (where 'document' is the name of the document).

	(2) to produce a subset of the document, called PART_OF_'document'.MEM

Alternatively, .LNI files are produced if output is to be to the LN03 printer.

===============================================================================
It is assumed that the user has defined the following files:

'document'.SPEC

	This file contains commands which define how the document is to
	be prepared.

TITLE_PAGE.RNO

	This is only used if the AUTO_TITLE command is not used in the SPEC
	file. If required, the file should be the actual title page for the
	document.

CHANGES.RNO, PREFACE.RNO

	If a changes section or a preface is wanted, then the relevant
	runoff files must be supplied.

'chapter'.RNO

	There should be one runoff file for each chapter. The first chapter
	should always be called INTRODUCTION. In most standard documents, the
	file should not include a .CHAPTER command, as one will be generated
	automatically.

	See the SPEC file commands AUTO_NAME_CHAPTER and PREFIX_CHAPTER

'appendix'.RNO

	For each appendix (if any) there should be a runoff file. Note that
	the same comments apply for appendices as for chapters (see above).

The following files are generated by the procedure itself:

'document'.RNO or PART_OF_'document'.RNO

	This is the `top-level' runoff file, which uses .REQUIRE to include all
	the selected parts of the document. It should be treated as a temporary
	file, since STANDARD_RNO will create a new `top-level' file each time
	it is run.

'document'.RNT, 'document'.RNX

	These are used to generate the contents and index for the document
	(if they are wanted).

================================================================================
			Specification file commands

The following is a list of the commands that may be given in the specification
file. Those commands which would be expected in the specification file for a
normal standard document are marked with an asterisk (*). Note that blank lines
will be ignored, and comments are ignored, where a comment is preceded by a "!"
================================================================================

*    AUTO_TITLE
  NO_AUTO_TITLE

	If automatic titles are selected, then

		1) the title page of the document is generated automatically,
		   without reference to a TITLE_PAGE.RNO, from the various
		   title page commands detailed below

		2) if AUTO_NAME_CHAPTER is selected, then the titles for the
		   tops of each page will be automatically set to be of the
		   form
			`short_title' (`issue'): `chapter-name'

	This mode is intended for generating documents to satisfy military
	style requirements, where every page must be clearly identified. It
	should only be used in a document using AUTO_NAME_CHAPTER, FLAG_PAGES
	and CHANGES.

	===================== AUTO_TITLE commands =====================

* TITLE  text

	This command is used in an AUTO_TITLE environment to indicate the
	title of the document. Several TITLE commands may be used, for
	instance
			TITLE	LSLLIB
			TITLE	Technical_ Reference_ Manual

  VOLUMES  how-many

	If this command is included, then it causes `how-many' title pages
	to be generated (all at the start of the document!).

	If AUTO_TITLE has been selected, then these pages will be identical,
	except that they will have the text "Volume I", "Volume II", etc,
	centred below the TITLE lines.

	If AUTO_TITLE has not been selected, then the files TITLE_PAGE1.RNO,
	TITLE_PAGE2.RNO, etc, will be .REQUIRED

* DATE  date

	This command is used in an AUTO_TITLE environment to indicate the
	date on which the document was last edited.

* AUTHOR  name(s)

	This command is used in an AUTO_TITLE environment to indicate who
	last edited the document.

* SHORT_TITLE  short-title

	This command is used in an AUTO_TITLE environment to indicate the
	short form of the document's title. This is used at the bottom of
	the title page (for D.O. cross referencing) and in the automatically
	generated document titles.

* ISSUE  number

	This command is used in an AUTO_TITLE environment to indicate the
	document's issue number. This is used at the bottom of the title
	page (for D.O. cross referencing) and in the automatically generated
	document titles.

* CATEGORY  category-name

	This command is used in an AUTO_TITLE environment to indicate what
	category (eg, Technical, User) this document belongs in, for D.O.
	purposes.

   NOTE  text

	Occasionally, it is necessary to insert some extra text on the title
	page. In an AUTO_TITLE environment, this may be done by using the NOTE
	command. Like the TITLE command, multiple lines may be inserted by
	repeated use of the command. The text of the note (with leafing and
	trailing spaces and tabs removed) is inserted into the file as it is
	presented. It is placed above the identification lines at the bottom
	of the title page, and within a .KEEP .NOFILL environment - that is,
	line breaks and internal spaces will be retained. See the LSLLIB SPEC
	file for an example.

	===================== File inclusion commands =====================

* CHANGES

	If this is specified, then CHANGES.RNO will be included.

* PREFACE

	If this is specified, then PREFACE.RNO will be included.

* CONTENTS

	If this is specified, then the contents of the document will be
	included at its start.

* INDEX

	If this is specified, then the index for the document will be
	included at its end.

* SPR_FORMS

     	If this is specified, then three SPR forms (from SPR_FORM.RNO)
	will be included at the end of the document.

	===================== Chapter/Appendix commands =====================

*    AUTO_NAME_CHAPTER		(default)
  NO_AUTO_NAME_CHAPTER

	If automatic naming of chapters is enabled, then the command file
	will generate an appropriate .CHAPTER or .APPENDIX command for each
	chapter or appendix. The chapter and appendix files must therefore
	not include a .CHAPTER or .APPENDIX command.

	If automatic naming of chapters is not enabled, each file must
	include an appropriate .CHAPTER or .APPENDIX command.

	See also CHAPTER, APPENDIX, PREFIX_CHAPTER, FLAG_PAGES, AUTO_TITLE

* PREFIX_CHAPTER  prefix

	If this is specified, and AUTO_NAME_CHAPTER has been specificed,
	then the text used to name each chapter will be

		'prefix'  'chapter-name'

	If AUTO_NAME_CHAPTER has been specified, but AUTO_TITLE has not,
	then the prefix will not be used for chapter 1, the introduction.
	This is because the first section of the introduction is also
	normally called INTRODUCTION, and it looks strange to have the
	title and subtitle the same.

*    FLAG_PAGES
  NO_FLAG_PAGES

	If AUTO_NAME_CHAPTER is specified, then FLAG_PAGES will cause the
	.CHAPTER or .APPENDIX command to be output on a separate page. That
	is, the first page of the chapter or appendix is a flag page which
	can either be retained as a `cover page' or discarded.

     SECTION_NUMBERS
* NO_SECTION_NUMBERS		(default)

	If section numbers are requested, then each section header will have
	a section number attached, and the section numbers will also be present
	in the contents. The default blank lines above and below the section
	header (.HL) commands will also be output.

	If section numbers are not requested, then they will not be present in
	the document. Also, an appropriate .STYLE HEADERS command will be used
	to set the `DEC-like' style of headers that we use for our standard
	documentation - the blank lines before each section header will be
	suppressed, etc.

* CHAPTER  file-name  [chapter-name]

	The chapters to be included in the document must be specified,
	in the order that they are wanted, using the CHAPTER command.

	If AUTO_NAME_CHAPTER is specified, then `chapter-name' is the
	name that will be used for the chapter. If it is ommitted, then
	`file-name' will be used instead.

	Note that the first chapter must always have file-name INTRODUCTION.

* APPENDIX  file-name  [appendix-name]

	If appendices are required, then they must be specified in the
	order that they are wanted, using the APPENDIX command. The
	`file-name' is the name of the appendix's runoff file.

	Note that previous versions of STANDARD_RNO required all appendices
	to include a .APPENDIX command. With this version, appendices are
	treated exactly like chapters (except that PREFIX_CHAPTER is not
	relevant).
$!
$	return

$! =========================================================================
$! ASKRNO
$! Called to ask the user a question
$!
$!	P1		the length to pad the question to
$!	P2		the question to ask - pad it with spaces
$!	DOC$RESULT	the answer to the question
$! -------------------------------------------------------------------------
$ASKRNO:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! make all questions be of a standard length
$!
$	question[0,'P1'] := "''P2'"
$!
$! and ask the question
$!
$ask_again:
$	read/end_of_file=eof/error=ask_error -
	    /prompt="''question'" -
	    sys$command  answ
$!
$! if the result was a question mark, then ask the question again
$!
$	if answ.eqs."?" then goto ask_again
$!
$! otherwise return it
$!
$	DOC$RESULT == answ
$	exit 'SUCCESS'
$!
$! .............................................................................
$eof:	exit 'HAD_EOF'
$!
$ask_error:
$	ws "%RNO-E-ASKERR, error in reading response"
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! ASKRNO
