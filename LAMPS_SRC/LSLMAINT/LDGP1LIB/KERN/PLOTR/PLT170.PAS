[INHERIT ('Inherit_File')]
MODULE PLT170 ;

{ PLT170.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE LASS_Line_And_Symbol_Selection ;
(****************************************************************************)
CONST
    Line_Not_Found     = '   ** LINE NOT FOUND IN INPUT FILE **   ' ;
    Symbol_Not_Found   = ' **  SYMBOL NOT FOUND IN INPUT FILE  ** ' ;

    Line_Level_Not_Found     = '** LINE LEVEL NOT FOUND IN INPUT FILE **' ;
    Symbol_Level_Not_Found   = '**SYMBOL LEVEL NOT FOUND IN INPUT FILE**' ;

VAR
    Black_String           : String_30 ;
    SString,
    Message                : String_40 ;

    Number_Of_Lines,
    Line_Number,
    Number_Of_Characters   : INTEGER ;
    Value                  : DOUBLE ;
    Error,
    Return,
    Finished               : BOOLEAN ;



(********************************************************************)
PROCEDURE Display_Available_Lines_and_Symbols ;
(********************************************************************)
VAR
   I           : INTEGER ;
   Nr_Line     : INTEGER ;

BEGIN (* SMIL_Search_Model_In_Library *)


      SETSCR_Set_Scroll (9, 22) ;
      CURPOS_Cursor_Position (7,0) ;

      IF Line_Number = 5
         THEN
WRITELN ('  LINE  ALPHA DESCRIPTION                    LINE  ALPHA DESCRIPTION') ;
      IF Line_Number = 6
         THEN
WRITELN ('SYMBOL  ALPHA DESCRIPTION                  SYMBOL  ALPHA DESCRIPTION') ;
      IF Line_Number = 7
         THEN
WRITELN ('             LINE  LEVELS                               LINE  LEVELS') ;
      IF Line_Number = 8
         THEN
WRITELN ('           SYMBOL  LEVELS                             SYMBOL  LEVELS') ;

      CURPOS_Cursor_Position (8,0) ;
      ERADIS_Erase_Display  ('D') ;
      WRITELN ;

      Nr_Line := 0 ;

      { look and display }
      FIND  ( Layer_File, 1+(Line_Number-5)*1000 ) ;
      FOR I := 1 TO 1000 DO
          BEGIN
               READ  ( Layer_File, Layer ) ;
               IF Layer
                  AND ( Line_Number = 5 )
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Line_Type_Code_Number := I ;
                            Get_Line_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITELN ( I:5, Line_Alpha_Description:20,
                                                 ' ':18 )
                               ELSE WRITELN ( I:5, Line_Alpha_Description:20);
                        END ;

               IF Layer
                  AND ( Line_Number = 6 )
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Symbol_Code_Number := I ;
                            Get_Symbol_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITELN ( I:5, Symbol_Alpha_Description:20,
                                                 ' ':18 )
                               ELSE WRITELN ( I:5, Symbol_Alpha_Description:20) ;
                         END ;

               IF Layer
                  AND (  ( Line_Number = 7 ) OR ( Line_Number = 8 ) )
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            IF ODD(Nr_Line)
                               THEN WRITELN   ( I:18, ' ':25 )
                               ELSE WRITELN ( I:18 ) ;
                        END ;

               IF ( Nr_Line = 26 )
                  THEN BEGIN
                            DBWIDT_Double_Width ( 24 ) ;
                            WRITE (' TO CONTINUE PRESS <RETURN> ') ;
                            READLN ;
                            CURPOS_Cursor_Position (23,0) ;
                            ERADIS_Erase_Display  ('D') ;
                            WRITELN ;
                            CURPOS_Cursor_Position (22,0) ;
                            Nr_Line := 0 ;
                         END ;

            END ;

      IF NOT (Nr_Line = 0)
         THEN BEGIN
                   DBWIDT_Double_Width ( 24 ) ;
                   WRITE (' TO CONTINUE PRESS <RETURN> ') ;
                   READLN ;
                END ;

      SETSCR_Set_Scroll (1, 24) ;

END ; (* Display_Available_Lines_and_Symbols *)


(********************************************************************)
PROCEDURE WM_Write_Message ;
(********************************************************************)
BEGIN

     DBWIDT_Double_Width ( 20 ) ;
     WRITELN ( Message ) ;

     IF Message <> Blank_40
        THEN BELLRI_Bell_Ring ;


  CURPOS_Cursor_Position (22,0) ;
  WRITELN ( '     ANY CHANGES? IF SO,  TYPE LINE NUMBER, <RETURN>, NEW VALUE, <RETURN>     ' ) ;
  WRITE   ( '                  IF NOT, PRESS <RETURN>  ' ) ;
  ERALIN_Erase_In_Line  ('R') ;

END ;  (* WM_Write_Message *)


(********************************************************************)
PROCEDURE SCRI_Set_Cursor_Read_Input ;
(********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* SCRI_Set_Cursor_Read_Input *)

    CASE ( Line_Number ) OF

      1 : BEGIN
            Black_String := Blank_30 ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 7, 49) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 30) ;
          END ;

      2 : BEGIN
            Black_String := Blank_30 ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 8, 49) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 30) ;
          END ;

      3 : BEGIN
            Black_String := Blank_30 ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 10, 49) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 30) ;
          END ;

      4 : BEGIN
            Black_String := Blank_30 ;
            SCAWBS_Set_Cursor_And_Write_Black_String (Black_String, 11, 49) ;
            Read_Key_Board
                (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 30) ;
          END ;

      5 : BEGIN
            END ;

      6 : BEGIN
            END ;

      7 : BEGIN
            END ;

      8 : BEGIN
            END ;

    END ; { Of Case }

