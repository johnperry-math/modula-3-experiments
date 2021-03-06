MODULE GaussianElimination EXPORTS Main;

IMPORT IO, ModularRing AS MR, IntMatrix AS IM, ModMatrix AS MM;

CONST

  (* data to set up the matrices *)

  A1 = ARRAY OF INTEGER { 2, 1, 0 };
  A2 = ARRAY OF INTEGER { 1, 2, 0 };
  A3 = ARRAY OF INTEGER { 0, 3, 0 };
  A = ARRAY OF ARRAY OF INTEGER { A1, A2, A3 };

  B1 = ARRAY OF INTEGER {  4,  8, 0, -4, 0 };
  B2 = ARRAY OF INTEGER { -3, -6, 0,  9, 0 };
  B3 = ARRAY OF INTEGER {  1,  3, 5,  7, 2 };
  B4 = ARRAY OF INTEGER {  7,  5, 3,  1, 2 };
  B = ARRAY OF ARRAY OF INTEGER { B1, B2, B3, B4 };

PROCEDURE IntToModArray(READONLY A: IM.T; VAR B: MM.T; mod: CARDINAL) =
(*
   copies a two-dimensional array of integers
   to a two-dimension array of integers modulo "mod"
*)
BEGIN
  B := NEW(MM.T).initDimensions(A.num_rows(), A.num_cols());
  WITH Adata = A.entries(), Bdata = B.entries() DO
    FOR i := FIRST(Adata^) TO LAST(Adata^) DO
      WITH Ai = Adata[i], Bi = Bdata[i] DO
        FOR j := FIRST(Ai) TO LAST(Ai) DO
          MR.Init(Bi[j], Ai[j], mod);
        END;
      END;
    END;
  END;
END IntToModArray;

VAR

  M: IM.T;
  N: MM.T;

BEGIN

  (* triangularize the data in A *)
  M := NEW(IM.T).init(A);
  IO.Put("Initial A:\n");
  IM.PrintMatrix(M);
  IO.PutChar('\n');
  M.triangularize();
  IO.Put("Final A:\n");
  IM.PrintMatrix(M);
  IO.PutChar('\n');
  IO.PutChar('\n');

  (* triangularize the data in B, all computations modulo 46 *)
  M := NEW(IM.T).init(B);
  IntToModArray(M, N, 46);
  IO.Put("Initial B:\n");
  MM.PrintMatrix(N);
  IO.PutChar('\n');
  N.triangularize();
  IO.Put("Final B:\n");
  MM.PrintMatrix(N);
  IO.PutChar('\n');

END GaussianElimination.