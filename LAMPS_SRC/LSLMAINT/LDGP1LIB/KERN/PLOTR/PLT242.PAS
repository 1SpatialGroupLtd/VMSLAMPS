[INHERIT ('Inherit_File')]
MODULE PLT242 ;

{ PLT242.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE EP_Edit_Point
          ( VAR Begin_Scroll_Segment,
                End_Scroll_Segment   : INTEGER ) ;
(********************************************************************)
CONST
  Max_Lines_Per_Page = 10 ;

VAR
    SString               : String_40 ;
    Number_Of_Characters  : INTEGER ;
    Return,
    Error                 : BOOLEAN ;
    Value                 : DOUBLE ;
    I,
    Line,
    Line_Number           : INTEGER ;


(********************************************************************)
PROCEDURE GLN_Get_Line_Number ;
(********************************************************************)

BEGIN (* GLN_Get_Line_Number *)

        CURPOS_Cursor_Position (21, 0) ;
        ERADIS_Erase_Display  ('D') ;
        CURPOS_Cursor_Position (23, 26) ;
        WRITE ('Edit Line Number ? ');

        Read_Key_Board (SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 2 ) ;

        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;
        Line_Number := TRUNC ( Value ) ;

        IF   (Line_Number < 1)
          OR (Line_Number > Nr_Window_Pts )
         THEN Return := TRUE ;

END ;



(********************************************************************)
PROCEDURE CWC_Compute_Write_Coordinates ;
(********************************************************************)
VAR
   Li, I   : INTEGER ;

BEGIN (* CWC_Compute_Write_Coordinates *)

         I := 0 ;
         WHILE    (Begin_Scroll_Segment >  Line_Number)
               OR (End_Scroll_Segment   <  Line_Number)  DO

               BEGIN
               I := I + 1 ;
               Arrow_Key := Down_Arrow_Key ;
               Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                     Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;

               END ;

         IF I <> 0
            THEN BEGIN
                   Li := 8 ;
                   FOR I := Begin_Scroll_Segment TO End_Scroll_Segment DO
                     BEGIN
                        Li := Li + 1 ;
                        CURPOS_Cursor_Position ( Li, 0  ) ;
                        WRITELN (' ':10, I:2, '.  ',
                                          X_Window [I]:17:3,
                                          Y_Window [I]:26:3 ) ;
                     END ;

                  END ;

         Line := Line_Number - Begin_Scroll_Segment + 9 ;

END ; (* CWC_Compute_Write_Coordinates *)



(********************************************************************)
PROCEDURE Get_Window_Point ;
(********************************************************************)

VAR
    E, N    : DOUBLE ;

BEGIN (* Get_Window_Point *)

    E := X_Window [Line_Number] ;
    N := Y_Window [Line_Number] ;

{ Easting }

    SCAWBR_Set_Cursor_And_Write_Black_Real ( E, 3, Line, 19) ;

    Read_Key_Board ( SString, Number_Of_Characters,
                     Scape, Return, Arrow_Key, 13 ) ;

    Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

    IF NOT Error THEN E := Value ;


IF NOT Scape
THEN BEGIN
     CURPOS_Cursor_Position ( Line, 16 ) ;

     WRITE ( E:17:3 ) ;
     ERALIN_Erase_In_Line ('R') ;

        SCAWBR_Set_Cursor_And_Write_Black_Real ( N, 3, Line, 46) ;

        Read_Key_Board ( SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 13 ) ;

        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

        IF NOT Error THEN N := Value ;
     END ;

IF NOT Scape
 THEN BEGIN
      X_Window [Line_Number]  := E ;
      Y_Window [Line_Number]  := N ;
      END ;

END ; (* Get_Window_Point *)


{====================================================================}

BEGIN (* EP_Edit_Point *)

    GLN_Get_Line_Number ;

    IF NOT (Scape OR Return)
       THEN BEGIN
            CWC_Compute_Write_Coordinates ;
            Get_Window_Point ;
            END ;

END ; (* EP_Edit_Point *)
END.
