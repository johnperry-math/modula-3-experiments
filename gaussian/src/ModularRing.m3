MODULE ModularRing;

IMPORT IO;

PROCEDURE Init(VAR a: T; v: INTEGER; m: CARDINAL) =
BEGIN
  <* ASSERT m # 0 *>
  a.value := v MOD m;
  a.modulus := m;
END Init;

PROCEDURE Nonzero(n: T): BOOLEAN =
BEGIN
  RETURN n.value # 0;
END Nonzero;

PROCEDURE Plus(a, b: T): T =
VAR
  result: T;
BEGIN
  <* ASSERT a.modulus = b.modulus *>
  <* ASSERT a.modulus # 0 *>
  result.value := (a.value + b.value) MOD a.modulus;
  result.modulus := a.modulus;
  RETURN result;
END Plus;

PROCEDURE Minus(a, b: T): T =
VAR
  result: T;
BEGIN
  <* ASSERT a.modulus = b.modulus *>
  <* ASSERT a.modulus # 0 *>
  WITH mod = a.modulus DO
    result.value := (a.value + mod - b.value) MOD mod;
    result.modulus := mod;
  END;
  RETURN result;
END Minus;

PROCEDURE Times(a, b: T): T =
VAR
  result: T;
BEGIN
  <* ASSERT a.modulus = b.modulus *>
  result.value := (a.value * b.value) MOD a.modulus;
  result.modulus := a.modulus;
  RETURN result;
END Times;

PROCEDURE Print(a: T; withModulus: BOOLEAN) =
BEGIN
  IO.PutInt(a.value);
  IF withModulus THEN
    IO.PutChar('m'); IO.PutInt(a.modulus);
  END;
END Print;

BEGIN
END ModularRing.