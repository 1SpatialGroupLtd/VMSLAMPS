[INHERIT ('Inherit_File')]
MODULE PLT130 ;

{ PLT130.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE DMP_Define_Manuscript_Parameters ;
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


    I,
    Len                    : INTEGER ;



(**********************************************************************)
PROCEDURE WMPCRT_Write_Menu_Page_CRT ;
(**********************************************************************)

BEGIN (* WMPCRT_Write_Menu_Page_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 4               MANUSCRIPT PARAMETERS' ) ;
  WRITELN ;

  WRITELN ( ' 1.                   PLOT HORIZONTAL = ', Plot_Horizontal:2 ) ;
  WRITELN ( ' 2.                     PLOT VERTICAL = ', Plot_Vertical:2 ) ;
  WRITELN ;
  WRITELN ( ' 3.                      PLOT X SCALE = ', Plot_X_Scale:11:3) ;
  WRITELN ( ' 4.                      PLOT Y SCALE = ', Plot_Y_Scale:11:3) ;
  WRITELN ;
  WRITELN ( ' 5.                     PLOT ROTATION = ', Plot_Rotation*Ro:11:3,
                                                        Gons_or_Degrees:8 ) ;
  WRITELN ;
  WRITELN ( ' 6.                      PLOT X INDEX = ', Plot_X_Index:11:3,
                                                        Meters_or_Feet:3 ) ;
  WRITELN ( ' 7.                      PLOT Y INDEX = ', Plot_Y_Index:11:3,
                                                        Meters_or_Feet:3 ) ;
  WRITELN ;
  WRITE   ( ' 8.                INPUT SHEET WINDOW = ' ) ;
  IF Input_Sheet_Window THEN WRITELN ( 'YES' )
                        ELSE WRITELN ( 'NO ' ) ;

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

   PKT_Print_Kern_Title ( Ten_Digit_Number, Title );

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 4               MANUSCRIPT PARAMETERS' ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 1.                   PLOT HORIZONTAL = ', Plot_Horizontal:2) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 2.                     PLOT VERTICAL = ', Plot_Vertical:2) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 3.                      PLOT X SCALE = ', Plot_X_Scale:11:3       ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 4.                      PLOT Y SCALE = ', Plot_Y_Scale:11:3       ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 5.                     PLOT ROTATION = ',
            Plot_Rotation*Ro:11:3, Gons_or_Degrees:8 ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 6.                      PLOT X INDEX = ',
            Plot_X_Index:11:3, Meters_or_Feet:3 ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 7.                      PLOT Y INDEX = ',
            Plot_Y_Index:11:3, Meters_or_Feet:3 ) ;

   WRITELN (Out_Write) ;

   WRITE   (Out_Write, ' 8.                INPUT SHEET WINDOW = ' ) ;
   IF Input_Sheet_Window THEN WRITELN (Out_Write, 'YES' )
                         ELSE WRITELN (Out_Write, 'NO ' ) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, Message);

   CLOSE (Out_Write) ;

END ;  (* PMP_Print_Menu_Page *)


(********************************************************************)
PROCEDURE CF_Check_Finished ;
(********************************************************************)
BEGIN

 Message := Blank_40 ;
 Finished := TRUE ;

END ;

(********************************************************************)
PROCEDURE SCRI_Set_Cursor_Read_Input ;
(********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* SCRI_Set_Cursor_Read_Input *)

    CASE ( Line_Number ) OF

      1 : BEGIN
            FOR I := 1 TO 2 DO
                Black_String [I] := Plot_Horizontal [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 7, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 2) ;
          END ;

      2 : BEGIN
            FOR I := 1 TO 2 DO
                Black_String [I] := Plot_Vertical [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 8, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 2) ;
          END ;

      3 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_X_Scale, 3, 10, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 13) ;
          END ;

      4 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_Y_Scale, 3, 11, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 13) ;
          END ;

      5 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_Rotation*Ro, 3, 13, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 13) ;
          END ;

      6 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_X_Index, 3, 15, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 13) ;
          END ;

      7 : BEGIN
            SCAWBR_Set_Cursor_And_Write_Black_Real
               ( Plot_Y_Index, 3, 16, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 13) ;
          END ;

      8 : BEGIN
          END ;

    OTHERWISE  ; { do nothing }

    END ; { Of Case }

END ; (* SCRI_Set_Cursor_Read_Input *)



(********************************************************************)
PROCEDURE CASI_Check_And_Store_Input ;
(********************************************************************)

VAR
    Len,
    I         : INTEGER ;

    Aux       : String_2 ;

