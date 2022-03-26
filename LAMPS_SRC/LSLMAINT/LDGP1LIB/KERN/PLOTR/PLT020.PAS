[INHERIT ('Inherit_File')]
MODULE PLT020 ;

{ PLT020.PAS <> }

(********************************************************************)
 [GLOBAL] PROCEDURE IDS_Init_Display_Screen ;
(********************************************************************)
VAR
     I, K  : INTEGER ;

BEGIN

     KT_Kern_Title ( Ten_Digit_Number, Title ) ;

     { set scrolling area }
     SETSCR_Set_Scroll ( 20, 24) ;

END ; (* PROCEDURE IDS Init Display Screen *)
END.
