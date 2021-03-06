MODULE Permutations EXPORTS Main;

IMPORT IO, IntSeq;

CONST n = 3;

TYPE Domain = SET OF [ 1.. n ];

VAR

  chosen: IntSeq.T;
  values := Domain { };

PROCEDURE GeneratePermutations(VAR chosen: IntSeq.T; remaining: Domain) =
(*
  Recursively generates all the permutations of elements
  in the union of "chosen" and "values".
  Values in "chosen" have already been chosen;
  values in "remaining" can still be chosen.
  If "remaining" is empty, it prints the sequence and returns.
  Otherwise, it picks each element in "remaining", removes it,
  adds it to "chosen", recursively calls itself,
  then removes the last element of "chosen" and adds it back to "remaining".
*)
BEGIN
  FOR i := 1 TO n DO
    (* check if each element is in "remaining" *)
    IF i IN remaining THEN
      (* if so, remove from "remaining" and add to "chosen" *)
      remaining := remaining - Domain { i };
      chosen.addhi(i);
      IF remaining # Domain { } THEN
        (* still something to process? do it *)
        GeneratePermutations(chosen, remaining);
      ELSE
        (* otherwise, print what we've chosen *)
        FOR j := 0 TO chosen.size() - 2 DO
          IO.PutInt(chosen.get(j)); IO.Put(", ");
        END;
        IO.PutInt(chosen.gethi());
        IO.PutChar('\n');
      END;
      (* add "i" back to "remaining" and remove from "chosen" *)
      remaining := remaining + Domain { i };
      EVAL chosen.remhi();
    END;
  END;
END GeneratePermutations;

BEGIN

  (* initial setup *)
  chosen := NEW(IntSeq.T).init(n);
  FOR i := 1 TO n DO values := values + Domain { i }; END;

  GeneratePermutations(chosen, values);

END Permutations.