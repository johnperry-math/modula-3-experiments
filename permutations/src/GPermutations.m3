MODULE GPermutations EXPORTS Main;

IMPORT IO, IntSeq, IntSetTree, IntSeqSeq, IntPermutations;

CONST

  n = 7;

VAR

  chosen: IntSeq.T;
  remaining: IntSetTree.T;
  result: IntSeqSeq.T;

PROCEDURE Factorial(n: CARDINAL): CARDINAL =
VAR result := 1;
BEGIN
  FOR i := 2 TO n DO
    result := result * i;
  END;
  RETURN result;
END Factorial;

BEGIN

  (* initial setup *)
  chosen := NEW(IntSeq.T).init(n);
  remaining := NEW(IntSetTree.T).init();
  result := NEW(IntSeqSeq.T).init(Factorial(n));
  FOR i := 1 TO n DO EVAL remaining.insert(i); END;

  IntPermutations.GeneratePermutations(chosen, remaining, result);

  IO.Put("Printing "); IO.PutInt(result.size());
  IO.Put(" permutations of "); IO.PutInt(n); IO.Put(" elements \n");
  FOR i := 0 TO result.size() - 1 DO
    FOR j := 0 TO result.get(i).size() - 1 DO
      IO.PutInt(result.get(i).get(j)); IO.PutChar(' ');
    END;
    IO.PutChar('\n');
  END;

END GPermutations.