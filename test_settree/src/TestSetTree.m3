MODULE TestSetTree EXPORTS Main;

IMPORT Random, IO, IntSetTree AS IST, IntTree AS IT;

PROCEDURE PrintTree(it: IST.Iterator) =
VAR
  a: INTEGER;
BEGIN
  WHILE it.next(a) DO
    IO.PutInt(a); IO.PutChar(' ');
  END;
  IO.PutChar('\n');
END PrintTree;

PROCEDURE PrintTreeRecursively(READONLY t: IT.T; printHeight: BOOLEAN := FALSE) =
BEGIN
  IF IT.Left(t) # NIL THEN
    IO.Put(" ( ");
    PrintTreeRecursively(IT.Left(t), printHeight);
    IO.Put(" ) / ");
  END;
  IO.Put("< ");
  IO.PutInt(IT.Value(t));
  IF IT.IsRed(t) THEN IO.PutChar('R');
  ELSE IO.PutChar('B');
  END;
  IO.Put(", "); IO.PutInt(IT.Size(t));
  IF printHeight THEN IO.Put(", "); IO.PutInt(IT.Height(t)); END;
  IO.Put(" [ ");
  IF IT.Parent(t) = NIL THEN IO.Put("- ] ");
  ELSE IO.PutInt(IT.Value(IT.Parent(t))); IO.Put(" ] ");
  END;
  IO.Put(" >");
  IF IT.Right(t) # NIL THEN
    IO.Put(" \\ ( ");
    PrintTreeRecursively(IT.Right(t), printHeight);
    IO.Put(" ) ");
  END;
END PrintTreeRecursively;

VAR

  t, u: IST.T;
  n: INTEGER;
  random: Random.T;
  fromArray: BOOLEAN := FALSE;
  values := ARRAY [1..10] OF INTEGER { 67, 64, 96, 96, 93, 8, 62, 69, 100, 84 };
  remove := ARRAY [1..10] OF INTEGER { 56, 91, 79, 82, 43, 55, 90, 62, 69, 12 };

BEGIN

  (* initialization *)
  random := NEW(Random.Default).init();
  t := NEW(IST.T).init();
  

  (* insert random numbers into the tree *)
  FOR i := 1 TO 10 DO
    IF fromArray THEN
      n := values[i];
    ELSE
      n := random.integer(0, 100);
    END;
    IO.Put("Adding "); IO.PutInt(n); IO.Put(": ");
    IF t.insert(n) THEN
      IO.Put("Success!\n\n");
    ELSE
      IO.Put("Nope: already in it!\n\n");
    END;
  END;
  PrintTree(t.iterate());
  IO.PutChar('\n');

  PrintTreeRecursively(t.root());
  IO.PutChar('\n');

  (* find and remove random numbers from the tree *)
  FOR i := 1 TO 10 DO
    IF fromArray THEN
      n := remove[i];
    ELSE
      n := random.integer(0, 100);
    END;
    IO.Put("Has "); IO.PutInt(n); IO.Put("? ");
    IF NOT t.delete(n) THEN
      IO.Put("Not present!\n");
    ELSE
      IO.Put("Yes! Removing.\n");
    END;
  END;
  PrintTree(t.iterate());
  IO.PutChar('\n');

  PrintTreeRecursively(t.root(), TRUE);
  IO.PutChar('\n');

  u := t.copy();
  PrintTree(u.iterate());
  IO.PutChar('\n');

END TestSetTree.