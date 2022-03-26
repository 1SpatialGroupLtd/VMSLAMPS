[INHERIT ('Inherit_File')]
MODULE PLT240 ;

{ PLT240.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE AP_Add_Point
	( VAR Add_Mode : BOOLEAN ) ;
(**********************************************************************)
VAR

   Easting,
   Northing:		DOUBLE ;
   Value                 : DOUBLE ;

   SString                : String_40 ;
   Arrow_Key             : CHAR    ;
   Number_Of_Characters  : INTEGER ;

   Error,
   Return                : BOOLEAN ;


(********************************************************************)
PROCEDURE GE_Get_Easting ;
(********************************************************************)

BEGIN (* GE_Get_Easting *)

    REPEAT

       CURPOS_Cursor_Position ( 19, 0 ) ;
       ERALIN_Erase_In_Line ('A') ;
       WRITE (' ':10, (Nr_Window_Pts + 1) :2, '.  ') ;
       SELGRA_Select_Graphics ('R') ;
       WRITE (' ':16) ;
       SELGRA_Select_Graphics ('O') ;
       CURPOS_Cursor_Position ( 21, 0 ) ;
       WRITELN ('                      To go out of the add mode press <RETURN> ') ;
       CURPOS_Cursor_Position ( 19, 16 ) ;

       Read_Key_Board ( SString, Number_Of_Characters,
                        Scape, Return, Arrow_Key, 13 ) ;
       Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

       IF NOT (Error OR Scape OR Return)
          THEN BEGIN
                 Easting := Value ;
                 CURPOS_Cursor_Position ( 19, 16 ) ;
                 WRITE (Easting :17:3) ;
                 ERALIN_Erase_In_Line ('R') ;
               END ;

        IF (Error) AND (NOT (Return OR Scape) )
                 THEN BELLRI_Bell_Ring ;

   UNTIL (Scape) OR (Return) OR (NOT Error) ;

   CURPOS_Cursor_Position ( 21, 0 ) ;
   ERALIN_Erase_In_Line  ('A') ;

END ; (* GE_Get_Easting *)

(********************************************************************)
PROCEDURE GN_Get_Northing ;
(********************************************************************)

BEGIN (* GN_Get_Northing *)

    REPEAT

        CURPOS_Cursor_Position ( 19, 45 ) ;
        SELGRA_Select_Graphics ('R') ;
        WRITE (' ':13) ;
        CURPOS_Cursor_Position ( 19, 45 ) ;

        Read_Key_Board ( SString, Number_Of_Characters, Scape,
                                         Return, Arrow_Key, 13 ) ;
        Convert_To_Numeric (SString, Number_Of_Characters, Value, Error) ;

        IF NOT (Error OR Scape OR Return)
                 THEN BEGIN
                      Northing := Value ;
                      CURPOS_Cursor_Position ( 19, 34 ) ;
                      WRITE (Northing :26:3 ) ;
                      ERALIN_Erase_In_Line ('R') ;
                      END ;

        IF (Error) AND (NOT (Return OR Scape))   THEN BELLRI_Bell_Ring ;

    UNTIL (Scape) OR (Return) OR (NOT Error) ;

END ; (* GN_Get_Northing *)



(********************************************************************)
PROCEDURE UW_Update_Window ;
(********************************************************************)

BEGIN (* UW_Update_Window *)

     Nr_Window_Pts := Nr_Window_Pts + 1 ;
     X_Window [Nr_Window_Pts] := Easting ;
     Y_Window [Nr_Window_Pts] := Northing ;

     CURPOS_Cursor_Position ( 19, 0) ;
     WRITELN (' ':10, Nr_Window_Pts :2 , '.  ',
              Easting:17:3, Northing:26:3 );

END ; (* UW_Update_Window *)


{====================================================================}
BEGIN (* AP_Add_Point *)

  GE_Get_Easting ;

  IF NOT (Scape OR Return) THEN GN_Get_Northing ;
  IF NOT (Scape OR Return) THEN UW_Update_Window ;

  IF (Arrow_Key <> ' ')  THEN Scape := FALSE ;
  IF (Return OR Scape)   THEN Add_Mode := FALSE ;

  { clear line 19 }
  CURPOS_Cursor_Position ( 19, 0) ;
  ERALIN_Erase_In_Line  ('A') ;

END ; (* AP_Add_Point *)
END.
