INTERFACE IntegerRing;

TYPE

  T = INTEGER;

PROCEDURE Nonzero(n: T): BOOLEAN;

PROCEDURE Plus(a, b: T): T;

PROCEDURE Minus(a, b: T): T;

PROCEDURE Times(a, b: T): T;

PROCEDURE Print(a: T);

END IntegerRing.