END ; (* SCRI_Set_Cursor_Read_Input *)

(********************************************************************)
PROCEDURE ISA_Is_Selection_Available ;
(********************************************************************)
VAR
   I  : INTEGER ;
   N  : INTEGER ;

BEGIN (* ISA_Is_Selection_Available *)

     FOR I := 1 TO Nr_of_Layers DO
         BEGIN
              N := ABS( Selected_Layer[I] ) + (Line_Number-1)*1000 ;
              FIND ( Layer_File, N ) ;
              READ  ( Layer_File, Layer ) ;
              IF NOT Layer
                 AND NOT ( ( I = 1 ) AND ( Selected_Layer [1] = 1000 ) )
                 THEN BEGIN
                           CASE Line_Number OF
                              1 : Message := Line_Not_Found ;
                              2 : Message := Symbol_Not_Found ;
                              3 : Message := Line_Level_Not_Found ;
                              4 : Message := Symbol_Level_Not_Found ;
                           END ; (* CASE *)
                           Error := TRUE ;
                        END ;
           END ;
END ; (* ISA_Is_Selection_Available *)


(********************************************************************)
PROCEDURE FS_Find_Selection ;
(********************************************************************)
VAR
    N,
    I   : INTEGER ;
    Str : String_40 ;

BEGIN (* FS_Find_Selection *)

     Error := FALSE ;
     Nr_of_Layers := 0 ;
     N   := Number_Of_Characters ;
     Str := SString ;

     IF   ( SString [1] = 'A' )
       OR ( SString [1] = 'a' )
        THEN BEGIN
                  Str [1] := 'A' ;
                  Nr_of_Layers := Nr_of_Layers + 1 ;
                  Selected_Layer [ Nr_of_Layers ] := 1000 ;
                  I := 2 ;
              END
        ELSE I := 0 ;

     SString := Blank_40 ;
     Number_Of_Characters := 0 ;

     REPEAT
           I := I + 1 ;
           SString [ Number_Of_Characters + 1 ] := Str [I] ;

           IF   ( Str [I] <> ',' )
             THEN Number_Of_Characters := Number_Of_Characters + 1 ;

           IF   ( Str [I] = ',' )
             OR ( I = N )
             THEN BEGIN
                       Convert_To_Numeric ( SString, Number_Of_Characters,
                                            Value, Error ) ;
                       IF NOT Error
                          AND ( ( ABS(Value) > 0 ) AND ( ABS(Value) < 1000 ) )
                          THEN BEGIN
                               Nr_of_Layers := Nr_of_Layers + 1 ;
                               Selected_Layer [Nr_of_Layers] := TRUNC (Value);
                                 END ;

                       SString := Blank_40 ;
                       Number_Of_Characters := 0 ;
                    END ;

     UNTIL ( I >= N )
           OR Error ;

     IF Error
        THEN Nr_of_Layers := 0 ;

     { restore input string }
     SString := Str ;

