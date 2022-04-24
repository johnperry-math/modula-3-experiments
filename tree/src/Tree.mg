GENERIC MODULE Tree(Elem);

(*
Last modified on Sun Nov  4 2018 by John Perry.
     modified on Wed Oct 31 2018 by John Perry.
*)

TYPE

  RB = { RED, BLACK };
  (* whether a node is red or black *)

  REVEAL T = BRANDED OBJECT

    value: Elem.T;

    parent, left, right: T := NIL;

    kind: RB := RB.BLACK;

    size: CARDINAL := 1;

  END;
  (* This is a tree node, which is always at least a (sub)tree with 1 element. *)

VAR

  DeleteCase1: PROCEDURE(n: T);

PROCEDURE Tree(READONLY e: Elem.T): T =
BEGIN
  RETURN NEW(T, value := e);
END Tree;

PROCEDURE Copy(READONLY src: T; VAR dst: T) =
BEGIN
  IF dst = NIL THEN
    dst := Tree(src.value);
  ELSE
    dst.value := src.value;
  END;
  dst.kind := src.kind;
  dst.size := src.size;
  IF src.left # NIL THEN
    Copy(src.left, dst.left);
    dst.left.parent := dst;
  END;
  IF src.right # NIL THEN
    Copy(src.right, dst.right);
    dst.right.parent := dst;
  END;
END Copy;

PROCEDURE Member(READONLY t: T; READONLY e: Elem.T): BOOLEAN =
VAR
  node: T := t;
  comparison: INTEGER := 2;
BEGIN
  WHILE comparison # 0 AND node # NIL DO
    comparison := Elem.Compare(node.value, e);
    IF comparison = -1 THEN
      node := node.right;
    ELSIF comparison = 1 THEN
      node := node.left;
    END;
  END;
  RETURN comparison = 0;
END Member;

PROCEDURE Find(READONLY t: T; READONLY e: Elem.T): T =
VAR
  node: T := t;
  comparison: INTEGER := 2;
BEGIN
  WHILE comparison # 0 AND node # NIL DO
    comparison := Elem.Compare(node.value, e);
    IF comparison = -1 THEN
      node := node.right;
    ELSIF comparison = 1 THEN
      node := node.left;
    END;
  END;
  IF comparison = 0 THEN RETURN node;
  ELSE RETURN NIL;
  END;
END Find;

PROCEDURE First(READONLY t: T): T =
VAR
  result: T := t;
BEGIN
  IF result # NIL THEN
    WHILE result.left # NIL DO
      result := result.left;
    END;
  END;
  RETURN result;
END First;

PROCEDURE Last(READONLY t: T): T =
VAR
  result: T := t;
BEGIN
  IF result # NIL THEN
    WHILE result.right # NIL DO
      result := result.right;
    END;
  END;
  RETURN result;
END Last;

PROCEDURE Prev(READONLY t: T): T =
BEGIN
  IF t = NIL THEN RETURN t;
  ELSIF t.left # NIL THEN
    RETURN Last(t.left);
  ELSE
    VAR
      curr := t.parent;
      prev := t;
    BEGIN
      WHILE curr # NIL AND prev = curr.left DO
        prev := curr;
        curr := curr.parent;
      END;
      RETURN curr;
    END;
  END;
END Prev;

PROCEDURE Succ(READONLY t: T): T =
BEGIN
  IF t = NIL THEN RETURN t;
  ELSIF t.right # NIL THEN
    RETURN First(t.right);
  ELSE
    VAR
      curr := t.parent;
      prev := t;
    BEGIN
      WHILE curr # NIL AND prev = curr.right DO
        prev := curr;
        curr := curr.parent;
      END;
      RETURN curr;
    END;
  END;
END Succ;

PROCEDURE Left(READONLY t: T): T =
BEGIN
  RETURN t.left;
END Left;

PROCEDURE Right(READONLY t: T): T =
BEGIN
  RETURN t.right;
END Right;

PROCEDURE Parent(READONLY t: T): T =
VAR
  result := t;
BEGIN
  IF result # NIL THEN result := result.parent; END;
  RETURN result;
END Parent;

PROCEDURE Value(READONLY t: T): Elem.T =
BEGIN
  RETURN t.value;
END Value;

