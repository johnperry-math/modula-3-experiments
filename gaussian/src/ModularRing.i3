INTERFACE ModularRing;

(*
Implements arithmetic modulo a nonzero integer.
Assertions check that the modulus is nonzero.
*)

TYPE

  T = RECORD
    value, modulus: CARDINAL;
  END;

PROCEDURE Init(VAR a: T; value: INTEGER; modulus: CARDINAL);
(* initializes a to the given value and modulus *)

PROCEDURE Nonzero(n: T): BOOLEAN;

PROCEDURE Plus(a, b: T): T;

PROCEDURE Minus(a, b: T): T;

PROCEDURE Times(a, b: T): T;

PROCEDURE Print(a: T; withModulus := FALSE);
(*
   when "withModulus" is "TRUE",
   this adds after "a" the letter "m",
   followed by the modulus
*)

END ModularRing.