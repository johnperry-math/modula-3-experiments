GENERIC INTERFACE GenericPermutations(DomainSeq, DomainSet, DomainSeqSeq);

(*
  "Domain" is where the things to permute come from (unused in interface).
  "DomainSeq" is a "Sequence" of "Domain".
  "DomainSet" is a "Set" of "Domain".
  "DomainSeqSeq" is a "Sequence" of "DomainSeq".
*)

PROCEDURE GeneratePermutations(
  READONLY chosen: DomainSeq.T;
  READONLY remaining: DomainSet.T;
  READONLY result: DomainSeqSeq.T
);
(*
  Recursively generates all the permutations of elements
  in the union of "chosen" and "remaining".
  Values in "chosen" have already been chosen;
  values in "remaining" can still be chosen.
  If "remaining" is empty, it adds the permutation to "result".
  Otherwise, it picks each element in "remaining", removes it,
  adds it to "chosen", recursively calls itself,
  then removes the last element of "chosen" and adds it back to "remaining".
  Although the parameters are modified, we can describe them as "READONLY"
  because we do not re-assign them.
*)

END GenericPermutations.