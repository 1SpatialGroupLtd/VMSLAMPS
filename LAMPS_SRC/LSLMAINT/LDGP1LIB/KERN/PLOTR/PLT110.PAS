[INHERIT ('Inherit_File')]
MODULE PLT110 ;

{ PLT110.PAS <> }

(****************************************************************************)
 [GLOBAL] PROCEDURE DOP_Define_Overall_Parameters  ;
(****************************************************************************)
CONST
    No_Input_File          = '        No such file exists for input !!' ;
    Insufficient_Values    = '       ** INSUFFICIENT VALUES **        ' ;

VAR
    Black_String           : String_30 ;
    Message,
    Input_Message_3,
    Input_Message_4,
    SString                 : String_40 ;
    Number_Of_Lines,
    Line_Number, I,
    Number_Of_Characters   : INTEGER ;
    Value                  : DOUBLE ;
    Finished,
    Error,
    Return                 : BOOLEAN ;
    Library_Record:	String_128 ;

    In_Read                : TEXT ;
    Check_at_the_Beginning : BOOLEAN ;

(**********************************************************************)
PROCEDURE WMPCRT_Write_Menu_Page_CRT ;
(**********************************************************************)

BEGIN (* WMPCRT_Write_Menu_Page_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;

  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 1                  OVERALL PARAMETERS' ) ;
  WRITELN ;

  WRITELN ( ' 1.     GROUND UNIT METRIC OR ENGLISH = ', Linear_Units:7 ) ;
  WRITELN ;
  WRITELN ( ' 2.       ROTATION IN GONS OR DEGREES = ', Rotation_Units:7 ) ;
  WRITELN ;
  WRITELN ( ' 3.                 LIBRARY FILE NAME = ', Library_File_Name ) ;
  WRITELN ( Input_Message_3 ) ;
  WRITELN ;
  WRITELN ( ' 4.                   INPUT FILE NAME = ', Input_File_Name ) ;
  WRITELN ( Input_Message_4 ) ;
  WRITELN ;
  WRITELN ( ' 5.               FILE FORMAT (K/M/S) = ', File_Format ) ;
  WRITELN ;
  WRITELN ( ' 6.      SELECTED LEVELS/LAYERS (Y/N) = ', Selected_Layers ) ;

END ; (* WMPCRT_Write_Menu_Page_CRT *)


(********************************************************************)
PROCEDURE WM_Write_Message ;
(********************************************************************)
BEGIN

  CURPOS_Cursor_Position (20,0) ;
  DBWIDT_Double_Width ( 0 ) ;
  WRITELN ( Message ) ;
  WRITELN ;
  WRITELN ( '     ANY CHANGES? IF SO,  TYPE LINE NUMBER, <RETURN>, NEW VALUE, <RETURN>     ' ) ;
  WRITE   ( '                  IF NOT, PRESS <RETURN>  ' ) ;

  ERALIN_Erase_In_Line  ('R') ;

END ;  (* WCL_Write_Comand_Line *)


(**********************************************************************)
PROCEDURE PMP_Print_Menu_Page ;
(**********************************************************************)

VAR
     I,
     Title_Length,
     Cursor_Position     :   INTEGER ;
     Out_Write           :   TEXT    ;
     Init_size           :   INTEGER ;

BEGIN (* PMP_Print_Menu_Page *)

   OPEN ( Out_Write,
          FILE_NAME := '$PRINTER' ) ;

   REWRITE ( Out_Write ) ;

   PKT_Print_Kern_Title ( Ten_digit_Number, Title );

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 1                  OVERALL PARAMETERS' ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 1.     GROUND UNIT METRIC OR ENGLISH = ', Linear_Units:7 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 2.       ROTATION IN GONS OR DEGREES = ', Rotation_Units:7 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 3.                 LIBRARY FILE NAME = ', Library_File_Name ) ;
   WRITELN (Out_Write, Input_Message_3 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 4.                   INPUT FILE NAME = ', Input_File_Name ) ;
   WRITELN (Out_Write, Input_Message_4 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 5.               FILE FORMAT (K/M/S) = ', File_Format ) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 6.      SELECTED LEVELS/LAYERS (Y/N) = ', Selected_Layers ) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN (' ':20, Message ) ;

   CLOSE (Out_Write) ;

END ;  (* PMP_Print_Menu_Page *)


(********************************************************************)
PROCEDURE SCRI_Set_Cursor_Read_Input ;
(********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* SCRI_Set_Cursor_Read_Input *)

    CASE ( Line_Number ) OF

     1 : BEGIN
         END ;

     2 : BEGIN
         END ;

     3 : BEGIN
            FOR I := 1 TO File_Name_Length DO
                Black_String [I] := Library_File_Name [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 11, 41 ) ;
            Read_Key_Board ( SString,
                             Number_Of_Characters,
                             Scape,
                             Return,
                             Arrow_Key,
                             File_Name_Length ) ;
          END ;

      4 : BEGIN
               FOR I := 1 TO File_Name_Length DO
                   Black_String [I] := Input_File_Name [I] ;
               SCAWBS_Set_Cursor_And_Write_Black_String
                      ( Black_String, 14, 41 ) ;
               Read_Key_Board ( SString,
                                Number_Of_Characters,
                                Scape,
                                Return,
                                Arrow_Key,
                                File_Name_Length ) ;
            END ;

      5 : BEGIN
               FOR I := 1 TO 14 DO
                   Black_String [I] := File_Format [I] ;
               SCAWBS_Set_Cursor_And_Write_Black_String
                      ( Black_String, 17, 41 ) ;
               Read_Key_Board ( SString,
                                Number_Of_Characters,
                                Scape,
                                Return,
                                Arrow_Key,
                                File_Name_Length ) ;
            END ;

     6 : BEGIN
         END ;

    OTHERWISE ; { do nothing }

    END ; { Of Case }

END ; (* SCRI_Set_Cursor_Read_Input *)

(********************************************************************)
PROCEDURE CGFN_Check_Good_File_Name ;
(********************************************************************)
VAR
  Valid_Name   : BOOLEAN ;
  Check_String : String_File_name_Length ;	{ See global }
  I            : INTEGER ;

BEGIN

  FOR I := 1 TO File_Name_Length DO Check_String[I] := SString[I];
  CFN_Check_File_Name ( Check_String, Valid_Name );
  Error := NOT Valid_Name ;
  FOR I := 1 TO File_Name_Length DO SString[I] := Check_String[I];

END ; (* PROCEDURE CGFN_Check_Good_File_Name *)


(********************************************************************)
PROCEDURE TP_Transfer_Parameters ;
(********************************************************************)
VAR
   String_22 : PACKED ARRAY [ 1..22 ] OF CHAR ;

BEGIN

     CURPOS_Cursor_Position (22,0) ;
     ERALIN_Erase_In_Line  ('R') ;
     SELGRA_Select_Graphics ( 'R' ) ;
     CURPOS_Cursor_Position (23,0) ;
WRITE ( 'Do you want to transfer the orientation from the input file (Y/N) ');
     ERALIN_Erase_In_Line  ('R') ;

     Read_Key_Board (SString,Number_Of_Characters,Scape,Return,Arrow_Key,1) ;
     SELGRA_Select_Graphics ( 'O' ) ;

     IF   ( SString [1] = 'Y' )
       OR ( SString [1] = 'y' )
       THEN
           REPEAT
                 READ ( In_Read, String_22 ) ;

                 IF String_22 = 'CHANGE TO MAP SCALE   '
                    THEN READLN ( In_Read, Plot_X_Scale, Plot_Y_Scale ) ;

                 IF String_22 = 'CHANGE TO MAP ROTATION'
                    THEN BEGIN
                              READLN ( In_Read, Plot_Rotation ) ;
                           END ;

                 IF String_22 = 'CHANGE TO MAP INDEX   '
                    THEN BEGIN
                              READLN ( In_Read ) ;
                              READLN ( In_Read, Plot_X_Index, Plot_Y_Index ) ;
                           END ;

                 { get next line }
                 IF    ( String_22 = 'CHANGE TO MAP SCALE   ' )
                    OR ( String_22 = 'CHANGE TO MAP ROTATION' )
                    OR ( String_22 = 'CHANGE TO MAP INDEX   ' )
                    THEN
                    ELSE READLN ( In_Read ) ;

      UNTIL    ( String_22 = 'START                 ' )
            OR ( String_22 = 'QUIT                  ' )
            OR EOF ( In_Read ) ;

     WM_Write_Message ;

END ;  (* TP_Transfer_Parameters *)


(********************************************************************)
PROCEDURE CASI_Check_And_Store_Input ;
(********************************************************************)

VAR
    Len, I, K   : INTEGER ;

BEGIN (* CASI_Check_And_Store_Input *)

    CASE ( Line_Number ) OF

      1 : IF Linear_Units = 'METRIC '
             THEN Linear_Units := 'ENGLISH'
             ELSE Linear_Units := 'METRIC ' ;

      2 : IF Rotation_Units = 'GONS   '
             THEN Rotation_Units := 'DEGREES'
             ELSE Rotation_Units := 'GONS   ' ;

      3 : BEGIN
                Input_Message_3 := Blank_40 ;
                IF SString = Blank_40
                   THEN BEGIN
                        Input_Message_3 := No_Input_File ;
                        Error := TRUE ;
                        Library_File_Name := Blank_30 ;
                        END
                   ELSE CGFN_Check_Good_File_Name ;

               IF NOT Error
                 THEN BEGIN
                           FOR I := 1 TO File_Name_Length DO
                               Library_File_Name [I]  := SString [I] ;
                           { close old file }
{                           CLOSE (Library_Pointer) ;}

                           OPEN ( Library_Pointer,
                                  FILE_NAME := Library_File_Name,
                                  RECORD_TYPE := FIXED,
                                  RECORD_LENGTH := 128,
                                  HISTORY := OLD,
                                  ACCESS_METHOD := DIRECT,
                                  ERROR := CONTINUE ) ;

                          RESET ( Library_Pointer, ERROR := CONTINUE ) ;

                          IF EOF ( Library_Pointer ) THEN Len := -1
                          ELSE Len := 1 ;

                          IF Len > 0 THEN
                            BEGIN
                              { Find the number of records }
                              Library_Size := 0 ;
                              WHILE NOT EOF (Library_Pointer) DO
                                BEGIN
                                  READ ( Library_Pointer, Library_Record ) ;
                                  Library_Size := Library_Size + 1 ;
                                END ;
                              Library_Size := (( Library_Size + 1 ) DIV 2 ) -1 ;
                              CLOSE (Library_Pointer) ;
                            END
                          ELSE BEGIN
                                    Error := TRUE ;
                                    Input_Message_3 := No_Input_File ;
                               END ;
                      END ;
          END ;

      4 : BEGIN
                Input_Message_4 := Blank_40 ;
                IF SString = Blank_40
                   THEN BEGIN
                        Error := TRUE ;
                        Input_File_Name := Blank_30 ;
                        Input_Message_4 := No_Input_File ;
                        END
                   ELSE CGFN_Check_Good_File_Name ;

                 IF NOT Error
                    THEN BEGIN
                              FOR I := 1 TO File_Name_Length DO
                                  Input_File_Name [I]  := SString [I] ;

                              OPEN ( In_Read,
                                     FILE_NAME := Input_File_Name,
                                     HISTORY := OLD,
                                     ERROR := CONTINUE ) ;
                              RESET ( In_Read, ERROR := CONTINUE );
                              IF EOF ( In_Read ) THEN Len := -1
                              ELSE Len := 1 ;

                              IF Len = -1
                                 THEN Input_Message_4 := No_Input_File
                                 ELSE
                                   BEGIN
                                     IF NOT Check_at_the_Beginning
                                        THEN TP_Transfer_Parameters ;
                                     CLOSE ( In_Read ) ;
                                   END ;
                          END ;
            END ;

      5 : BEGIN
{****
Only kern cam is supported, so don't let it be changed
           IF (SString [1] = 'K') OR (SString [1] = 'k')
            THEN File_Format := 'KERN CAM      ' ;
           IF (SString [1] = 'M') OR (SString [1] = 'm')
            THEN File_Format := 'MULTIPLE POINT' ;
           IF (SString [1] = 'S') OR (SString [1] = 's')
            THEN File_Format := 'SINGLE POINT  ' ;
****}
           File_Format := 'KERN CAM      ' ;

          END ;

      6 : IF Selected_Layers = 'YES'
             THEN Selected_Layers := 'NO '
             ELSE Selected_Layers := 'YES' ;

    END ; { Of Case }

  IF (Error) THEN BELLRI_Bell_Ring ;

  IF    (Input_Message_3 = Blank_40)
    AND (Input_Message_4 = Blank_40)
   THEN Message := Blank_40
   ELSE Message := Insufficient_Values ;

END ; (* CASI_Check_And_Store_Input *)

(********************************************************************)
PROCEDURE CF_Check_Finished ;
(********************************************************************)

BEGIN (* CF_Check_Finished *)

  IF (Message = Blank_40) THEN Finished := TRUE
                          ELSE Finished := FALSE ;

END ; (* CF_Check_Finished *)


(********************************************************************)
PROCEDURE DNV_Display_New_Value ;
(********************************************************************)
BEGIN

    CASE ( Line_Number ) OF

      1 : BEGIN
               CURPOS_Cursor_Position (7, 41) ;
                ERALIN_Erase_In_Line  ('R') ;
                WRITELN ( Linear_Units:7 ) ;
            END ;

      2 : BEGIN
               CURPOS_Cursor_Position (9, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Rotation_Units:7 );
          END ;

      3 : BEGIN
               CURPOS_Cursor_Position (11, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Library_File_Name) ;
               CURPOS_Cursor_Position (12, 0) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Input_Message_3:40 ) ;
            END ;

      4 : BEGIN
               CURPOS_Cursor_Position (14, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Input_File_Name ) ;
               CURPOS_Cursor_Position ( 15, 0) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Input_Message_4:40 ) ;
          END ;

      5 : BEGIN
               CURPOS_Cursor_Position (17, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (File_Format) ;
          END ;

      6 : BEGIN
               CURPOS_Cursor_Position (19, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Selected_Layers ) ;
          END ;

    OTHERWISE ; { do nothing }

    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* DOP_Define_Overall_Parameters  *)

  SString         := Blank_40 ;
  Message         := Blank_40 ;
  Input_Message_3 := Blank_40 ;
  Input_Message_4 := Blank_40 ;
  Black_String    := Blank_30 ;
  Value           := 0.0 ;
  Return          := FALSE ;
  Finished        := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 6 ;

  Check_at_the_Beginning := TRUE ;

  { is library there ? }
  FOR I := 1 TO File_Name_Length DO SString [I] := Library_File_Name [I] ;
  Line_Number := 3 ;
  CASI_Check_And_Store_Input ;

  { is input file there ? }
  FOR I := 1 TO File_Name_Length DO SString [I] := Input_File_Name [I] ;
  Line_Number := 4 ;
  CASI_Check_And_Store_Input ;

  Check_at_the_Beginning := FALSE ;

  WMPCRT_Write_Menu_Page_CRT ;

  REPEAT

     WM_Write_Message ;
     CF_Check_Finished ;

     Read_Key_Board (SString,Number_Of_Characters,Scape,Return,Arrow_Key,1) ;

     Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
     Line_Number := TRUNC ( Value ) ;

     IF ( SString [1] = '?' )
      THEN BEGIN
              RADH_Read_And_Display_Help ( Help_Text_File, 2 ) ;
              WMPCRT_Write_Menu_Page_CRT ;
              WM_Write_Message ;
           END ;

     IF   ( SString [1] = 'P' )
       OR ( SString [1] = 'p' )
      THEN PMP_Print_Menu_Page ;

     IF ( Line_Number > 0 ) AND ( Line_Number <= Number_of_Lines )
      THEN BEGIN
           Error := FALSE ;
           SCRI_Set_Cursor_Read_Input ;
           IF NOT (Scape OR Return)
               THEN CASI_Check_And_Store_Input ;
           IF (Arrow_Key <> ' ') THEN Scape := FALSE ;
           DNV_Display_New_Value ;
           Return := FALSE ;
           END
      ELSE IF (Return) OR (Scape) OR (SString [1] IN ['p', 'P', '?'])
               THEN
               ELSE BELLRI_Bell_Ring ;

  UNTIL   (Scape AND (Arrow_Key = ' '))
       OR (Scape AND (Arrow_Key =   Up_Arrow_Key ) AND Finished)
       OR (Scape AND (Arrow_Key = Down_Arrow_Key ) AND Finished)
       OR (Return AND Finished) ;

  { compute Ro }
  IF Rotation_Units = 'GONS   '
       THEN BEGIN
                 Ro := 200.0 / Pi ;
                 Gons_or_Degrees := ' gons   ' ;
              END
       ELSE BEGIN
                 Ro := 180.0 / Pi ;
                 Gons_or_Degrees := ' degrees' ;
              END ;

  IF Linear_Units = 'METRIC '
     THEN BEGIN
               Meters_or_Feet := 'm ' ;
               MM_or_Inches   := 'mm' ;
            END
     ELSE BEGIN
               Meters_or_Feet := 'ft' ;
               MM_or_Inches   := 'in' ;
            END ;

END ; (* DOP_Define_Overall_Parameters  *)
END.