(*
Rotates left: n.right moves to n's position; n moves to n.right.left.
If n.right.left exists, it is moved to n.right.
Height and size are adjusted.
*)
PROCEDURE RotateLeft(n: T) =
VAR
  newNode: T := n.right;
  parent: T := n.parent;
  a: CARDINAL := newNode.size;
  b: CARDINAL := 1;
BEGIN
  (* adjust sizes *)
  IF newNode.left # NIL THEN DEC(a, newNode.left.size); END;
  IF n.left # NIL THEN INC(b, n.left.size); END;
  INC(newNode.size, b);
  DEC(n.size, a);
  (* rotate *)
  n.right := newNode.left;
  newNode.left := n;
  n.parent := newNode;
  IF n.right # NIL THEN
    n.right.parent := n;
  END;
  IF parent # NIL THEN
    IF n = parent.left THEN
      parent.left := newNode;
    ELSIF n = parent.right THEN
      parent.right := newNode;
    END;
  END;
  newNode.parent := parent;
END RotateLeft;

(*
Rotates right: n.left moves to n's position; n moves to n.left.right.
If n.left.right exists, it is moved to n.left.
Height and size are adjusted.
*)
PROCEDURE RotateRight(n: T) =
VAR
  newNode: T := n.left;
  parent: T := n.parent;
  a: CARDINAL := newNode.size;
  b: CARDINAL := 1;
BEGIN
  (* adjust sizes *)
  IF newNode.right # NIL THEN DEC(a, newNode.right.size); END;
  IF n.right # NIL THEN INC(b, n.right.size); END;
  INC(newNode.size, b);
  DEC(n.size, a);
  (* rotate *)
  n.left := newNode.right;
  newNode.right := n;
  n.parent := newNode;
  IF n.left # NIL THEN
    n.left.parent := n;
  END;
  IF parent # NIL THEN
    IF n = parent.left THEN
      parent.left := newNode;
    ELSIF n = parent.right THEN
      parent.right := newNode;
    END;
  END;
  newNode.parent := parent;
END RotateRight;

(* Pass information on size to parents. *)
PROCEDURE NotifyParentsOfInsertion(READONLY n: T) =
VAR
  p: T := n.parent;
BEGIN
  WHILE p # NIL DO
    INC(p.size);
    p := p.parent;
  END;
END NotifyParentsOfInsertion;