{======================================================================}
{
           IF Nr_of_Layers > 0
              THEN BEGIN
                        FOR I := 1 TO Nr_of_Layers DO
                            WRITELN ( I:4, Selected_Layer [I]:6 ) ;
                        READLN ;
                     END ;
}
{======================================================================}

END ; (* FS_Find_Selection *)



(********************************************************************)
PROCEDURE CASI_Check_And_Store_Input ;
(********************************************************************)

VAR
    I   : INTEGER ;

BEGIN (* CASI_Check_And_Store_Input *)

    Error := FALSE ;

    CASE ( Line_Number ) OF

      1 : BEGIN
               IF SString = Blank_40
                  THEN Error := TRUE
                  ELSE FS_Find_Selection ;

               IF NOT Error
                  THEN ISA_Is_Selection_Available ;

               IF Error
                  THEN Selected_Line_Type_Code_Number := FALSE
                  ELSE BEGIN
                            Selected_Line_Type_Code_Number   := TRUE  ;
                            Selected_Symbol_Code_Number := FALSE ;
                            Selected_Line_Level   := FALSE ;
                            Selected_Symbol_Level := FALSE ;
                         END ;
            END ;

      2 : BEGIN
               IF SString = Blank_40
                  THEN Error := TRUE
                  ELSE FS_Find_Selection ;

               IF NOT Error
                  THEN ISA_Is_Selection_Available ;

               IF Error
                  THEN Selected_Symbol_Code_Number:= FALSE
                  ELSE BEGIN
                            Selected_Line_Type_Code_Number   := FALSE ;
                            Selected_Symbol_Code_Number := TRUE ;
                            Selected_Line_Level   := FALSE ;
                            Selected_Symbol_Level := FALSE ;
                         END ;
            END ;

      3 : BEGIN
               IF SString = Blank_40
                  THEN Error := TRUE
                  ELSE FS_Find_Selection ;

               IF NOT Error
                  THEN ISA_Is_Selection_Available ;

               IF Error
                  THEN Selected_Line_Level := FALSE
                  ELSE BEGIN
                            Selected_Line_Type_Code_Number   := FALSE ;
                            Selected_Symbol_Code_Number := FALSE ;
                            Selected_Line_Level   := TRUE ;
                            Selected_Symbol_Level := FALSE ;
                         END ;
            END ;

      4 : BEGIN
               IF SString = Blank_40
                  THEN Error := TRUE
                  ELSE FS_Find_Selection ;

               IF NOT Error
                  THEN ISA_Is_Selection_Available ;

               IF Error
                  THEN Selected_Symbol_Level := FALSE
                  ELSE BEGIN
                            Selected_Line_Type_Code_Number   := FALSE ;
                            Selected_Symbol_Code_Number := FALSE ;
                            Selected_Line_Level   := FALSE ;
                            Selected_Symbol_Level := TRUE ;
                         END ;
            END ;

      5 : BEGIN
            END ;

      6 : BEGIN
            END ;

      7 : BEGIN
            END ;

      8 : BEGIN
            END ;

    END ; { Of Case }

