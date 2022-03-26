[INHERIT ('Inherit_File')]
MODULE PLT520 ;

{ PLT520.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE CPLIW_Compute_Part_Line_In_Window
   (    X_Start, Y_Start,
        X_End, Y_End                  : DOUBLE    ;
    VAR X_Start_Point, Y_Start_Point,
        X_End_Point,   Y_End_Point    : DOUBLE    ;
    VAR Find_Part                     : BOOLEAN ;
    VAR More_Part                     : BOOLEAN ) ;
(**********************************************************************)
CONST
     Max_Real             =  1.0E+38 ;

VAR
     X_Intersect,                    { intersection points between window }
     Y_Intersect,                    { lines and the test line }

     Distance_Square      :  Real_Array_Max_Window_Points ;


     X_Test,
     Y_Test               :  DOUBLE ;

     K,
     I,
     J                    :   INTEGER ;
     Nr_Intersect         :  INTEGER ;
     Point_In             :  BOOLEAN ;



{=====================================}
PROCEDURE Sort (L, R   : INTEGER  ) ;
{=====================================}

VAR
   I, J      : INTEGER ;
   X, Y, G   : DOUBLE    ;

BEGIN (* PROCEDURE Sort *)

     I := L ;
     J := R ;
     G := Distance_Square[I] ;
     X := X_Intersect[I] ;
     Y := Y_Intersect[I] ;

     REPEAT
           WHILE (Distance_Square[J] >= G) AND (I < J)   DO  J := J - 1 ;
           Distance_Square[I] := Distance_Square[J] ;
           X_Intersect[I] := X_Intersect[J] ;
           Y_Intersect[I] := Y_Intersect[J] ;

           WHILE (Distance_Square[I] <= G) AND (I < J)   DO  I := I + 1 ;
           Distance_Square[J] := Distance_Square[I] ;
           X_Intersect[J] := X_Intersect[I] ;
           Y_Intersect[J] := Y_Intersect[I] ;
     UNTIL I = J ;

     Distance_Square[I] := G ;
     X_Intersect[I] := X ;
     Y_Intersect[I] := Y ;

     IF L < (I-1)      THEN Sort (L, (I - 1) ) ;
     IF (I+1) < R      THEN Sort ((I + 1), R ) ;

END ; (* PROCEDURE Sort *)


{==================================================}
PROCEDURE IW_Intersection_Window
      ( X_Start, Y_Start, X_Goto, Y_Goto  : DOUBLE ) ;
{==================================================}

CONST
    Round_Off = 0.001;

VAR

    Delta_X,
    Delta_Y,
    X_Test,
    Y_Test,
    Slope_Window,
    Konstant_Window,
    Slope_Line,
    Konstant_Line   :   DOUBLE ;

    N, I, J,
    Start_Point     :   INTEGER ;

BEGIN (* PROCEDURE Intersection Window *)

     N := 0 ;
     Start_Point := 1 ;

     (* find slope and konstant of the line *)
     Delta_X := X_Goto - X_Start ;
     Delta_Y := Y_Goto - Y_Start ;

     IF Delta_X = 0
        THEN BEGIN
             Slope_Line    := Max_Real ;
             Konstant_Line := Y_Start  ;
             END

        ELSE BEGIN
             Slope_Line    := Delta_Y / Delta_X ;
             Konstant_Line := Y_Start - Slope_Line * X_Start ;
             END;

     FOR  I := 2  TO  Nr_Window_Pts  DO
         BEGIN
         IF    (I-1 <> Start_Point)
           AND (X_Window[I-1] = X_Window[Start_Point])
           AND (Y_Window[I-1] = Y_Window[Start_Point])

           THEN Start_Point := I

           ELSE BEGIN
                (* find slope and konstant of the window *)
                Delta_X := X_Window[I] - X_Window[I-1] ;
                Delta_Y := Y_Window[I] - Y_Window[I-1] ;
                IF Delta_X = 0
                THEN BEGIN
                     Slope_Window    := Max_Real ;
                     Konstant_Window := Y_Window[I-1] ;
                     END

                ELSE BEGIN
                     Slope_Window    := Delta_Y / Delta_X ;
                     Konstant_Window :=   Y_Window[I]
                                        - Slope_Window * X_Window[I] ;
                     END;


               (* compute the intersection *)
               IF  Slope_Window <> Slope_Line
               THEN BEGIN

                    IF    (Slope_Window <> Max_Real)
                      AND (Slope_Line   <> Max_Real)
                          THEN BEGIN
                               X_Test := (Konstant_Line - Konstant_Window) /
                                                 (Slope_Window - Slope_Line) ;
                               Y_Test := Slope_Line * X_Test + Konstant_Line ;
                               END ;

                    IF Slope_Window = Max_Real
                          THEN BEGIN
                               Y_Test := Slope_Line * X_Window[I]
                                                             + Konstant_Line ;
                               X_Test := X_Window[I] ;
                               END ;

                    IF Slope_Line = Max_Real
                          THEN BEGIN
                               Y_Test := Slope_Window * X_Goto
                                                           + Konstant_Window ;
                               X_Test := X_Goto ;
                               END ;


                    IF ABS (X_Test - X_Start) <= Round_Off
                                                   THEN  X_Test := X_Start ;
                    IF ABS (X_Test - X_Goto)  <= Round_Off
                                                   THEN  X_Test := X_Goto  ;
                    IF ABS (Y_Test - Y_Start) <= Round_Off
                                                   THEN  Y_Test := Y_Start ;
                    IF ABS (Y_Test - Y_Goto)  <=Round_Off
                                                   THEN  Y_Test := Y_Goto  ;
                    IF ABS (X_Test - X_Window[I-1]) <= Round_Off
                                             THEN  X_Test := X_Window[I-1] ;
                    IF ABS (X_Test - X_Window[I])   <= Round_Off
                                             THEN  X_Test := X_Window[I]   ;
                    IF ABS (Y_Test - Y_Window[I-1]) <=Round_Off
                                             THEN  Y_Test := Y_Window[I-1] ;
                    IF ABS (Y_Test - Y_Window[I])   <= Round_Off
                                             THEN  Y_Test := Y_Window[I]   ;


                    IF (    ( (X_Test >= X_Window[I-1])
                                             AND (X_Test <= X_Window[I]) )
                         OR ( (X_Test <= X_Window[I-1])
                                             AND (X_Test >= X_Window[I]) ) )

                                         AND

                       (    ( (Y_Test >= Y_Window[I-1])
                                            AND (Y_Test <= Y_Window[I]) )
                         OR ( (Y_Test <= Y_Window[I-1])
                                            AND (Y_Test >= Y_Window[I]) ) )

                                         AND

                       (    ( (X_Test >= X_Start) AND (X_Test <= X_Goto) )
                         OR ( (X_Test <= X_Start) AND (X_Test >= X_Goto) ) )

                                         AND

                       (    ( (Y_Test >= Y_Start) AND (Y_Test <= Y_Goto) )
                         OR ( (Y_Test <= Y_Start) AND (Y_Test >= Y_Goto) ) )

                       THEN BEGIN
                            N := N + 1 ;
                            X_Intersect[N] := X_Test ;
                            Y_Intersect[N] := Y_Test ;
                            Distance_Square[N] :=
                                     (X_Start - X_Test) * (X_Start - X_Test)
                                   + (Y_Start - Y_Test) * (Y_Start - Y_Test) ;
                            END ;
                      END ;
                      END ;
              END ;

    IF N > 1
    THEN BEGIN
            Sort (1, N ) ;
            I := 1 ;
            REPEAT
                  IF    (X_Intersect[I] = X_Intersect[I+1])
                    AND (Y_Intersect[I] = Y_Intersect[I+1])
                    THEN BEGIN
                              IF (I + 1) <> (n - 1)
                                 THEN FOR J := I+1 TO N-1 DO
                                          BEGIN
                                          X_Intersect[J] := X_Intersect[J+1] ;
                                          Y_Intersect[J] := Y_Intersect[J+1] ;
                                          END;
                              N := N - 1 ;
                         END ;
                  I := I + 1 ;
            UNTIL  I >= N ;
         END ;

         Nr_Intersect := N ;

END ; (* PROCEDURE Intersection Window *)


{=======================================================================}

BEGIN (* PROCEDURE Compute Part Profiles In Window *)

    Find_Part := FALSE ;
    More_Part := FALSE ;

    { comput the intersection of the profile with the window }
    IW_Intersection_Window (X_Start, Y_Start, X_End, Y_End ) ;

    FOR I := Nr_Intersect DOWNTO 1 DO
          BEGIN
              X_Intersect[I+1] := X_Intersect[I] ;
              Y_Intersect[I+1] := Y_Intersect[I] ;
          END ;
    Nr_Intersect := Nr_Intersect + 2 ;
    X_Intersect[1] := X_Start ;
    Y_Intersect[1] := Y_Start ;
    X_Intersect[Nr_Intersect] := X_End ;
    Y_Intersect[Nr_Intersect] := Y_End ;

    I := 1 ;
    WHILE (I < Nr_Intersect) AND (NOT Find_Part) DO
         BEGIN
            I      := I + 1 ;
            X_Test := (X_Intersect [I-1] + X_Intersect [I]) / 2.0 ;
            Y_Test := (Y_Intersect [I-1] + Y_Intersect [I]) / 2.0 ;

            { check if point in }
            FPIW_Find_Point_Inside_Window (Point_In, X_Test, Y_Test) ;

            IF Point_In
                THEN BEGIN
                       Find_Part     := TRUE              ;
                       X_Start_Point := X_Intersect [I-1] ;
                       Y_Start_Point := Y_Intersect [I-1] ;
                       X_End_Point   := X_Intersect [I]   ;
                       Y_End_Point   := Y_Intersect [I]   ;
                     END ;
         END ;

    IF (I < (Nr_Intersect-1) )
    THEN More_Part := TRUE ;

END ; (* PROCEDURE Compute Part Profiles In Window *)
END.
