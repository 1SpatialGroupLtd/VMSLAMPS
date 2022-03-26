[INHERIT ('Inherit_File')]
MODULE PLT243 ;

{ PLT243.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE IP_Insert_Point
          ( VAR Begin_Scroll_Segment,
                End_Scroll_Segment   : INTEGER ) ;
(**********************************************************************)
CONST
  Max_Lines_Per_Page = 10 ;

VAR

    SString               : String_40 ;
    Number_Of_Characters  : INTEGER ;
    Return,
    Error                 : BOOLEAN ;
    Value                 : DOUBLE ;
    Line,
    Line_Number           : INTEGER ;


(********************************************************************)
PROCEDURE WC_Write_Coordinates ;
(********************************************************************)
VAR
   Li, I   : INTEGER ;

BEGIN (* WC_Write_Coordinates *)

Li := 8 ;
FOR I := Begin_Scroll_Segment TO (End_Scroll_Segment+1) DO
    BEGIN
    Li := Li + 1 ;
    CURPOS_Cursor_Position ( Li, 0  ) ;
    IF (I < Line_Number)
        THEN WRITE (' ':10, I:2 , '.  ', X_Window [I]:17:3,
                                         Y_Window [I]:26:3 ) ;
    IF (I = Line_Number)
     THEN WRITE (' ':10, I:2 , '.', ' ':70) ;
    IF (I > Line_Number)
     THEN WRITE (' ':10, I:2 , '.  ', X_Window [I-1]:17:3,
                                      Y_Window [I-1]:26:3 ) ;
    END ;

END ; (* WC_Write_Coordinates *)


(********************************************************************)
PROCEDURE Get_Window_Point ;
(********************************************************************)

VAR
    E, N  : DOUBLE ;
    I     : INTEGER ;

BEGIN (* Get_Window_Point *)

E := 0.0 ;
N := 0.0 ;

{ Easting }

        CURPOS_Cursor_Position ( Line, 16 ) ;
        SELGRA_Select_Graphics ('R') ;
        WRITE (' ':16) ;
        CURPOS_Cursor_Position ( Line, 16 ) ;

        Read_Key_Board ( SString, Number_Of_Characters,
                   Scape, Return, Arrow_Key, 13 ) ;
        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

        IF NOT (Error OR Scape OR Return)
                 THEN BEGIN
                      E := Value ;
                      CURPOS_Cursor_Position ( Line, 16 ) ;
                      WRITE (E:17:3 ) ;
                      ERALIN_Erase_In_Line ('R') ;
                      END ;

        IF (Error) AND (NOT (Return OR Scape))
         THEN BELLRI_Bell_Ring ;

{ Northing }
IF NOT (Scape OR Return)
 THEN BEGIN

        CURPOS_Cursor_Position ( Line, 45) ;
        SELGRA_Select_Graphics ('R') ;
        WRITE (' ':13) ;
        CURPOS_Cursor_Position ( Line, 45 ) ;

        Read_Key_Board ( SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 13 ) ;
        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

        IF NOT (Error OR Scape OR Return)
         THEN N := Value ;

        IF (Error) AND (NOT (Return OR Scape))   THEN BELLRI_Bell_Ring ;

     END ;

IF NOT (Scape OR Return)
THEN BEGIN
        FOR I := Nr_Window_Pts + 1 DOWNTO Line_Number + 1 DO
            BEGIN
                 X_Window [I] := X_Window [I-1];
                 Y_Window [I] := Y_Window [I-1];
            END;

        X_Window [Line_Number]  := E ;
        Y_Window [Line_Number]  := N ;
        Nr_Window_Pts := Nr_Window_Pts + 1 ;

        Arrow_Key := Down_Arrow_Key ;
        End_Scroll_Segment := Nr_Window_Pts - Max_Lines_Per_Page ;
        Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                   Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;

     END ;

END ; (* Get_Window_Point *)


{====================================================================}

BEGIN (* IP_Insert_Point *)

        CURPOS_Cursor_Position (21, 0) ;
        ERADIS_Erase_Display  ('D') ;
        CURPOS_Cursor_Position (23, 24) ;
        WRITE ('Insert Line Number ? ');

        Read_Key_Board (SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 2 ) ;
        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;
        Line_Number := TRUNC (Value ) ;

        IF   (Line_Number < 1)
          OR (Line_Number > Nr_Window_Pts )
         THEN Error := TRUE ;

   IF NOT (Scape OR Return OR Error)
   THEN BEGIN

        WHILE    (Begin_Scroll_Segment >  Line_Number)
              OR (End_Scroll_Segment   <  Line_Number)  DO
              BEGIN
              Arrow_Key := Down_Arrow_Key ;
              Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                   Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;
              END ;

        WC_Write_Coordinates ;

        Line := Line_Number - Begin_Scroll_Segment + 9 ;
        Get_Window_Point ;

        END ;

END ; (* IP_Insert_Point *)
END.
