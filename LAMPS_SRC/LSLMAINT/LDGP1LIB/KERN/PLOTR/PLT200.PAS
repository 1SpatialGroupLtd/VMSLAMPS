[INHERIT ('Inherit_File')]
MODULE PLT200 ;

{ PLT200.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE SPF_Single_Point_Format ;
(****************************************************************************)
VAR
    Black_String           : String_30 ;
    SString                 : String_40 ;
    Number_Of_Lines,
    Line_Number,
    Number_Of_Characters   : INTEGER ;
    Value                  : DOUBLE ;
    Error,
    Return                 : BOOLEAN ;


    Field,
    Decimals               : INTEGER ;



(**********************************************************************)
PROCEDURE WMPCRT_Write_Menu_Page_CRT ;
(**********************************************************************)

BEGIN (* WMPCRT_Write_Menu_Page_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 2                 SINGLE POINT FORMAT' ) ;
  WRITELN ;

WRITELN ( ' 1.              EVENT COUNTER FORMAT = ', Event_Counter_Format:1);
WRITELN ( ' 2.                  TAG FIELD FORMAT = ',
                                                 Tag_Field_Single_Format:1);
WRITELN ( ' 3.                 ANNOTATION FORMAT = ', Annotation_Format:1 ) ;
WRITELN ( ' 4.               SWITCH CODES FORMAT = ', Switch_Codes_Format:1 );
WRITELN ;
WRITELN ( ' 5.                          X FORMAT = ', X_Single_Format:8) ;
WRITELN ( ' 6.                          Y FORMAT = ', Y_Single_Format:8) ;
WRITELN ( ' 7.                          Z FORMAT = ', Z_Single_Format:8) ;
WRITELN ( ' 8.                          P FORMAT = ', P_Single_Format:8) ;
WRITELN ( ' 9.              COMPUTED AREA FORMAT = ', Computed_Area_Format:8);
WRITELN ;
WRITELN ( '10.                   RECORDING ORDER = ', Single_Recording_Order:8 ) ;

  CURPOS_Cursor_Position (22,0) ;
  WRITELN ( '     ANY CHANGES? IF SO,  TYPE LINE NUMBER, <RETURN>, NEW VALUE, <RETURN>     ' ) ;
  WRITE   ( '                  IF NOT, PRESS <RETURN>  ' ) ;

END ;  (* WMPCRT_Write_Menu_Page_CRT *)


(********************************************************************)
PROCEDURE WM_Write_Message ;
(********************************************************************)
BEGIN

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
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 2                 SINGLE POINT FORMAT' ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 1.              EVENT COUNTER FORMAT = ', Event_Counter_Format:1         ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 2.                  TAG FIELD FORMAT = ',
                                                 Tag_Field_Single_Format:1);
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 3.                 ANNOTATION FORMAT = ', Annotation_Format:1         ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 4.               SWITCH CODES FORMAT = ', Switch_Codes_Format:1         ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 5.                          X FORMAT = ', X_Single_Format:8) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 6.                          Y FORMAT = ', Y_Single_Format:8) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 7.                          Z FORMAT = ', Z_Single_Format:8) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 8.                          P FORMAT = ', P_Single_Format:8) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 9.              COMPUTED AREA FORMAT = ', Computed_Area_Format:8) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, '10.                   RECORDING ORDER = ', Single_Recording_Order:8         ) ;
   WRITELN (Out_Write) ;

   CLOSE (Out_Write) ;

END ;  (* PMP_Print_Menu_Page *)


(**********************************************************************)
PROCEDURE SCRI_Set_Cursor_Read_Input ;
(**********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* SCRI_Set_Cursor_Read_Input *)

    CASE ( Line_Number ) OF

      1 : BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Event_Counter_Format, 7, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      2 : BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Tag_Field_Single_Format, 8, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      3 : BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Annotation_Format, 9, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      4 : BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Switch_Codes_Format, 10, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      5 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := X_Single_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 12, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      6 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Y_Single_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 13, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      7 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Z_Single_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 14, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      8 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := P_Single_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 15, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      9 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Computed_Area_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 16, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

     10 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Single_Recording_Order [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 18, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

    END ; { Of Case }

END ; (* SCRI_Set_Cursor_Read_Input *)


(********************************************************************)
PROCEDURE CRF_Check_Real_Format ;
(********************************************************************)
VAR
   I, N_Dec  : INTEGER ;
BEGIN
     Field    := 0 ;
     Decimals := 0 ;

     Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);

     { only one decimal place is allowed }
     N_Dec := 0 ;
     I := 0 ;
     REPEAT
           I := I + 1 ;
           IF SString [I] = '.'
              THEN N_Dec := I ;
     UNTIL   ( SString [I] = '.' )
          OR ( I=40 ) ;

     IF    ( N_Dec > 0 )
       AND ( I < 40-1 )
       THEN
           FOR I := N_Dec+2 TO 40 DO
               IF SString [I] <> ' '
                  THEN Error := TRUE ;

     IF Value <= 0
        THEN Error := TRUE ;

     IF NOT Error
        THEN BEGIN
                  Field := TRUNC ( Value ) ;
                  Decimals := ROUND ( (Value-Field) * 10.0 ) ;
               END ;

     IF NOT Error
        THEN BEGIN
                  IF Decimals > Field
                     THEN Error := TRUE ;
                  IF Field > Max_Field
                     THEN Error := TRUE ;
               END ;