(*
Recursively inserts n, starting at root and finding the correct location,
which might be different (but really shouldn't be!).
Returns TRUE if and only if it was actually inserted,
because if it already appears in the set, it won't be inserted.
*)
PROCEDURE RecursiveInsert(VAR root: T; n: T): BOOLEAN =
VAR
  comparison: INTEGER;
  inserted: BOOLEAN := FALSE;
  someoneInserted: BOOLEAN := FALSE;
BEGIN
  IF root = NIL THEN
    root := n;
    someoneInserted := TRUE;
  ELSE
    comparison := Elem.Compare(n.value, root.value);
    IF comparison < 0 THEN
      IF root.left # NIL THEN
        someoneInserted := RecursiveInsert(root.left, n);
      ELSE
        root.left := n;
        inserted := TRUE;
      END
    ELSIF comparison > 0 THEN 
      IF root.right # NIL THEN
        someoneInserted := RecursiveInsert(root.right, n);
      ELSE
        root.right := n;
        inserted := TRUE;
      END
    END;
    IF inserted THEN
      n.parent := root;
      n.kind := RB.RED;
      someoneInserted := TRUE;
      NotifyParentsOfInsertion(n);
    END;
  END;
  RETURN someoneInserted;
END RecursiveInsert;

(* Returns the node that is "uncle" to n. *)
PROCEDURE Uncle(n: T): T =
VAR
  parent: T := n.parent;
  result: T := parent.parent;
BEGIN
  IF result # NIL THEN
    IF parent = result.right THEN
      result := result.left;
    ELSE
      result := result.right;
    END
  END;
  RETURN result;
END Uncle;

(* Repairs the tree if insertion has broken it, starting at n. *)
PROCEDURE RepairTree(n: T) =
VAR
  parent: T := n.parent;
  uncle, grandparent: T;
BEGIN
  IF parent = NIL THEN
    n.kind := RB.BLACK;
  ELSIF parent.kind = RB.RED THEN (* We do nothing if parent is RB.BLACK *)
    grandparent := parent.parent;
    uncle := Uncle(n);
    IF (uncle # NIL) AND (uncle.kind = RB.RED) THEN
      parent.kind := RB.BLACK;
      uncle.kind := RB.BLACK;
      grandparent.kind := RB.RED;
      RepairTree(grandparent);
    ELSE
      IF (grandparent.left # NIL) AND (n = grandparent.left.right) THEN
        RotateLeft(parent);
        n := n.left;
      ELSIF (grandparent.right # NIL) AND (n = grandparent.right.left) THEN
        RotateRight(parent);
        n := n.right;
      END;
      parent := n.parent;
      grandparent := parent.parent;
      IF n = parent.left THEN
        RotateRight(grandparent);
      ELSE
        RotateLeft(grandparent);
      END;
      parent.kind := RB.BLACK;
      grandparent.kind := RB.RED;
    END
  END
END RepairTree;

PROCEDURE Insert(VAR t: T; READONLY e: Elem.T): BOOLEAN =
VAR
  n: T := Tree(e);
  success: BOOLEAN;
BEGIN
  success := RecursiveInsert(t, n);
  IF success THEN RepairTree(n); END;
  WHILE t.parent # NIL DO
    t := t.parent;
  END;
  RETURN success;
END Insert;

PROCEDURE FromArray(READONLY e: ARRAY OF Elem.T): T =
VAR
  tree: T := NIL;
BEGIN
  FOR i := FIRST(e) TO LAST(e) DO
    EVAL Insert(tree, e[i]);
  END;
  RETURN tree;
END FromArray;

PROCEDURE Size(READONLY t: T): CARDINAL =
BEGIN
  IF t = NIL THEN RETURN 0;
  ELSE RETURN t.size;
  END;
END Size;

PROCEDURE Height(READONLY n: T): CARDINAL =
VAR
  leftHeight, rightHeight: CARDINAL;
BEGIN
  IF n = NIL THEN RETURN 0;
  ELSE
    leftHeight  := Height(n.left);
    rightHeight := Height(n.right);
    RETURN MAX(leftHeight, rightHeight) + 1;
  END;
END Height;

(* find root of tree *)
PROCEDURE Root(n: T): T =
VAR
  result: T := n;
BEGIN
  WHILE result.parent # NIL DO
    result := result.parent;
  END;
  RETURN result;
END Root;

(* pass information on size to ancestors *)
PROCEDURE NotifyParentsOfDeletion(READONLY n: T) =
VAR
  p: T := n.parent;
BEGIN
  (* size is straightforward *)
  WHILE p # NIL DO
    DEC(p.size);
    p := p.parent;
  END;
END NotifyParentsOfDeletion;

PROCEDURE ReplaceNode(VAR n, c: T) =
BEGIN
  IF c # NIL THEN
    c.parent := n.parent;
  END;
  IF n.parent # NIL THEN
    IF n = n.parent.left THEN
      n.parent.left := c;
    ELSE
      n.parent.right := c;
    END;
  END;
END ReplaceNode;

(* Return the sibling of self in the tree; this could be NIL. *)
PROCEDURE Sibling(READONLY self: T): T =
VAR
  result: T;
BEGIN
  IF self.parent.right = self THEN
    result := self.parent.left;
  ELSE
    result := self.parent.right;
  END;
  RETURN result;
END Sibling;

PROCEDURE IsBlack(READONLY n: T): BOOLEAN =
BEGIN
  RETURN (n = NIL) OR (n.kind = RB.BLACK);
END IsBlack;

PROCEDURE IsRed(READONLY t: T): BOOLEAN =
BEGIN
  RETURN (t # NIL) AND (t.kind = RB.RED);
END IsRed;

PROCEDURE DeleteCase6(n: T) =
VAR s: T;
BEGIN
  s := Sibling(n);
  s.kind := n.parent.kind;
  n.parent.kind := RB.BLACK;
  IF n = n.parent.left THEN
    IF s.right # NIL THEN s.right.kind := RB.BLACK; END;
    RotateLeft(n.parent);
  ELSE
    IF s.left # NIL THEN s.left.kind := RB.BLACK; END;
    RotateRight(n.parent);
  END;
END DeleteCase6;

(* RB.RED/black adjustment after deletion; based on Wikipedia entry. *)
PROCEDURE DeleteCase5(n: T) =
VAR s: T;
BEGIN
  s := Sibling(n);
  IF IsBlack(s) THEN
    IF (n = n.parent.left) AND IsBlack(s.right) AND (s.left.kind = RB.RED) THEN
      s.kind := RB.RED;
      IF s.left # NIL THEN s.left.kind := RB.BLACK; END;
      RotateRight(s);
    ELSIF (n = n.parent.right) AND IsBlack(s.left) AND (s.right.kind = RB.RED) THEN
      s.kind := RB.RED;
      IF s.right # NIL THEN s.right.kind := RB.BLACK; END;
      RotateLeft(s);
    END;
  END;
  DeleteCase6(n);
END DeleteCase5;

(* RB.RED/black adjustment after deletion; based on Wikipedia entry. *)
PROCEDURE DeleteCase4(n: T) =
VAR s: T;
BEGIN
  s := Sibling(n);
  IF n.parent.kind = RB.RED AND IsBlack(s) AND IsBlack(s.left) AND IsBlack(s.right) THEN
    s.kind := RB.RED;
    n.parent.kind := RB.BLACK;
  ELSE
    DeleteCase5(n);
  END;
END DeleteCase4;

(* RB.RED/black adjustment after deletion; based on Wikipedia entry. *)
PROCEDURE DeleteCase3(n: T) =
VAR s: T;
BEGIN
  s := Sibling(n);
  IF IsBlack(n.parent) AND IsBlack(s) AND IsBlack(s.left) AND IsBlack(s.right) THEN
    s.kind := RB.RED;
    DeleteCase1(n.parent);
  ELSE
    DeleteCase4(n);
  END;
END DeleteCase3;

(* RB.RED/black adjustment after deletion; based on Wikipedia entry. *)
PROCEDURE DeleteCase2(n: T) =
VAR s: T;
BEGIN
  s := Sibling(n);
  IF (s # NIL) AND s.kind = RB.RED THEN
    n.parent.kind := RB.RED;
    s.kind := RB.BLACK;
    IF n = n.parent.left THEN
      RotateLeft(n.parent);
    ELSE
      RotateRight(n.parent);
    END; (* n = n.parent.left *)
  END; (* s.kind = RB.RED *)
  DeleteCase3(n);
END DeleteCase2;

(* RB.RED/black adjustment after deletion; based on Wikipedia entry. *)
PROCEDURE BaseDeleteCase(n: T) =
BEGIN
  IF n.parent # NIL THEN
    DeleteCase2(n);
  END;
END BaseDeleteCase;

(*
Red/black adjustment after deletion; based on Wikipedia entry.
This merits a little more commentary:
we invoke it only when a node has at most one child.
*)
PROCEDURE DeleteMaxOneChild(n: T) =
VAR
  c: T;
BEGIN
  IF n.right = NIL THEN
    c := n.left;
  ELSE
    c := n.right;
  END;
  ReplaceNode(n, c);
  IF c # NIL THEN
    IF n.kind = RB.BLACK THEN
      IF c.kind = RB.RED THEN
        c.kind := RB.BLACK;
      ELSE
        DeleteCase1(c);
      END;
    END;
  END;
END DeleteMaxOneChild;

(* Returns the node with the largest value on this tree. *)
PROCEDURE MaxNode(n: T): T =
VAR
  result: T := n;
BEGIN
  WHILE result.right # NIL DO
    result := result.right;
  END;
  RETURN result;
END MaxNode;

PROCEDURE RemoveNode(VAR n: T): T =
VAR
  c, r: T;
  s: T := Root(n);
  nodeIsRoot := s = n;
BEGIN
  NotifyParentsOfDeletion(n);
  (* make a note if n is s *)
  IF NOT nodeIsRoot THEN
    r := NIL;
  ELSE
    IF n.left # NIL THEN r := n.left;
    ELSE r := n.right;
    END;
  END;
  IF (n.left # NIL) AND (n.right # NIL) THEN
    c := MaxNode(n.left);
    n.value := c.value;
    DEC(n.size);
  ELSE
    c := n;
  END;
  DeleteMaxOneChild(c);
  (* adjust root *)
  IF nodeIsRoot THEN
    WHILE r # NIL AND r.parent # NIL DO
      r := r.parent;
    END;
    s := r;
  END;
  RETURN s;
END RemoveNode;

BEGIN
  DeleteCase1 := BaseDeleteCase;
END Tree.