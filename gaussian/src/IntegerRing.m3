MODULE IntegerRing;

IMPORT IO;

PROCEDURE Nonzero(n: T): BOOLEAN =
BEGIN
  RETURN n # 0;
END Nonzero;

PROCEDURE Plus(a, b: T): T =
BEGIN
  RETURN a + b;
END Plus;

PROCEDURE Minus(a, b: T): T =
BEGIN
  RETURN a - b;
END Minus;

PROCEDURE Times(a, b: T): T =
BEGIN
  RETURN a * b;
END Times;

PROCEDURE Print(a: T) =
BEGIN
  IO.PutInt(a);
END Print;

BEGIN
END IntegerRing.