BEGIN (* CASI_Check_And_Store_Input *)

    CASE Line_Number OF


      1 : BEGIN
               IF SString[1] IN ['+', '-']
                  THEN BEGIN
                            FOR I := 1 TO 2 DO Aux[I] :=SString[I]
                         END
                  ELSE BEGIN
                            Aux [1] := '+' ;
                            Aux [2] := SString [1] ;
                         END ;

                CC_Capitalise_Char ( Aux [2] ) ;
                IF Aux [2] IN ['X'..'Z', 'P']
                   THEN
                   ELSE Error := TRUE ;

                IF Aux [2] = Plot_Vertical[2]
                   THEN Error := TRUE ;

                IF NOT Error
                   THEN Plot_Horizontal := Aux ;
          END ;

      2 : BEGIN
               IF SString[1] IN ['+', '-']
                  THEN BEGIN
                            FOR I := 1 TO 2 DO Aux[I] :=SString[I]
                         END
                  ELSE BEGIN
                            Aux [1] := '+' ;
                            Aux [2] := SString [1] ;
                         END ;

                CC_Capitalise_Char ( Aux [2] ) ;
                IF Aux [2] IN ['X'..'Z', 'P']
                   THEN
                   ELSE Error := TRUE ;

                IF Aux [2] = Plot_Horizontal[2]
                   THEN Error := TRUE ;

                IF NOT Error
                   THEN Plot_Vertical := Aux ;
          END ;

      3 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF Value <=  0.0
                  THEN Error := TRUE ;
               IF NOT Error
                  THEN Plot_X_Scale := Value  ;
            END ;

      4 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF Value <= 0.0
                  THEN Error := TRUE ;
               IF NOT Error
                  THEN Plot_Y_Scale := Value ;
            END ;

      5 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF Rotation_Units = 'GONS   '
                  THEN
                      IF   ( Value < -400.0 )
                        OR ( Value >  400.0 )
                        THEN Error := TRUE ;

               IF Rotation_Units = 'DEGREES'
                  THEN
                      IF   ( Value < -360.0 )
                        OR ( Value >  360.0 )
                        THEN Error := TRUE ;

            IF NOT Error
               THEN Plot_Rotation := Value / Ro ;
          END ;

      6 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF NOT Error
                  THEN Plot_X_Index := Value ;
          END ;

      7 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);
               IF NOT Error
                  THEN Plot_Y_Index := Value ;
          END ;

      8 : BEGIN
            IF Input_Sheet_Window THEN Input_Sheet_Window := FALSE
                                  ELSE Input_Sheet_Window := TRUE ;
          END ;


    END ; { Of Case }

  IF (Error) THEN BELLRI_Bell_Ring ;

END ; (* CASI_Check_And_Store_Input *)


(********************************************************************)
PROCEDURE DNV_Display_New_Value ;
(********************************************************************)
BEGIN

    CASE ( Line_Number ) OF

      1,
      2 : BEGIN
               CURPOS_Cursor_Position (7, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Plot_Horizontal:2) ;
               CURPOS_Cursor_Position (8, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Plot_Vertical:2) ;
          END ;

      3 : BEGIN
               CURPOS_Cursor_Position (10, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Plot_X_Scale:11:3) ;
          END ;

      4 : BEGIN
               CURPOS_Cursor_Position (11, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Plot_Y_Scale:11:3) ;
            END ;

      5 : BEGIN
               CURPOS_Cursor_Position (13, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Plot_Rotation*Ro:11:3 , Gons_or_Degrees:8 ) ;
          END ;

      6 : BEGIN
               CURPOS_Cursor_Position (15, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Plot_X_Index:11:3, Meters_or_Feet:3 ) ;
          END ;

      7 : BEGIN
               CURPOS_Cursor_Position (16, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( Plot_Y_Index:11:3, Meters_or_Feet:3 ) ;
          END ;

      8 : BEGIN
               CURPOS_Cursor_Position (18, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               IF Input_Sheet_Window THEN WRITELN ( 'YES' )
                                     ELSE WRITELN ( 'NO ' ) ;
          END ;

    OTHERWISE ; { do nothing }

    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* DMP_Define_Manuscript_Parameters *)

  Message         := Blank_40 ;
  SString         := Blank_40 ;
  Black_String    := Blank_30 ;
  Value           := 0.0 ;
  Finished        := FALSE ;
  Return          := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 8 ;

  IF Linear_Units [1] <> 'M'
   THEN BEGIN
        Plot_X_Scale := Plot_X_Scale / 12.0 ;
        Plot_Y_Scale := Plot_Y_Scale / 12.0 ;
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
              RADH_Read_And_Display_Help ( Help_Text_File, 5 ) ;
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
        Plot_X_Scale := Plot_X_Scale * 12.0 ;
        Plot_Y_Scale := Plot_Y_Scale * 12.0 ;
        Plot_Horizontal_Size := Plot_Horizontal_Size * 25.4 ;
        Plot_Vertical_Size := Plot_Vertical_Size * 25.4 ;
        END ;

END ; (* DMP_Define_Manuscript_Parameters *)
END.
