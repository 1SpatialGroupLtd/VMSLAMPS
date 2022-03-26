[INHERIT ('Inherit_File')]
MODULE PLT201 ;

{ PLT201.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE MPF_Multiple_Point_Format ;
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
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 3               MULTIPLE POINT FORMAT' ) ;
  WRITELN ;

WRITELN ( ' 1.                CARD NUMBER FORMAT = ', Card_Number_Format:1);
WRITELN ( ' 2.                  TAG FIELD FORMAT = ',
                                              Tag_Field_Multiple_Format:1 ) ;
WRITELN ( ' 3.                  FIXED ANNOTATION = ', Fixed_Annotation ) ;
WRITELN ;
WRITELN ( ' 4.           DECIMAL POINT RECORDING = ',
                                                   Decimal_Point_Recording ) ;
WRITELN ( ' 5.               SIGN OF P RECORDING = ', Sign_Of_P_Recording ) ;
WRITELN ;
WRITELN ( ' 6.                          X FORMAT = ', X_Multiple_Format:8) ;
WRITELN ( ' 7.                          Y FORMAT = ', Y_Multiple_Format:8) ;
WRITELN ( ' 8.                          Z FORMAT = ', Z_Multiple_Format:8) ;
WRITELN ( ' 9.                          P FORMAT = ', P_Multiple_Format:8) ;
WRITELN ( '10.           FIXED ANNOTATION FORMAT = ',
                                              Fixed_Annotation_Format :1 ) ;
WRITELN ;
WRITELN ( '11.                   RECORDING ORDER = ',
                                               Multiple_Recording_Order:15 ) ;

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

   PKT_Print_Kern_Title ( ten_Digit_Number, Title );

   WRITELN ( Out_Write, 'OFF-LINE PLOTTING                   PAGE 3               MULTIPLE POINT FORMAT' ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN ( Out_Write, ' 1.                CARD NUMBER FORMAT = ', Card_Number_Format:1);
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 2.                  TAG FIELD FORMAT = ',
                                              Tag_Field_Multiple_Format:1 ) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 3.                  FIXED ANNOTATION = ', Fixed_Annotation ) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 4.           DECIMAL POINT RECORDING = ',
                                                   Decimal_Point_Recording ) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 5.               SIGN OF P RECORDING = ', Sign_Of_P_Recording ) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 6.                          X FORMAT = ', X_Multiple_Format:8) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 7.                          Y FORMAT = ', Y_Multiple_Format:8) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 8.                          Z FORMAT = ', Z_Multiple_Format:8) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, ' 9.                          P FORMAT = ', P_Multiple_Format:8) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, '10.           FIXED ANNOTATION FORMAT = ',
                                              Fixed_Annotation_Format :1 ) ;
   WRITELN ( Out_Write ) ;
   WRITELN ( Out_Write, '11.                   RECORDING ORDER = ',
                                               Multiple_Recording_Order:15 ) ;

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
                                       ( Card_Number_Format, 7, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      2 : BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Tag_Field_Multiple_Format, 8, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

      3:  BEGIN
            FOR I := 1 TO 16 DO
                Black_String [I] := Fixed_Annotation [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 9, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 16) ;
          END ;

      4:  BEGIN
            IF (Decimal_Point_Recording = 'YES')
             THEN Decimal_Point_Recording := 'NO '
             ELSE Decimal_Point_Recording := 'YES' ;
          END ;

      5:  BEGIN
            IF (Sign_Of_P_Recording = 'YES')
             THEN Sign_Of_P_Recording := 'NO '
             ELSE Sign_Of_P_Recording := 'YES' ;
          END ;

      6 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := X_Multiple_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 14, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      7 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Y_Multiple_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 15, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      8 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := Z_Multiple_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 16, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

      9 : BEGIN
            FOR I := 1 TO 8 DO
                Black_String [I] := P_Multiple_Format [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 17, 41) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 8) ;
          END ;

     10:  BEGIN
            SCAWBI_Set_Cursor_And_Write_Black_Integer
                                       ( Fixed_Annotation_Format, 18, 41 ) ;
            Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 3) ;
          END ;

     11 : BEGIN
            FOR I := 1 TO 15 DO
                Black_String [I] := Multiple_Recording_Order [I] ;
            SCAWBS_Set_Cursor_And_Write_Black_String
                                    ( Black_String, 20, 41 ) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 15) ;
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
                  THEN Card_Number_Format := TRUNC ( Value ) ;
           END ;

      2 : BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
              IF (Value <= 0) OR (Value > 40)
                 THEN Error := TRUE ;

              IF NOT Error
                 THEN Tag_Field_Multiple_Format := TRUNC ( Value ) ;
          END ;

      3:  BEGIN
            FOR I := 1 TO 16 DO
                Fixed_Annotation [I] := SString [I] ;
          END ;

      4 : BEGIN
          END ;

      5:  BEGIN
          END ;

      6 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                THEN FOR I := 1 TO 8 DO X_Multiple_Format [I] := SString [I] ;
          END ;

      7 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                THEN FOR I := 1 TO 8 DO Y_Multiple_Format [I] := SString [I] ;
          END ;

      8 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                THEN FOR I := 1 TO 8 DO Z_Multiple_Format [I] := SString [I] ;
          END ;

      9 : BEGIN
               CRF_Check_Real_Format ;

               IF NOT Error
                THEN FOR I := 1 TO 8 DO P_Multiple_Format [I] := SString [I] ;
          END ;

     10:  BEGIN
            Convert_To_Numeric (SString, Number_Of_Characters, Value, Error ) ;
               IF (Value <= 0) OR (Value > 40)
                  THEN Error := TRUE ;
               IF NOT Error
                  THEN Fixed_Annotation_Format := TRUNC ( Value ) ;
          END ;

     11 : BEGIN
            { convert to capital letters }
            FOR I := 1 TO Number_Of_Characters DO
              BEGIN
                 CC_Capitalise_Char ( SString [I] ) ;
                 IF SString [I] IN ['A', 'X'..'Z', 'P', 'C', 'T']
                    THEN
                    ELSE Error := TRUE ;
              END ;

            IF NOT Error
               THEN FOR I := 1 TO 15 DO
                        Multiple_Recording_Order [I] := SString [I] ;

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
               WRITELN (Card_Number_Format:1) ;
            END ;

      2 : BEGIN
               CURPOS_Cursor_Position (8, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Tag_Field_Multiple_Format:1) ;
          END ;

      3:  BEGIN
               CURPOS_Cursor_Position (9, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Fixed_Annotation) ;
          END ;

      4 : BEGIN
               CURPOS_Cursor_Position (11, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Decimal_Point_Recording) ;
          END ;

      5:  BEGIN
               CURPOS_Cursor_Position (12, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Sign_Of_P_Recording) ;
          END ;

      6 : BEGIN
               CURPOS_Cursor_Position (14, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (X_Multiple_Format:8) ;
          END ;

      7 : BEGIN
               CURPOS_Cursor_Position (15, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Y_Multiple_Format:8) ;
            END ;

      8 : BEGIN
               CURPOS_Cursor_Position (16, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Z_Multiple_Format:8) ;
            END ;

      9 : BEGIN
               CURPOS_Cursor_Position (17, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (P_Multiple_Format:8) ;
          END ;

     10:  BEGIN
               CURPOS_Cursor_Position (18, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Fixed_Annotation_Format :1) ;
          END ;

     11 : BEGIN
               CURPOS_Cursor_Position (20, 41) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN (Multiple_Recording_Order) ;
            END ;

    OTHERWISE ; { do nothing }
    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* MPF_Multiple_Point_Format *)

  SString          := Blank_40 ;
  Black_String    := Blank_30 ;
  Value           := 0.0 ;
  Return          := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 11 ;

  WMPCRT_Write_Menu_Page_CRT ;

  REPEAT

     WM_Write_Message ;

     Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 2) ;

     Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
     Line_Number := TRUNC ( Value ) ;

     IF ( SString [1] = '?' )
      THEN BEGIN
              RADH_Read_And_Display_Help ( Help_Text_File, 4 ) ;
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

END ; (* MPF_Multiple_Point_Format *)
END.
