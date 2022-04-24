MODULE RandomMatrix;

FROM NumberIO IMPORT WriteCard;
FROM StrIO IMPORT WriteString, WriteLn;
FROM RandomNumber IMPORT Randomize, RandomCard;
FROM SYSTEM IMPORT CARDINAL32;

VAR
  i, j: CARDINAL;
  k: CARDINAL32;
  M: ARRAY [0..19], [0..39] OF CARDINAL32;

BEGIN

  FOR k := 1 TO 1000000000 DO
    M[k MOD 20][k MOD 40] := k;
  END;
  FOR i := 0 TO 19 DO
    WriteString("[ ");
      FOR j := 0 TO 39 DO
        WriteCard(M[i][j], 0);
        IF j < 39 THEN WriteString(", "); END;
      END;
    WriteString(" ]");
    WriteLn;
  END;

END RandomMatrix.
