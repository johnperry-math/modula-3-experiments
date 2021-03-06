MODULE DistinctObjects EXPORTS Main;

IMPORT IO, Random;

VAR

  random := NEW(Random.Default).init();

TYPE

  T = RECORD (* value will initialize to 2 unless otherwise specified *)
    value: INTEGER := 2;
  END;

CONST Size = 3;

VAR

  (* initialize records *)
  t1 := T { 3 };
  t2 := T { 4 };
  t3 :  T;       (* t3's value will be default (2) *)

  (* initialize a reference to T with value 100 *)
  tr := NEW(REF T, value := 100);

  (* initialize an array of records *)
  a := ARRAY[1..Size] OF T { t1, t2, t3 };
  (* initialize an array of integers *)
  b := ARRAY[1..Size] OF INTEGER { -9, 2, 6 };
  (* initialize an array of references to a record -- NOT copied! *)
  c := ARRAY[1..Size] OF REF T { tr, tr, tr };

BEGIN

  (* display the data *)
  FOR i := 1 TO Size DO
    IO.PutInt(a[i].value); IO.Put(" , ");
    IO.PutInt(b[i]);       IO.Put(" , ");
    IO.PutInt(c[i].value); IO.Put(" ; ");
  END;
  IO.PutChar('\n');

  (* re-initialize a's data to random integers *)
  FOR i := 1 TO Size DO a[i].value := random.integer(-10, 10); END;
  (* modify "one" element of c *)
  c[1].value := 0;
  (* display the data *)
  FOR i := 1 TO Size DO
    IO.PutInt(a[i].value); IO.Put(" , ");
    IO.PutInt(b[i]);       IO.Put(" , ");
    IO.PutInt(c[i].value); IO.Put(" ; ");
  END;
  IO.PutChar('\n');

END DistinctObjects.