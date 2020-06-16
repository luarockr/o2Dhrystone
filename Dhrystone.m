MODULE Dhrystone;

IMPORT Console, Time, oocRealStr, oocStrings;
(* oocTime *)

CONST
    LOOPS = 12000000;
    Ident1 = 1;
    Ident2 = 2;
    Ident3 = 3;
    Ident4 = 4;
    Ident5 = 5;
    
TYPE
    OneToThirty    = INTEGER; (*INTEGER[1..30];*)
    OneToFifty     = INTEGER; (*INTEGER[1..50];*)
    CapitalLetter  = CHAR; (*['A'..'Z'];*)
    String30       = ARRAY 31 OF CHAR;
    Array1Dim      = ARRAY 51 OF INTEGER;
    Array2Dim      = ARRAY 51, 51 OF INTEGER;
    RecordPtr      = POINTER TO RecordType;
    RecordType     = RECORD
                        PtrComp    : RecordPtr;
                        Discr      : INTEGER;
                        EnumComp   : INTEGER;
                        IntComp    : OneToFifty;
                        StringComp : String30;
             END;

VAR
    IntGlob               : INTEGER;
    BoolGlob              : BOOLEAN;
    Char1Glob, Char2Glob  : CHAR;
    Array1Glob            : Array1Dim;
    Array2Glob            : Array2Dim;
    PtrGlob, PGlobNext    : RecordPtr;

    ch  : CHAR;


(* the following are necessary for single pass compilers *)
(* Stony Brook Modula-2 is not single pass *)

PROCEDURE^ Func1(CharPar1, CharPar2 : CapitalLetter) : INTEGER; (* FORWARD; *)
PROCEDURE^ Func2(VAR StrParI1, StrParI2 : String30) : BOOLEAN; (* FORWARD; *)
PROCEDURE^ Func3(EnumParIn : INTEGER) : BOOLEAN; (* FORWARD; *)
PROCEDURE^ Proc3(VAR PtrParOut : RecordPtr); (* FORWARD; *)
PROCEDURE^ Proc6(EnumParIn : INTEGER;
        VAR EnumParOut : INTEGER); (* FORWARD; *)
PROCEDURE^ Proc7(IntParI1, IntParI2 : OneToFifty;
        VAR IntParOut : OneToFifty); (* FORWARD; *)

(*
PROCEDURE Now() : LONGINT;
VAR ts : oocTime.TimeStamp;
BEGIN
  oocTime.GetTime(ts);
  RETURN ts.msecs;
END Now;
*)

PROCEDURE Proc1(PtrParIn : RecordPtr);
BEGIN
    PtrParIn^.PtrComp^ := PtrGlob^;
    PtrParIn^.IntComp := 5;
    PtrParIn^.PtrComp^.IntComp := PtrParIn^.IntComp;
    PtrParIn^.PtrComp^.PtrComp := PtrParIn^.PtrComp;
    Proc3 (PtrParIn^.PtrComp^.PtrComp);
    IF PtrParIn^.PtrComp^.Discr = Ident1 THEN
    PtrParIn^.PtrComp^.IntComp := 6;
    Proc6(PtrParIn^.EnumComp, PtrParIn^.PtrComp^.EnumComp);
    PtrParIn^.PtrComp^.PtrComp := PtrGlob^.PtrComp;
    Proc7(PtrParIn^.PtrComp^.IntComp, 10, PtrParIn^.PtrComp^.IntComp);
    ELSE
    PtrParIn^ := PtrParIn^.PtrComp^;
    END;
END Proc1;

PROCEDURE Proc2(VAR IntParIO : OneToFifty);
VAR
    IntLoc  : OneToFifty;
    EnumLoc : INTEGER;
BEGIN
    IntLoc := IntParIO + 10;
    LOOP
       IF Char1Glob = 'A' THEN
          DEC(IntLoc);
          IntParIO := IntLoc - IntGlob;
          EnumLoc := Ident1;
       END;
       IF EnumLoc = Ident1 THEN
          EXIT;
       END;
    END
END Proc2;

PROCEDURE Proc3(VAR PtrParOut : RecordPtr);
BEGIN
    IF PtrGlob # NIL THEN
        PtrParOut := PtrGlob^.PtrComp;
    ELSE
        IntGlob := 100;
    END;
    Proc7(10, IntGlob, PtrGlob^.IntComp);
END Proc3;

PROCEDURE Proc4;
VAR
    BoolLoc : BOOLEAN;
BEGIN
    BoolLoc := Char1Glob = 'A';
    BoolLoc := BoolLoc OR BoolGlob;
    Char2Glob := 'B';
END Proc4;

PROCEDURE Proc5;
BEGIN
    Char1Glob := 'A';
    BoolGlob := FALSE;
END Proc5;

PROCEDURE Proc6(EnumParIn : INTEGER; VAR EnumParOut : INTEGER);
BEGIN
    EnumParOut := EnumParIn;
    IF ~Func3(EnumParIn) THEN
        EnumParOut := Ident4;
    END;

    CASE EnumParIn OF
    Ident1:
    EnumParOut := Ident1;
    |
    Ident2:
    IF IntGlob > 100 THEN
        EnumParOut := Ident1;
    ELSE
        EnumParOut := Ident4;
    END;
    |
    Ident3:
    EnumParOut := Ident2;
    |
    Ident4:
    |
    Ident5:
    EnumParOut := Ident3;
    ELSE
    END;
END Proc6;

PROCEDURE Proc7(IntParI1, IntParI2 : OneToFifty; VAR IntParOut : OneToFifty);
VAR
    IntLoc  : OneToFifty;
BEGIN
    IntLoc := IntParI1 + 2;
    IntParOut := IntParI2 + IntLoc;
