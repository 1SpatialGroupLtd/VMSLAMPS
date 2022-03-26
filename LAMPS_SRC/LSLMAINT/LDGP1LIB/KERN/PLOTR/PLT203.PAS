[INHERIT ('Inherit_File')]
MODULE PLT203 ;

{ PLT203.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE DMS_Define_Manuscript_Size ;
(****************************************************************************)
CONST
    Insufficient_Values    = '       ** INSUFFICIENT VALUES **        ' ;
VAR
    Black_String           : String_30 ;
    SString,
    Message                : String_40 ;
    Number_Of_Lines,
    Line_Number,
    Number_Of_Characters   : INTEGER ;
    Value                  : DOUBLE ;
    Finished,
    Error,
    Return                 : BOOLEAN ;



(**********************************************************************)
PROCEDURE WMPCRT_Write_Menu_Page_CRT ;
(**********************************************************************)

BEGIN (* WMPCRT_Write_Menu_Page_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 5                     MANUSCRIPT SIZE' ) ;
  WRITELN ;
  WRITELN ;
  WRITELN ;
  WRITELN ;

  WRITELN ( ' 1.              PLOT HORIZONTAL SIZE = ',
                                 Plot_Horizontal_Size:10:2, MM_or_Inches:3 ) ;
  WRITELN ;
  WRITELN ( ' 2.                PLOT VERTICAL SIZE = ',
                                 Plot_Vertical_Size:10:2, MM_or_Inches:3 ) ;

  CURPOS_Cursor_Position (22,0) ;
  WRITELN ( '     ANY CHANGES? IF SO,  TYPE LINE NUMBER, <RETURN>, NEW VALUE, <RETURN>     ' ) ;
  WRITE   ( '                  IF NOT, PRESS <RETURN>  ' ) ;

END ;  (* WMPCRT_Write_Menu_Page_CRT *)


(********************************************************************)
PROCEDURE WM_Write_Message ;
(********************************************************************)
BEGIN
     DBWIDT_Double_Width ( 20 ) ;
     WRITELN ( Message ) ;

     IF Message <> Blank_40
        THEN BELLRI_Bell_Ring ;

     CURPOS_Cursor_Position (23,43) ;
     ERALIN_Erase_In_Line  ('R') ;

END ;  (* WM_Write_Message *)


(**********************************************************************)
PROCEDURE PMP_Print_Menu_Page ;
(**********************************************************************)

VAR
     I,
     Title_Length,
     Cursor_Position     :   INTEGER ;
     Out_Write           :   TEXT    ;

BEGIN (* PMP_Print_Menu_Page *)

   OPEN ( Out_Write,
          FILE_NAME := '$PRINTER' ) ;

   REWRITE ( Out_Write ) ;

   PKT_Print_Kern_Title ( Ten_digit_Number, Title );

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 5                     MANUSCRIPT SIZE' ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 1.              PLOT HORIZONTAL SIZE = ',
                                 Plot_Horizontal_Size:10:2, MM_or_Inches:3 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 2.                PLOT VERTICAL SIZE = ',
                                 Plot_Vertical_Size:10:2, MM_or_Inches:3 ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' ':20, Message);

   CLOSE (Out_Write) ;

END ;  (* PMP_Print_Menu_Page *)


(********************************************************************)
PROCEDURE CF_Check_Finished ;
(********************************************************************)
BEGIN

     IF   ( Plot_Horizontal_Size = 0.0 )
       OR ( Plot_Vertical_Size = 0.0 )
      THEN BEGIN
           Message := Insufficient_Values ;
           Finished := FALSE ;
           END
      ELSE BEGIN
           Message := Blank_40 ;
           Finished := TRUE ;
           END ;

END ;

(********************************************************************)
PROCEDURE SCRI_Set_Cursor_Read_Input ;
(********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* SCRI_Set_Cursor_Read_Input *)

    CASE ( Line_Number ) OF

      1 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_Horizontal_Size, 2, 10, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 10) ;
          END ;

      2 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_Vertical_Size, 2, 12, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 10) ;
          END ;

    OTHERWISE  ; { do nothing }

    END ; { Of Case }

END ; (* SCRI_Set_Cursor_Read_Input *)



(********************************************************************)
PROCEDURE CASI_Check_And_Store_Input ;
(********************************************************************)

VAR
    I         : INTEGER ;

BEGIN (* CASI_Check_And_Store_Input *)

    CASE Line_Number OF

      1 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF NOT Error AND (Value > 0.0)
                  THEN Plot_Horizontal_Size := Value ;
          END ;

      2 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF NOT Error AND (Value > 0.0)
                  THEN Plot_Vertical_Size := Value ;
          END ;

    END ; { Of Case }

  IF (Error) THEN BELLRI_Bell_Ring ;

END ; (* CASI_Check_And_Store_Input *)


(********************************************************************)
PROCEDURE DNV_Display_New_Value ;
(********************************************************************)
BEGIN

    CASE ( Line_Number ) OF

      1 : BEGIN
               CURPOS_Cursor_Position (10, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Plot_Horizontal_Size :10:2, MM_or_Inches:3 ) ;
          END ;

      2 : BEGIN
               CURPOS_Cursor_Position (12, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Plot_Vertical_Size :10:2, MM_or_Inches:3 ) ;
          END ;

    OTHERWISE ; { do nothing }
    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* DMS_Define_Manuscript_Size *)

  Message         := Blank_40 ;
  SString         := Blank_40 ;
  Value           := 0.0 ;
  Finished        := FALSE ;
  Return          := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 2 ;

  IF Linear_Units [1] <> 'M'
   THEN BEGIN
        Plot_Horizontal_Size := Plot_Horizontal_Size / 25.4 ;
        Plot_Vertical_Size := Plot_Vertical_Size / 25.4 ;
        END ;

  WMPCRT_Write_Menu_Page_CRT ;

  REPEAT

     CF_Check_Finished ;
     WM_Write_Message ;
     Message := Blank_40 ;

     Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 2) ;
     Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
     Line_Number := TRUNC ( Value ) ;

     IF ( SString [1] = '?' )
      THEN BEGIN
              RADH_Read_And_Display_Help ( Help_Text_File, 6 ) ;
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
           DNV_Display_New_Value ;
           Return := FALSE ;
           END
      ELSE IF (Return) OR (Scape) OR (SString [1] IN ['p', 'P', '?'])
               THEN
               ELSE BELLRI_Bell_Ring ;

     IF    ( Arrow_Key <> ' ' )
       AND NOT Finished
       THEN Scape := FALSE ;

  UNTIL Scape OR (Return AND Finished) ;

  IF Linear_Units [1] <> 'M'
   THEN BEGIN
        Plot_Horizontal_Size := Plot_Horizontal_Size * 25.4 ;
        Plot_Vertical_Size := Plot_Vertical_Size * 25.4 ;
        END ;

END ; (* DMS_Define_Manuscript_Size *)
END.