END ; (* CASI_Check_And_Store_Input *)


(********************************************************************)
PROCEDURE DNV_Display_New_Value ;
(********************************************************************)
BEGIN

     CURPOS_Cursor_Position (7, 49) ;
     ERALIN_Erase_In_Line  ('R') ;
     WRITELN ;
     CURPOS_Cursor_Position (8, 49) ;
     ERALIN_Erase_In_Line  ('R') ;
     WRITELN ;
     CURPOS_Cursor_Position (10, 49) ;
     ERALIN_Erase_In_Line  ('R') ;
     WRITELN ;
     CURPOS_Cursor_Position (11, 49) ;
     ERALIN_Erase_In_Line  ('R') ;
     WRITELN ;

    CASE ( Line_Number ) OF

      1 : BEGIN
               CURPOS_Cursor_Position (7, 49) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( SString ) ;
            END ;

      2 : BEGIN
               CURPOS_Cursor_Position (8, 49) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( SString ) ;
            END ;

      3 : BEGIN
               CURPOS_Cursor_Position (10, 49) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( SString ) ;
            END ;

      4 : BEGIN
               CURPOS_Cursor_Position (11, 49) ;
               ERALIN_Erase_In_Line  ('R') ;
               WRITELN ( SString ) ;
            END ;

5,6,7,8 : BEGIN
                Display_Available_Lines_and_Symbols ;
                WMP7CRT_Write_Menu_Page_7_CRT ;
             END ;

    OTHERWISE ; { do nothing }
    END ; { Of Case }

END; (* DNV_Display_New_Value *)


{=======================================================================}

BEGIN  (* LASS_Line_And_Symbol_Selection *)

  Message         := Blank_40 ;
  SString          := Blank_40 ;
  Black_String    := Blank_30 ;
  Value           := 0.0 ;
  Return          := FALSE ;
  Error           := FALSE ;
  Arrow_Key       := ' ' ;
  Scape           := FALSE ;

  Number_Of_Lines := 8 ;

  SETSCR_Set_Scroll (1, 24) ;

  Selected_Line_Type_Code_Number := FALSE ;
  Selected_Symbol_Code_Number    := FALSE ;
  Selected_Line_Level   := FALSE ;
  Selected_Symbol_Level := FALSE ;

  WMP7CRT_Write_Menu_Page_7_CRT ;

  REPEAT

     WM_Write_Message ;
     Message := Blank_40 ;

     Read_Key_Board
                 (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 1) ;
     IF Arrow_Key <> ' ' THEN Scape := FALSE ;

     Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
     Line_Number := TRUNC ( Value ) ;

     IF ( SString [1] = '?' )
      THEN BEGIN
              RADH_Read_And_Display_Help ( Help_Text_File, 8 ) ;
              WMP7CRT_Write_Menu_Page_7_CRT ;
           END ;

     IF   ( SString [1] = 'P' )
       OR ( SString [1] = 'p' )
      THEN PMP7_Print_Menu_Page_7 ;

     IF ( Line_Number > 0 ) AND ( Line_Number <= Number_of_Lines )
      THEN BEGIN
           Error := FALSE ;
           SCRI_Set_Cursor_Read_Input ;
           IF NOT (Scape OR Return)
               THEN CASI_Check_And_Store_Input ;
           DNV_Display_New_Value ;
           Return := FALSE ;
           END
      ELSE IF (Return) OR (Scape) OR (SString [1] = '?')
               THEN
               ELSE BELLRI_Bell_Ring ;

  UNTIL Scape OR Return ;


  IF    ( Selected_Line_Type_Code_Number = FALSE )
    AND ( Selected_Symbol_Code_Number    = FALSE )
    AND ( Selected_Line_Level            = FALSE )
    AND ( Selected_Symbol_Level          = FALSE )
    THEN Scape := TRUE ;

END ; (* PROCEDURE LASS_Line_And_Symbol_Selection *)
END.