END ; (* CRF_Check_Real_Format *)


(********************************************************************)
PROCEDURE CASI_Check_And_Store_Input ;
(********************************************************************)

VAR
    I, K   : INTEGER ;
    X      : DOUBLE    ;

BEGIN (* CASI_Check_And_Store_Input *)

    CASE ( Line_Number ) OF

      1 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
               IF (Value <= 0) OR (Value > 40)
                  THEN Error := TRUE ;
               IF NOT Error
                  THEN Event_Counter_Format := TRUNC ( Value ) ;
           END ;

      2 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
              IF (Value <= 0) OR (Value > 40)
                 THEN Error := TRUE ;

              IF NOT Error
                 THEN Tag_Field_Single_Format := TRUNC ( Value ) ;
          END ;

      3 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
              IF (Value <= 0) OR (Value > 40)
                 THEN Error := TRUE ;

              IF NOT Error
                 THEN Annotation_Format := TRUNC ( Value ) ;
          END ;

      4 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
               IF (Value <= 0) OR (Value > 40)
                 THEN Error := TRUE ;

               IF NOT Error
                  THEN Switch_Codes_Format := TRUNC ( Value ) ;
            END ;

      5 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                  THEN FOR I := 1 TO 8 DO X_Single_Format [I] := SString [I] ;
          END ;

      6 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                  THEN FOR I := 1 TO 8 DO Y_Single_Format [I] := SString [I] ;
          END ;

      7 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                  THEN FOR I := 1 TO 8 DO Z_Single_Format [I] := SString [I] ;
          END ;

      8 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                  THEN FOR I := 1 TO 8 DO P_Single_Format [I] := SString [I] ;
          END ;

      9 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                  THEN FOR I := 1 TO 8 DO
                           Computed_Area_Format [I] := SString [I] ;
          END ;

     10 : BEGIN
            { convert to capital letters }
            FOR I := 1 TO Number_Of_Characters DO
              BEGIN
                 CC_Capitalise_Char ( SString [I] ) ;
                 IF SString [I] IN ['X'..'Z', 'P', 'E', 'A', 'S', 'C', 'T']
                    THEN
                    ELSE Error := TRUE ;
              END ;

            IF NOT Error
            THEN FOR I := 1 TO Number_Of_Characters-1 DO
                   FOR K := I+1 TO Number_Of_Characters DO
                      IF (SString[I] <> SString[K])  THEN
                                                   ELSE Error := TRUE ;

            IF NOT Error
               THEN FOR I := 1 TO 8 DO
                        Single_Recording_Order [I] := SString [I] ;

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
               CURPOS_Cursor_Position (7, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Event_Counter_Format:1) ;
            END ;

      2 : BEGIN
               CURPOS_Cursor_Position (8, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Tag_Field_Single_Format:1) ;
          END ;

      3 : BEGIN
               CURPOS_Cursor_Position (9, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Annotation_Format:1) ;
          END ;

      4 : BEGIN
               CURPOS_Cursor_Position (10, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Switch_Codes_Format:1) ;
            END ;

      5 : BEGIN
               CURPOS_Cursor_Position (12, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (X_Single_Format:8) ;
          END ;

      6 : BEGIN
               CURPOS_Cursor_Position (13, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Y_Single_Format:8) ;
            END ;

      7 : BEGIN
               CURPOS_Cursor_Position (14, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Z_Single_Format:8) ;
            END ;

      8 : BEGIN
               CURPOS_Cursor_Position (15, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (P_Single_Format:8) ;
          END ;

      9 : BEGIN
               CURPOS_Cursor_Position (16, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Computed_Area_Format:8) ;
            END ;

     10 : BEGIN
               CURPOS_Cursor_Position (18, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Single_Recording_Order:8) ;
            END ;

    OTHERWISE ; { do nothing }
    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* SPF_Single_Point_Format *)

  SString         := Blank_40 ;
  Black_String    := Blank_30 ;
  Value           := 0.0 ;
  Return          := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 10 ;

  WMPCRT_Write_Menu_Page_CRT ;


  REPEAT

     WM_Write_Message ;

     Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 2) ;

     Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
     Line_Number := TRUNC ( Value ) ;

     IF ( SString [1] = '?' )
      THEN BEGIN
              RADH_Read_And_Display_Help ( Help_Text_File, 3 ) ;
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

  UNTIL Scape OR Return ;

END ; (* SPF_Single_Point_Format *)
END.
