GENERIC INTERFACE Matrix(RingElem);

(*
  "RingElem" must export the following:
  - a type T;
  - procedures
    + "Nonzero(a: T): BOOLEAN", which indicates whether "a" is nonzero;
    + "Minus(a, b: T): T" and "Times(a, b: T): T",
      which return the results you'd guess from the procedures' names; and
    + "Print(a: T)", which does what the name implies.
*)

TYPE

  T <: Public;

  Public = OBJECT
  METHODS
    init(READONLY data: ARRAY OF ARRAY OF RingElem.T): T;
    initDimensions(m, n: CARDINAL): T;
    num_rows(): CARDINAL;
    num_cols(): CARDINAL;
    entries(): REF ARRAY OF ARRAY OF RingElem.T;
    triangularize();
  END;

(*
Use "init" to copy the entries in "data"; returns "self".

Use "initDimensions" for an mxn matrix of random entries.

"num_rows" returns the number of rows in "self".

"num_cols" returns the number of columns in "self".

"entries" returns the entries in "self".

"triangularize" performs Gaussian elimination in the context of a ring.
      We can add scalar multiples of rows,
      and we can swap rows, but we may lack multiplicative inverses,
      so we cannot necessarily obtain 1 as a row's first entry.

*)


  PROCEDURE PrintMatrix(m: T);
  (* prints the matrix row-by-row; sorry, no special padding to line up columns *)

END Matrix.