GENERIC MODULE SetTree(Elem, ElemSet, ElemTree);

TYPE

  REVEAL T = Public BRANDED OBJECT

    t: ElemTree.T;

  OVERRIDES

    init := Init;
    fromArray := FromArray;
    copy := Copy;
    member := Member;
    insert := Insert;
    delete := Delete;
    size := Size;
    iterate := Iterate;

    height := Height;
    root := Root;

  END;

  Iterator = ElemSet.Iterator BRANDED OBJECT
    node: ElemTree.T;
  OVERRIDES
    next := Next;
  END;

PROCEDURE Init(self: T): T =
BEGIN
  RETURN self;
END Init;

PROCEDURE FromArray(self: T; READONLY e: ARRAY OF Elem.T): ElemSet.T =
BEGIN
  self.t := ElemTree.FromArray(e);
  RETURN self;
END FromArray;

PROCEDURE Copy(self: T): ElemSet.T =
VAR
  result := NEW(T).init();
BEGIN
  ElemTree.Copy(self.t, result.t);
  RETURN result;
END Copy;

PROCEDURE Member(self: T; e: Elem.T): BOOLEAN =
BEGIN
  RETURN ElemTree.Member(self.t, e);
END Member;

PROCEDURE Insert(self: T; e: Elem.T): BOOLEAN =
BEGIN
  RETURN ElemTree.Insert(self.t, e);
END Insert;

PROCEDURE Size(self: T): CARDINAL =
BEGIN
  RETURN ElemTree.Size(self.t);
END Size;

PROCEDURE Height(self: T): CARDINAL =
BEGIN
  RETURN ElemTree.Height(self.t);
END Height;

PROCEDURE Root(self: T): ElemTree.T =
BEGIN
  RETURN self.t;
END Root;

PROCEDURE Delete(self: T; e: Elem.T): BOOLEAN =
VAR
  node: ElemTree.T := ElemTree.Find(self.t, e);
  exists: BOOLEAN := node # NIL;
BEGIN
  IF exists THEN self.t := ElemTree.RemoveNode(node); END;
  RETURN exists;
END Delete;

PROCEDURE Iterate(self: T): ElemSet.Iterator =
VAR
  res := NEW(Iterator, node := ElemTree.First(self.t));
BEGIN
  RETURN res;
END Iterate;

PROCEDURE Next(iter: Iterator; VAR e: Elem.T): BOOLEAN =
VAR result := FALSE;
BEGIN
  IF iter.node # NIL THEN
    e := ElemTree.Value(iter.node);
    iter.node := ElemTree.Succ(iter.node);
    result := TRUE;
  END;
  RETURN result;
END Next;

BEGIN
END SetTree.