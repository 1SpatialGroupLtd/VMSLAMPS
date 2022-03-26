[INHERIT ('Inherit_File')]
MODULE PLT030 ;

{ PLT030.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE GGC_Get_Ground_Coordinates
             ( VAR X,Y,Z       : DOUBLE ;
               VAR Annotation  : String_40 ;
               VAR Error       : BOOLEAN     ) ;
(**********************************************************************)
VAR
   SString      : String_40 ;
   Value       : DOUBLE ;

   N           : INTEGER ;
   J           : INTEGER ;
   I           : INTEGER ;
   First_Time  : BOOLEAN ;

   Finished    : BOOLEAN ;

BEGIN { PROCEDURE GGC_Get_Ground_Coordinates }

     IF Input_Record [1] <> ' '
        THEN Error := TRUE
        ELSE Error := FALSE ;

     IF NOT Error
        THEN BEGIN
                  N := 0 ;
                  I := 0 ;
                  REPEAT
                        N := N + 1 ;
                        SString := Blank_40 ;
                        J := 0 ;
                        First_Time := TRUE ;
                        Finished := FALSE ;
                        REPEAT
                             I := I + 1 ;
                             IF    First_Time
                               AND ( Input_Record [I] <> ' ' )
                               THEN First_Time := FALSE ;
                             IF NOT First_Time
                               THEN BEGIN
                                         J := J + 1 ;
                                         SString [J] := Input_Record [I] ;
                                         IF SString [J] = ' '
                                            THEN BEGIN
                                                      Finished := TRUE ;
                                                      J := J - 1 ;
                                                   END ;
                                      END ;

                             IF   ( J = 40 )
                               OR ( I = Record_Length )
                               THEN Finished := TRUE ;

                        UNTIL  Finished ;

                        IF J > 0
                           THEN Convert_To_Numeric ( SString, J, Value, Error)
                           ELSE Error := TRUE ;

                       IF NOT Error
                          THEN BEGIN
                                    IF N = 1 THEN X := Value ;
                                    IF N = 2 THEN Y := Value ;
                                    IF N = 3 THEN Z := Value ;
                                 END ;
                  UNTIL    Error
                        OR ( N = 3 ) ;

                  { get annotation }
                  IF NOT Error
                     AND ( I < Record_Length )
                     AND ( CAM_Mode = 5 )
                     AND ( Symbol_Annotation <> Blank_4 )
                     THEN BEGIN
                               J := 0 ;
                               REPEAT
                                     I := I + 1 ;
                                     J := J + 1 ;
                                     Annotation [J] := Input_Record [I] ;
                               UNTIL    ( I=Record_Length )
                                     OR ( J=16 ) ;
                            END ;

             END ;

END ; (* PROCEDURE GGC_Get_Ground_Coordinates *)
END.
