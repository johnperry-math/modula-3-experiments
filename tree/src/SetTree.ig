(*
Copyright (C) 2018, John Perry.
Last modified on Sun Nov 4 2018 by John Perry.
*)

(*

  "SetTree" is a generic interface defining sets of "Elem.T"'s,
  implemented as Red/Black Trees.
  
*)

GENERIC INTERFACE SetTree(ElemSet, ElemTree);
(*
  WHERE "Elem.T" is a type that contains

| PROCEDURE Equal  (e1, e2: Elem.T): BOOLEAN;
| PROCEDURE Compare(e1, e2: Elem.T): INTEGER;

  "ElemSet = Set(Elem)"

  "Equal" must be an equivalence relation.

  "Compare" must be a total order. It may be declared with any parameter mode,
  but must have no visible side-effects.

*)

TYPE

  Public = ElemSet.T OBJECT METHODS
    init(): T;
    height(): CARDINAL;
    root(): ElemTree.T;
  END;
  T <: Public;
  Iterator <: ElemSet.Iterator;

(*
The call "self.height()" returns the tree's height.
A red/black tree is not necessarily balanced, so this call traverses the tree.
Invoke it with care.
*)

(*
The call "self.root()" returns the underlying "Tree" object,
in case you wish to do something with it.
*)

(*

  If "self" is an object of type "SetTree.T", the expression

| NEW(SetTree.T).init()

  creates a new, empty set.

*)

END SetTree.