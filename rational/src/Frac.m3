MODULE Frac;

IMPORT IO;

TYPE

  REVEAL T = Public BRANDED OBJECT
    num: INTEGER := 0;
    den: INTEGER := 1;
  OVERRIDES
    init := Init;
    fromInt := FromInt;
    abs := Abs;
    opposite := Opposite;
    plus := Plus;
    minus := Minus;
    times := Times;
    dividedBy := DividedBy;
    integerDivision := IntegerDivision;
    equals := Equals;
    notEqualTo := NotEqualTo;
    lessThan := LessThan;
    lessEqual := LessEqual;
    greaterEqual := GreaterEqual;
    greater := Greater;
    isInt := IsInt;
    inc := Inc;
    dec := Dec;
  END;

PROCEDURE Gcd(a, b: CARDINAL): CARDINAL =
VAR
  m := MAX(a, b);
  n := MIN(a, b);
  r: CARDINAL;
BEGIN
  WHILE n # 0 DO
    r := m MOD n;
    m := n;
    n := r;
  END;
  RETURN m;
END Gcd;

PROCEDURE Simplify(VAR a: T) =
VAR
  d := Gcd(ABS(a.num), ABS(a.den));
BEGIN
  a.num := a.num DIV d;
  a.den := a.den DIV d;
END Simplify;

PROCEDURE Init(self: T; a, b: INTEGER): T RAISES { ZeroDenominator } =
BEGIN
  IF (b > 0) THEN
    self.num := a;
    self.den := b;
  ELSIF (b < 0) THEN
    self.num := -a;
    self.den := -b;
  ELSE
    RAISE ZeroDenominator;
  END;
  Simplify(self);
  RETURN self;
END Init;

PROCEDURE FromInt(self: T; a: INTEGER): T =
BEGIN
  self.num := a;
  self.den := 1;
  RETURN self;
END FromInt;

PROCEDURE Abs(self: T): T =
BEGIN
  RETURN NEW(T, num := ABS(self.num), den := self.den);
END Abs;

PROCEDURE Opposite(self: T): T =
BEGIN
  RETURN NEW(T, num := -self.num, den := self.den);
END Opposite;

PROCEDURE Plus(self, other: T): T =
VAR
  result := NEW( T,
      num := self.num * other.den + self.den * other.num,
      den := self.den * other.den
  );
BEGIN
  Simplify(result);
  RETURN result;
END Plus;

PROCEDURE Minus(self, other: T): T =
VAR
  result := NEW( T,
      num := self.num * other.den - self.den * other.num,
      den := self.den * other.den
  );
BEGIN
  Simplify(result);
  RETURN result;
END Minus;

PROCEDURE Times(self, other: T): T =
VAR
  result := NEW( T,
      num := self.num * other.num,
      den := self.den * other.den
  );
BEGIN
  Simplify(result);
  RETURN result;
END Times;

PROCEDURE DividedBy(self, other: T): T RAISES { ZeroDenominator } =
VAR
  result := NEW( T,
      num := self.num * other.den,
      den := self.den * other.num
  );
BEGIN
  IF result.den = 0 THEN RAISE ZeroDenominator; END;
  IF result.den < 0 THEN
    result.num := -result.num;
    result.den := -result.den;
  END;
  Simplify(result);
  RETURN result;
END DividedBy;

PROCEDURE IntegerDivision(self: T; other: INTEGER): T
RAISES { ZeroDenominator } =
VAR
  result := NEW( T, num := self.num, den := self.den * other );
BEGIN
  IF other = 0 THEN RAISE ZeroDenominator; END;
  Simplify(result);
  RETURN result;
END IntegerDivision;

PROCEDURE Equals(self, other: T): BOOLEAN =
BEGIN
  (* this trick works only because we simplify after each operation *)
  RETURN (self.num = other.num) AND (self.den = other.den);
END Equals;

PROCEDURE NotEqualTo(self, other: T): BOOLEAN =
BEGIN
  (* this trick works only because we simplify after each operation *)
  RETURN (self.num # other.num) OR (self.den # other.den);
END NotEqualTo;

PROCEDURE LessThan(self, other: T): BOOLEAN =
BEGIN
  RETURN self.num * other.den < self.den * other.num;
END LessThan;

PROCEDURE LessEqual(self, other: T): BOOLEAN =
BEGIN
  RETURN self.num * other.den <= self.den * other.num;
END LessEqual;

PROCEDURE GreaterEqual(self, other: T): BOOLEAN =
BEGIN
  RETURN self.num * other.den >= self.den * other.num;
END GreaterEqual;

PROCEDURE Greater(self, other: T): BOOLEAN =
BEGIN
  RETURN self.num * other.den > self.den * other.num;
END Greater;

PROCEDURE Inc(self: T; step: CARDINAL) =
BEGIN
  INC(self.num, step * self.den);
END Inc;

PROCEDURE Dec(self: T; step: CARDINAL) =
BEGIN
  DEC(self.num, step * self.den);
END Dec;

PROCEDURE IsInt(self: T): BOOLEAN =
BEGIN
  RETURN self.den = 1;
END IsInt;

PROCEDURE One(): T =
BEGIN
  TRY
    RETURN NEW(T).init(1, 1);
  EXCEPT ZeroDenominator =>
    IO.Put("Something went very wrong.\n");
    RETURN NIL;
  END;
END One;

PROCEDURE Zero(): T =
BEGIN
  TRY
    RETURN NEW(T).init(0, 1);
  EXCEPT ZeroDenominator =>
    IO.Put("Something went very wrong.\n");
    RETURN NIL;
  END;
END Zero;

PROCEDURE PutRat(a: T) =
BEGIN
  IO.PutInt(a.num);
  IF a.den # 1 THEN
    IO.Put(" / "); IO.PutInt(a.den);
  END;
END PutRat;

BEGIN
END Frac.