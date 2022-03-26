[INHERIT ('Inherit_File')]
MODULE PLT241 ;

{ PLT241.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE KP_Kill_Point ;
(**********************************************************************)
VAR
    Arrow_Key             : CHAR ;
    SString               : String_40 ;
    Number_Of_Characters  : INTEGER ;
    Return,
    Error                 : BOOLEAN ;
    Value                 : DOUBLE ;

    I, K,
    Line_1,
    Line_2                : INTEGER ;

BEGIN (* KP_Kill_Point *)

        CURPOS_Cursor_Position (21, 0) ;
        ERADIS_Erase_Display  ('D') ;
        CURPOS_Cursor_Position (23, 13) ;
        WRITE ('  Kill Window Points From Line         To Line           ' ) ;
        CURPOS_Cursor_Position (23, 47) ;

        Read_Key_Board (SString, Number_Of_Characters, Scape,
                        Return, Arrow_Key, 4 ) ;
        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;
        Line_1 := TRUNC ( Value ) ;

        IF   (Line_1 < 1)
          OR (Line_1 > Nr_Window_Pts )
         THEN Error := TRUE ;

   IF NOT (Scape OR Return OR Error)
   THEN BEGIN
          CURPOS_Cursor_Position ( 23, 13) ;
          ERALIN_Erase_In_Line ('A') ;
          WRITE ('  Kill Window Points From Line    ', Line_1,
                                                         '    To Line    ' ) ;

          Read_Key_Board (SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 4 ) ;
          Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;
          Line_2 := TRUNC (Value ) ;

          IF (Line_2 < Line_1)
           THEN Error := TRUE ;
        END ;

   IF NOT (Scape OR Return OR Error)
   THEN BEGIN
          CURPOS_Cursor_Position ( 23, 13 ) ;
          WRITELN ('  KILL WINDOW POINTS FROM LINE    ', Line_1:2,
                        '    TO LINE    ', Line_2:2,'    ' ) ;
          WRITE   ('                             ARE YOU SURE (Y/N) ?  ');

          Read_Key_Board (SString, Number_Of_Characters, Scape,
                                        Return, Arrow_Key, 1 ) ;

          IF (SString [1] IN ['Y', 'y'])
          THEN BEGIN
               IF Line_2 > Nr_Window_Pts
                  THEN Line_2 := Nr_Window_Pts ;

               FOR I := (Line_2 + 1) TO Nr_Window_Pts DO
                  BEGIN
                     K := Line_1 - 1 + I - Line_2 ;
                     X_Window [K] := X_Window [I];
                     Y_Window [K] := Y_Window [I];
                  END;

               Nr_Window_Pts := Nr_Window_Pts - (Line_2 - Line_1) - 1 ;
              END;
       END ;

END ; (* KP_Kill_Point *)
END.
