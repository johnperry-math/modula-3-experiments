MODULE RandomMatrix EXPORTS Main;

IMPORT IO;
IMPORT Random;

VAR
  i, j: CARDINAL;
  k: CARDINAL;
  M: ARRAY [0..19], [0..39] OF CARDINAL;

BEGIN

  FOR k := 1 TO 1000000000 DO
    M[k MOD 20][k MOD 40] := k;
  END;
  FOR i := 0 TO 19 DO
    IO.Put("[ ");
      FOR j := 0 TO 39 DO
        IO.PutInt(M[i][j]);
        IF j < 39 THEN IO.Put(", "); END;
      END;
    IO.Put(" ]\n");
  END;

END RandomMatrix.
