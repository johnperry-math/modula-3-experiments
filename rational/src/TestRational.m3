MODULE TestRational EXPORTS Main;

IMPORT IO, Frac AS R, Word;

FROM Math IMPORT sqrt;

PROCEDURE PutBool(b: BOOLEAN) =
BEGIN
  IF b THEN IO.Put("true");
  ELSE IO.Put("false");
  END;
END PutBool;

VAR

  a, b: R.T;

  n: Word.T := 2;
  limit: Word.T := 1;

BEGIN

  TRY
    a := NEW(R.T).init(2,3);
    b := NEW(R.T).init(-3,4);
  EXCEPT | R.ZeroDenominator =>
    IO.Put("Zero division!\n");
  END;

  R.PutRat(a); IO.Put(" op "); R.PutRat(b); IO.Put(" = \n");

  IO.Put("  + : "); R.PutRat(a.plus(b));  IO.PutChar('\n');
  IO.Put("  - : "); R.PutRat(a.minus(b)); IO.PutChar('\n');
  IO.Put("  * : "); R.PutRat(a.times(b)); IO.PutChar('\n');

  TRY
    IO.Put("  /: "); R.PutRat(a.dividedBy(b)); IO.PutChar('\n');
  EXCEPT | R.ZeroDenominator =>
    IO.Put("Zero division\n");
  END;

  IO.Put("  <  : "); PutBool(a.lessThan(b));     IO.PutChar('\n');
  IO.Put("  <= : "); PutBool(a.lessEqual(b));    IO.PutChar('\n');
  IO.Put("  >= : "); PutBool(a.greaterEqual(b)); IO.PutChar('\n');
  IO.Put("  >  : "); PutBool(a.greater(b));      IO.PutChar('\n');

  IO.PutChar('\n');

  IO.Put("Increasing "); R.PutRat(a); IO.Put(" by\n");
  IO.Put("  1 gives "); a.inc(1); R.PutRat(a); IO.PutChar('\n');
  IO.Put("  3 gives "); a.inc(3); R.PutRat(a); IO.PutChar('\n');

  IO.Put("Decreasing "); R.PutRat(a); IO.Put(" by\n");
  IO.Put("  1 gives "); a.dec(1); R.PutRat(a); IO.PutChar('\n');
  IO.Put("  3 gives "); a.dec(3); R.PutRat(a); IO.PutChar('\n');

  limit := Word.LeftShift(limit, 19);
  TRY
    WHILE n < limit DO
        VAR
          sum := NEW(R.T).init(1, n);
          maxFac := FLOOR(sqrt(FLOAT(n, LONGREAL)));
        BEGIN
          FOR i := 2 TO maxFac DO
            IF n MOD i = 0 THEN
              sum := sum.plus(NEW(R.T).init(1, i))
                        .plus(NEW(R.T).init(1, n DIV i));
            END;
          END;
          IF sum.isInt() THEN
            IO.Put("sum of reciprocal factors of "); IO.PutInt(n);
            IO.Put(" is exactly "); R.PutRat(sum);
            IF sum.equals(R.One()) THEN
              IO.Put(" perfect!");
            END;
            IO.PutChar('\n');
          END;
        END;
      INC(n, 2);
    END;
  EXCEPT R.ZeroDenominator =>
    IO.Put("Something went very wrong\n");
  END;

END TestRational.