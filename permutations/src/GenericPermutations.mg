GENERIC MODULE GenericPermutations(Domain, DomainSeq, DomainSet, DomainSeqSeq);

(*
  "Domain" is where the things to permute come from.
  "DomainSeq" is a "Sequence" of "Domain".
  "DomainSet" is a "Set" of "Domain".
  "DomainSeqSeq" is a "Sequence" of "DomainSeq".
*)

PROCEDURE GeneratePermutations(
  READONLY chosen: DomainSeq.T;
  READONLY remaining: DomainSet.T;
  READONLY result: DomainSeqSeq.T
) =

(*
  Recursively generates all the permutations of elements
  in the union of "chosen" and "remaining".
  Values in "chosen" have already been chosen;
  values in "remaining" can still be chosen.
  If "remaining" is empty, it adds the permutation to "result".
  Otherwise, it picks each element in "remaining", removes it,
  adds it to "chosen", recursively calls itself,
  then removes the last element of "chosen" and adds it back to "remaining".
*)

VAR

  r: Domain.T; (* element added to permutation *)

  iterator := remaining.iterate(); (* to iterate through remaining elements *)

  values := NEW(DomainSeq.T).init(remaining.size());
  (* used to store values for iteration *)

BEGIN

  (* cannot safely modify a set while iterating, so we'll store the values *)
  WHILE iterator.next(r) DO values.addhi(r); END;

  (* now loop through the stored values *)
  FOR i := 0 TO values.size() - 1 DO

    (* remove from "remaining" and add to "chosen" *)
    r := values.get(i);
    EVAL remaining.delete(r);
    chosen.addhi(r);

    (* if this is not the last remaining elements, call recursively *)
    IF remaining.size() # 0 THEN
      GeneratePermutations(chosen, remaining, result);
    ELSE
      (* we have a new permutation; add a copy to the set *)
      VAR newPerm := NEW(DomainSeq.T).init(chosen.size());
      BEGIN
        FOR i := 0 TO chosen.size() - 1 DO
          newPerm.addhi(chosen.get(i));
        END;
        result.addhi(newPerm);
      END;
    END;

    (* move r back from chosen *)
    EVAL remaining.insert(chosen.remhi());

  END;

END GeneratePermutations;

BEGIN
END GenericPermutations.