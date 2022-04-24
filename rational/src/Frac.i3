INTERFACE Frac;

(* Implements rational numbers. *)

EXCEPTION ZeroDenominator;
(*
  The module will raise "ZeroDenominator" whenever one attempts to initialize
  a rational with the denominator zero, or to divide by zero.
*)

TYPE

  T <: Public;
  Public = OBJECT
  METHODS
    (* initialization and conversion *)
    init(a, b: INTEGER): T RAISES { ZeroDenominator };
    fromInt(a: INTEGER): T;
    (* unary operators *)
    abs(): T;
    opposite(): T;
    (* binary operators *)
    plus(other: T): T;
    minus(other: T): T;
    times(other: T): T;
    dividedBy(other: T): T RAISES { ZeroDenominator };
    integerDivision(other: INTEGER): T RAISES { ZeroDenominator };
    (* relations *)
    equals(other: T): BOOLEAN;
    notEqualTo(other: T): BOOLEAN;
    lessThan(other: T): BOOLEAN;
    lessEqual(other: T): BOOLEAN;
    greaterEqual(other: T): BOOLEAN;
    greater(other: T): BOOLEAN;
    (* other easily-checked properties *)
    isInt(): BOOLEAN;
    (* inc/decrement *)
    inc(step: CARDINAL := 1);
    dec(step: CARDINAL := 1);
  END;

(*
  The point of most of "T"'s methods will be obvious from the names, but
  "isInt" checks whether the rational is an integer.
*)

PROCEDURE One():  T;
(* returns a new "T" that represents the number 1 *)

PROCEDURE Zero(): T;
(* returns a new "T" that represents the number 0 *)

PROCEDURE PutRat(a: T);
(* prints "a" in the form 'num / den' *)

END Frac.