END Proc7;

PROCEDURE Proc8(VAR Array1Par : Array1Dim;
        VAR Array2Par : Array2Dim;
        IntParI1, IntParI2 : OneToFifty);
VAR
    IntLoc, IntIndex    : OneToFifty;
BEGIN
    IntLoc := IntParI1 + 5;
    Array1Par[IntLoc] := IntParI2;
    Array1Par[IntLoc + 1] := Array1Par[IntLoc];
    Array1Par[IntLoc + 30] := IntLoc;
    FOR IntIndex := IntLoc TO IntLoc + 1 DO
        INC(Array2Par[IntLoc][IntLoc - 1]);
    END;
    Array2Par[IntLoc + 20][IntLoc] := Array1Par[IntLoc];
    IntGlob := 5;
END Proc8;

PROCEDURE Func1(CharPar1, CharPar2 : CapitalLetter) : INTEGER;
VAR
    CharLoc1,CharLoc2:CapitalLetter;
BEGIN
    CharLoc1 := CharPar1;
    CharLoc2 := CharLoc1;
    IF CharLoc2 # CharPar2 THEN
        RETURN Ident1;
    ELSE
        RETURN Ident2;
    END;
END Func1;

PROCEDURE Func2(VAR StrParI1, StrParI2 : String30) : BOOLEAN;
VAR
    IntLoc  : OneToThirty;
    CharLoc : CapitalLetter;
BEGIN
    IntLoc := 1;
    WHILE IntLoc <= 1 DO
    IF (Func1(StrParI1[IntLoc], StrParI2[IntLoc + 1]) = Ident1) THEN
        CharLoc := 'A';
        INC(IntLoc);
    END;
    END;
    IF ((CharLoc >= 'W') & (CharLoc <= 'Z')) THEN
        IntLoc := 7;
    END;
    IF CharLoc = 'X' THEN
        RETURN TRUE;
    ELSE
        IF oocStrings.Compare(StrParI1, StrParI2) > 0 THEN
            INC(IntLoc, 7);
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END;
    END
END Func2;

PROCEDURE Func3(EnumParIn : INTEGER) : BOOLEAN;
VAR
    EnumLoc : INTEGER;
BEGIN
    EnumLoc := EnumParIn;
    IF EnumLoc = Ident3 THEN
        RETURN TRUE;
    END;
    RETURN FALSE;
END Func3;

PROCEDURE Proc0;
VAR
    IntLoc1, IntLoc2, IntLoc3           : OneToFifty;
    CharIndex                   : INTEGER;
    EnumLoc                 : INTEGER;
    String1Loc, String2Loc          : String30;
    starttime, benchtime, nulltime, totaltime   : LONGINT;
    i                       : LONGINT;
	td : REAL;
    realStr : ARRAY 10 OF CHAR;
BEGIN
    Console.String ("Please, wait up to about 60 seconds");
    Console.Ln;
    starttime := Time.Now();
    FOR i := 1 TO LOOPS DO
    END;
    benchtime := Time.Now();
    nulltime := benchtime - starttime;

    NEW(PGlobNext);
    NEW(PtrGlob);
    PtrGlob^.PtrComp  := PGlobNext;
    PtrGlob^.Discr    := Ident1;
    PtrGlob^.EnumComp := Ident3;
    PtrGlob^.IntComp  := 40;
    PtrGlob^.StringComp := "DHRYSTONE PROGRAM, SOME STRING";
    String1Loc := "DHRYSTONE PROGRAM, 1'ST STRING";

    starttime := Time.Now();

    FOR i := 1 TO LOOPS DO
    Proc5;
    Proc4;
    IntLoc1    := 2;
    IntLoc2    := 3;
    String2Loc := "DHRYSTONE PROGRAM, 2'ND STRING";
    EnumLoc    := Ident2;
    BoolGlob   := ~Func2(String1Loc, String2Loc);
    WHILE IntLoc1 < IntLoc2 DO
        IntLoc3 := 5 * IntLoc1 - IntLoc2;
        Proc7(IntLoc1, IntLoc2, IntLoc3);
        INC(IntLoc1);
    END;
    Proc8(Array1Glob, Array2Glob, IntLoc1, IntLoc3);
    Proc1(PtrGlob);
    CharIndex := ORD('A');
    WHILE CharIndex < ORD(Char2Glob) DO
        IF EnumLoc = Func1(CHR(CharIndex), 'C') THEN
        Proc6(Ident1, EnumLoc);
        END;
        INC(CharIndex);
    END;
    IntLoc3 := IntLoc2 * IntLoc1;
    IntLoc2 := IntLoc3 DIV IntLoc1;
    IntLoc2 := 7 * (IntLoc3 - IntLoc2) - IntLoc1;
    Proc2(IntLoc1);
    END;
    benchtime := Time.Now();
    totaltime := benchtime - starttime - nulltime;

    PGlobNext := NIL;
    PtrGlob := NIL;

	td := totaltime / 1000.0;
    Console.String("Dhrystone time for ");
    Console.Int(LOOPS, 0);
    Console.String(" passes = ");
    oocRealStr.RealToStr(td, realStr);
    Console.String(realStr);
    Console.Ln;
    Console.String("This machine benchmarks at ");
    oocRealStr.RealToStr(LOOPS / td, realStr);
    Console.String(realStr);    
    Console.String(" dhrystones/second");
	Console.String(" = ");
    oocRealStr.RealToStr(LOOPS / td / 1000.0, realStr);
    Console.String(realStr);
    Console.String(" Kdhry/second");	
    Console.Ln;
END Proc0;

BEGIN
    Proc0;

    Console.Ln;
    Console.String("Press any key to exit");
    Console.Read(ch);
END Dhrystone.
