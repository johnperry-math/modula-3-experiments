MODULE Eratosthenes EXPORTS Main;

IMPORT IO;

FROM Math IMPORT sqrt;

CONST
  LastNum    = 1000000;
  ListPrimes = FALSE;

VAR
  a: ARRAY[2..LastNum] OF BOOLEAN;

VAR
  n := LastNum - 2 + 1;

BEGIN

  (* set up *)
  FOR i := FIRST(a) TO LAST(a) DO
    a[i] := TRUE;
  END;

  (* declare a variable local to a block *)
  VAR b := FLOOR(sqrt(FLOAT(LastNum, LONGREAL)));

  (* the block must follow immediately *)
  BEGIN

    (* print primes and mark out composites up to sqrt(LastNum) *)
    FOR i := FIRST(a) TO b DO
      IF a[i] THEN
        IF ListPrimes THEN IO.PutInt(i); IO.Put(" "); END;
        FOR j := i*i TO LAST(a) BY i DO
          IF a[j] THEN
            a[j] := FALSE;
            DEC(n);
          END;
        END;
      END;
    END;

    (* print remaining primes *)
    IF ListPrimes THEN
      FOR i := b + 1 TO LAST(a) DO
        IF a[i] THEN
          IO.PutInt(i); IO.Put(" ");
        END;
      END;
    END;

  END;

  (* report *)
  IO.Put("There are ");         IO.PutInt(n);
  IO.Put(" primes from 2 to "); IO.PutInt(LastNum);
  IO.PutChar('\n');

END Eratosthenes.