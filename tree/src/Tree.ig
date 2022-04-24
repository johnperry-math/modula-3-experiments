(*
Copyright (C) 2018, John Perry.
Last modified on Sun Nov  4 2018 by John Perry.
     modified on Wed Oct 31 2018 by John Perry.
*)

GENERIC INTERFACE Tree(Elem);

(*
  Implementation of a generic red/black tree
  that stores elements of type "Elem.T", where "Elem" contains

| CONST Brand = <text-constant>;
| PROCEDURE Compare(e1, e2: Elem.T): [-1..1];

  "Brand" must be a text constant. It will be used to construct a brand for
  any generic types instantiated with the "Tree" interface. For a
  non-generic interface, we recommend choosing the name of the interface.

  "Compare" must be a total order. It may be declared with any parameter mode,
  but must have no visible side-effects.

  The tree inserts and preserves elements in-order from smallest to largest,
  where the ordering is determined by a "Compare" function
  that should return -1 when e1 < e2, 1 when e1 > e2, and 0 otherwise.
  
*)

CONST Brand = "(Tree " & Elem.Brand & ")";

TYPE

  T <: REFANY;

(*
  A "Tree.T" actually represents a node of a tree.
  This may change for insertion or deletion,
  because the (sub)tree's root may change.
  Any node has three pieces of information:
  the value (type Elem.T),
  the size (number of nodes in the (sub)tree),
  and the height (maximum number of nodes until a leaf, inclusive).
*)

(* Creation procedures. *)

PROCEDURE Tree(READONLY root: Elem.T): T;
(* Creates a new tree, with root as its root element. *)

PROCEDURE Copy(READONLY src: T; VAR dst: T);
(* Copies "src" onto "dst". This recursively copies "src"'s subtree, as well. *)

PROCEDURE FromArray(READONLY e: ARRAY OF Elem.T): T;
(*
Creates a new tree, whose entries come from "e".
The elements will be sorted into the correct order.
*)

(* Properties: the tree is unchanged by these procedures. *)

PROCEDURE Member(READONLY t: T; READONLY e: Elem.T): BOOLEAN;
(* Returns "TRUE" if and only if "e" is an element of "t". *)

PROCEDURE Find(READONLY t: T; READONLY e: Elem.T): T;
(*
Returns a node of "t" that contains "e", if one exists.
Otherwise, returns "NIL".
*)

PROCEDURE First(READONLY t: T): T;
(* Returns the node in "t" that contains its smallest value. *)

PROCEDURE Last(READONLY t: T): T;
(* Returns the node in "t" that contains its largest value. *)

PROCEDURE Prev(READONLY t: T): T;
(*
Returns the tree element that precedes "t".
This is different from "Left" in that it returns the next smallest element;
it follows "Left"'s right children until it would fall off the tree.
*)

PROCEDURE Succ(READONLY t: T): T;
(*
Returns the tree element that succeeds "t".
This is different from "Right" in that it returns the next larger element;
it follows "Right"'s left children until it would fall off the tree.
*)

PROCEDURE Left(READONLY t: T): T;
(*
  Returns "t"'s left child.
  This is different from "Prev" in that the result of this function
  might not be the next smaller element in the tree.
*)

PROCEDURE Right(READONLY t: T): T;
(*
  Returns "t"'s right child.
  This is different from "Succ" in that the result of this function
  might not be the next larger element in the tree.
*)

PROCEDURE Parent(READONLY t: T): T;
(*
  Returns "t"'s parent. If "t" is "NIL" then this returns "NIL".
*)

PROCEDURE IsBlack(READONLY t: T): BOOLEAN;
(*
Returns "TRUE" if and only if this tree node is black.
Works also for leaves ("NIL").
*)

PROCEDURE IsRed(READONLY t: T): BOOLEAN;
(*
Returns "TRUE" if and only if this tree node is red.
Works also for leaves ("NIL").
*)

PROCEDURE Value(READONLY t: T): Elem.T;
(* Returns the value stored at "t". *)

PROCEDURE Size(READONLY t: T): CARDINAL;
(*
Returns the number of nodes in this (sub)tree, including "t".
Each node in the tree stores the size of its subtree,
so this is an O(1) operation.
*)

PROCEDURE Height(READONLY t: T): CARDINAL;
(*
Returns the height of this (sub)tree, including "t".
Nodes in the tree do not store the height of their subtrees,
so this is an O(n) operation, where n is the number of elements in the tree.
*)

PROCEDURE Root(n: T): T;
(* Find the root node of the tree that contains "n" as a node. *)

(* Operations: the tree is changed by these procedures. *)

PROCEDURE Insert(VAR t: T; READONLY e: Elem.T): BOOLEAN;
(* Insert "e" into "t". *)

PROCEDURE ReplaceNode(VAR n, c: T);
(* Replace "n" by "c" in the tree. *)

PROCEDURE RemoveNode(VAR n: T): T;
(*
Removes the node "n" from its set, and returns the new root.
Automatically adjusts the root in case "n" is the root.
If you don't know the node you want to remove,
but you do know the element it contains, "Find" it first.
*)

END Tree.