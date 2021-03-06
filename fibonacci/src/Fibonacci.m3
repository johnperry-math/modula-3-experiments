MODULE Fibonacci EXPORTS Main;

IMPORT IO;

PROCEDURE IterFib(n: INTEGER): INTEGER =

VAR

  limit := ABS(n);
  prev := 0;
  curr, next: INTEGER;

BEGIN

  (* trivial case *)
  IF n = 0 THEN RETURN 0; END;

  IF n > 0 THEN (* positive case *)

    curr := 1;
    FOR i := 2 TO limit DO
      next := prev + curr;
      prev := curr;
      curr := next;
    END;

  ELSE (* negative case *)

    curr := -1;
    FOR i := 2 TO limit DO
      next := prev - curr;
      prev := curr;
      curr := next;
    END;

  END;

  RETURN curr;

END IterFib;

BEGIN
  IO.PutInt( IterFib(  11 ) ); IO.PutChar('\n');
  IO.PutInt( IterFib( -11 ) ); IO.PutChar('\n');
END Fibonacci.