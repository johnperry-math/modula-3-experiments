MODULE TestTree EXPORTS Main;

IMPORT IntTree AS IT, Random, IO;

VAR

  n: INTEGER;
  t: IT.T := NIL;
  random: Random.T;

PROCEDURE PrintTreeRecursively(READONLY t: IT.T; printHeight: BOOLEAN := FALSE) =
BEGIN
  IF t = NIL THEN IO.Put("Tree is empty\n"); RETURN; END;
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
  IF IT.Parent(t) = NIL THEN IO.Put(" < NIL > ");
  ELSE IO.Put(" < "); IO.PutInt(IT.Value(IT.Parent(t))); IO.Put(" > ");
  END;
  IO.Put(", "); IO.PutInt(IT.Size(t));
  IF printHeight THEN IO.Put(", "); IO.PutInt(IT.Height(t)); END;
  IO.Put(" >");
  IF IT.Right(t) # NIL THEN
    IO.Put(" \\ ( ");
    PrintTreeRecursively(IT.Right(t), printHeight);
    IO.Put(" ) ");
  END;
END PrintTreeRecursively;

CONST

  len = 100;

VAR

  node: IT.T;
  values : ARRAY [1..len] OF INTEGER;
  removeValues : ARRAY [1..len] OF INTEGER;
  (*values := ARRAY [1..len] OF INTEGER { 40, 70, 29, 2, 71, 95, 19, 94, 19, 30 };
  removeValues := values;*)
  (*values := ARRAY [1..len] OF INTEGER { 1, 2, 3 }; *)
  (*values := ARRAY [1..len] OF INTEGER { 1, 2, 3, 4, 5 };
  removeValues := ARRAY [1..len] OF INTEGER { 1, 2, 3, 4, 5 };*)
  fromArray: BOOLEAN := FALSE;

BEGIN

  (* initialization *)
  random := NEW(Random.Default).init();

  (* insert random numbers into the tree *)
  FOR i := 1 TO len DO
    IF fromArray THEN
      n := values[i];
    ELSE
      n := random.integer(0, 100);
    END;
    IO.Put("Adding "); IO.PutInt(n); IO.Put(": ");
    IF IT.Insert(t, n) THEN
      IO.Put("Success!\n\n");
    ELSE
      IO.Put("Nope: already in it!\n\n");
    END;
  END;
  PrintTreeRecursively(t, TRUE);
  IO.PutChar('\n');

  (* find and remove random numbers from the tree *)
  FOR i := 1 TO len DO
    IF fromArray THEN
      n := removeValues[i];
      (*IF i MOD 2 = 1 THEN n := 30;
      ELSE n := 71;
      END; *)
    ELSE
      n := random.integer(0, 100);
    END;
    IO.Put("Has "); IO.PutInt(n); IO.Put("? ");
    node := IT.Find(t, n);
    IF node = NIL THEN
      IO.Put("Not present!\n");
    ELSE
      IO.Put("Yes! Removing.\n");
      t := IT.RemoveNode(node);
      IF t # NIL THEN
        IO.Put("Root: "); IO.PutInt(IT.Value(t)); IO.PutChar('\n');
      ELSE
        IO.Put("Tree is empty\n");
      END;
    END;
    IF fromArray THEN
      EVAL IT.Insert(t, n);
    END;
  END;
  PrintTreeRecursively(t, TRUE);
  IO.PutChar('\n');

END TestTree.