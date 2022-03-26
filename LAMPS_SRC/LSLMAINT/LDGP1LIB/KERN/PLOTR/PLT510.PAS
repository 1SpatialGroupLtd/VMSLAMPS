[INHERIT ('Inherit_File')]
MODULE PLT510 ;

{ PLT510.PAS <> }

(************************************************************************)
[GLOBAL] PROCEDURE FPIW_Find_Point_Inside_Window
                   (VAR Point_In       : BOOLEAN ;
                        X_Test, Y_Test : DOUBLE    ) ;
(************************************************************************)
VAR
     Y_Axis_Intersection  :  Real_Array_Max_Window_Points ;
     Delta_X, Delta_Y     : DOUBLE ;
     I, M, J,
     Start_Point          : INTEGER ;
     Found                : BOOLEAN ;


{=========================================}
PROCEDURE Quick_Sort ( L, R : INTEGER ) ;
{=========================================}

VAR
       I, J   : INTEGER ;
       G      : DOUBLE    ;

BEGIN

     I := L ;
     J := R ;
     G := Y_Axis_Intersection [I] ;

     REPEAT
           WHILE (Y_Axis_Intersection[J] >= G) AND (I < J)   DO   J := J - 1 ;
           Y_Axis_Intersection[I] := Y_Axis_Intersection[J] ;

           WHILE (Y_Axis_Intersection[I] <= G) AND (I < J)   DO   I := I + 1 ;
           Y_Axis_Intersection[J] := Y_Axis_Intersection[I] ;
     UNTIL I = J ;

     Y_Axis_Intersection[I] := G ;

     IF L < (I - 1)   THEN Quick_Sort (L, (I - 1) ) ;
     IF (I + 1) < R   THEN Quick_Sort ((I + 1), R ) ;

END; (* PROCEDURE Quick Sort *)


{====================================================================}

BEGIN (* PROCEDURE Find Point Inside Window *)


    { complete intersection points of line through x in y direction }
    M := 0 ;
    Start_Point := 1 ;

    FOR  I := 2  TO  Nr_Window_Pts  DO
        BEGIN
        IF NOT (   ( (X_Test >= X_Window[I])
                                   AND (X_Test >= X_Window[I-1]) )
                OR ( (X_Test <= X_Window[I])
                                   AND (X_Test <= X_Window[I-1]) )  )
        THEN BEGIN
             IF     (I-1 <> Start_Point)
                AND (X_Window[I-1] = X_Window[Start_Point])
                AND (Y_Window[I-1] = Y_Window[Start_Point])
             THEN Start_Point := I

             ELSE BEGIN
                  Delta_X := X_Window[I] - X_Window[I-1] ;
                  Delta_Y := Y_Window[I] - Y_Window[I-1] ;
                  M := M + 1 ;
                  IF (Delta_X = 0)
                      THEN Y_Axis_Intersection[M] := Y_Window[I-1]
                      ELSE Y_Axis_Intersection[M] :=
                                        X_Test   *  Delta_Y  /  Delta_X
                                     +  Y_Window[I]
                                     -  Delta_Y  /  Delta_X  *  X_Window[I] ;
                  END ;
             END ;
        END ;

    Point_In := FALSE;
    IF M > 0 THEN
       BEGIN
            Quick_Sort ( 1, M ) ;

            IF     (Y_Test > Y_Axis_Intersection[1])
               AND (Y_Test < Y_Axis_Intersection[M])
                   THEN BEGIN
                        Found := FALSE ;
                        I := 1 ;
                          REPEAT
                             I := I + 1 ;
                             IF  ODD (I)
                               AND (Y_Test >= Y_Axis_Intersection[I-1])
                               AND (Y_Test <= Y_Axis_Intersection[I])
                               THEN BEGIN
                                            Point_In := FALSE ;
                                               Found := TRUE  ;
                                    END;
                           IF NOT ODD (I)
                              AND (Y_Test > Y_Axis_Intersection[I-1])
                              AND (Y_Test < Y_Axis_Intersection[I])
                              THEN BEGIN
                                           Point_In := TRUE ;
                                              Found := TRUE ;
                                   END ;
                       UNTIL Found
                       END ;
       END ;

END ; (* PROCEDURE Find Point Inside Window *)
END.
