MODULE TPermutations EXPORTS Main;

IMPORT IO, CharSeq, CharSetTree, CharSeqSeq, CharPermutations;

TYPE

  CHARSET = SET OF CHAR;

CONST

  Uppercase = CHARSET { 'A' .. 'Z' };
  Lowercase = CHARSET { 'a' .. 'z' };

EXCEPTION InvalidChar;

VAR

  n := 5;
  eol: CHAR;
  chosen: CharSeq.T;
  remaining: CharSetTree.T;
  result: CharSeqSeq.T;

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
  IO.Put("Please enter the number of letters: ");
  TRY
    n := IO.GetInt(); eol := IO.GetChar();
    chosen := NEW(CharSeq.T).init(n);
    remaining := NEW(CharSetTree.T).init();
    result := NEW(CharSeqSeq.T).init(Factorial(n));
  
    IO.Put("Please enter "); IO.PutInt(n); IO.Put(" characters: "); IO.PutChar('\n');
    FOR i := 1 TO n DO
      VAR ch := IO.GetChar();
      BEGIN
        IF NOT ( (ch IN Uppercase) OR (ch IN Lowercase) ) THEN
          RAISE InvalidChar;
        END;
        EVAL remaining.insert(ch);
      END;
    END;
  
    CharPermutations.GeneratePermutations(chosen, remaining, result);
  
    IO.Put("Printing "); IO.PutInt(result.size());
    IO.Put(" permutations of "); IO.PutInt(n); IO.Put(" elements \n");
    FOR i := 0 TO result.size() - 1 DO
      FOR j := 0 TO result.get(i).size() - 1 DO
        IO.PutChar(result.get(i).get(j));
      END;
      IO.PutChar('\n');
    END;
  EXCEPT
    IO.Error => IO.Put("Error while reading input; sorry, but we are terminating.\n");
  | InvalidChar => IO.Put("Please enter only letters. Sorry, but we are terminating.\n");
  END;

END TPermutations.
