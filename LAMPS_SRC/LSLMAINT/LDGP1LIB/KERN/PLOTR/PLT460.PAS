[INHERIT ('Inherit_File',
          'SYS$LIBRARY:STARLET.PEN')]
MODULE PLT460 ;

FUNCTION  Lib$Wait
	( %REF		Delay: 		REAL ): INTEGER; 	EXTERNAL ;

PROCEDURE Lib$Signal
	( %IMMED	Status: 	INTEGER ) ;		EXTERNAL ;

{ PLT460.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE RAWM_Read_And_Write_Metafiles ;
(**********************************************************************)
VAR
  I:			INTEGER ;
  String:		String_40 ;
  Number_Of_Characters:	INTEGER ;
  Return:		BOOLEAN ;
  Arrow_Key:		CHAR ;
  Max_Length:		INTEGER ;
  File_Exists:		BOOLEAN ;
  File_Message:		String_40 ;
  Blank_String:		String_30 ;
  File_Name:		String_File_Name_Length ;


(**********************************************************************)
PROCEDURE Write_Menu_Page ;
(**********************************************************************)
BEGIN

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 4                  METAFILE INTERFACE' ) ;
  WRITELN ;

  CURPOS_Cursor_Position ( 10, 1 ) ;
  WRITELN ( ' 1.                  Metafile to Read = ' ) ;
  WRITELN ( Blank_40 ) ;

  CURPOS_Cursor_Position ( 13, 1 ) ;
  WRITELN ( ' 2.                 Metafile to Write = ' ) ;
  WRITELN ( Blank_40 ) ;

END ;




BEGIN 

  Write_Menu_Page ;

  REPEAT

    CURPOS_Cursor_Position (22,0) ;
    WRITELN ( '     ANY CHANGES? IF SO,  TYPE LINE NUMBER, <RETURN> ' ) ;
    WRITELN ( '                  IF NOT, PRESS <RETURN>     ' ) ;
    CURPOS_Cursor_Position (23,42) ;

    Max_Length := 1 ;
    Read_Key_Board ( String, Number_Of_Characters, Scape,
                     Return, Arrow_Key, Max_Length ) ;

    CASE String[1] OF

      '?': BEGIN
             RADH_Read_And_Display_Help ( Help_Text_File, 3 ) ;
             Write_Menu_Page ;
           END ;


      '1': BEGIN
             Blank_String := Blank_30 ;
             SCAWBS_Set_Cursor_And_Write_Black_String
              ( Blank_String, 10, 41 ) ;
              
             Max_Length := File_Name_Length ;
             Read_Key_Board ( String, Number_Of_Characters, Scape,
                              Return, Arrow_Key, Max_Length ) ;
             Return := FALSE ;
  
             FOR I := 1 TO File_Name_Length DO
               File_Name [I] := String [I] ;
             CFE_Check_File_Exists ( File_Name, File_Exists ) ;
             IF File_Exists THEN
               BEGIN
                 RM_Read_Metafile ( String ) ;
                 CURPOS_Cursor_Position ( 10, 41 ) ;
                 ERALIN_Erase_In_Line ( 'R' ) ;
               END
             ELSE
               BEGIN
                 File_Message := 'File does not exist' ;
                 CURPOS_Cursor_Position ( 11, 10 ) ;
                 BELLRI_Bell_Ring ;
                 WRITELN ( File_Message ) ;
                 CURPOS_Cursor_Position ( 10, 41 ) ;
                 ERALIN_Erase_In_Line ( 'R' ) ;
                 TD_Time_Delay ( 0.5 ) ;
                 Write_Menu_Page ;
               END ;
           END ;


      '2': BEGIN
             Blank_String := Blank_30 ;
             SCAWBS_Set_Cursor_And_Write_Black_String
              ( Blank_String, 13, 41) ;
              
             Max_Length := File_Name_Length ;
             Read_Key_Board ( String, Number_Of_Characters, Scape,
                              Return, Arrow_Key, Max_Length ) ;
             Return := FALSE ;
  
             FOR I := 1 TO File_Name_Length DO
               File_Name [I] := String [I] ;
             CFE_Check_File_Exists ( File_Name, File_Exists ) ;
             IF File_Exists THEN
               BEGIN
                 File_Message := 'File already exists - not overwritten' ;
                 CURPOS_Cursor_Position ( 14, 10 ) ;
                 BELLRI_Bell_Ring ;
                 WRITELN ( File_Message ) ;
                 CURPOS_Cursor_Position ( 13, 41 ) ;
                 ERALIN_Erase_In_Line ( 'R' ) ;
                 TD_Time_Delay ( 0.5 ) ;
                 Write_Menu_Page ;
               END
             ELSE
               BEGIN
                 WM_Write_Metafile ( String ) ;
                 CURPOS_Cursor_Position ( 13, 41 ) ;
                 ERALIN_Erase_In_Line ( 'R' ) ;
               END ;

           END ;

      OTHERWISE  IF NOT ( Return OR ( Scape AND ( Arrow_Key = ' ' ))) THEN
                   BEGIN
                     BELLRI_Bell_Ring ;
                     WRITELN ;
                   END ;

    END ;

  UNTIL ( Return ) OR ( Scape AND ( Arrow_Key = ' ' ) ) ;

END ;
END.
