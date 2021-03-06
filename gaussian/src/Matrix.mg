GENERIC MODULE Matrix(RingElem);

IMPORT IO;

TYPE

  REVEAL T = Public BRANDED OBJECT
    rows, cols: CARDINAL;
    data: REF ARRAY OF ARRAY OF RingElem.T;
  OVERRIDES
    init := Init;
    initDimensions := InitDimensions;
    num_rows := Rows;
    num_cols := Columns;
    entries := Entries;
    triangularize := Triangularize;
  END;

PROCEDURE Init(self: T; READONLY d: ARRAY OF ARRAY OF RingElem.T): T =
BEGIN
  self.rows := NUMBER(d);
  self.cols := NUMBER(d[0]);
  self.data := NEW(REF ARRAY OF ARRAY OF RingElem.T, self.rows, self.cols);
  FOR i := FIRST(d) TO LAST(d) DO
    FOR j := FIRST(d[0]) TO LAST(d[0]) DO
      self.data[i-FIRST(d)][j-FIRST(d[0])] := d[i][j];
    END;
  END;
  RETURN self;
END Init;

PROCEDURE InitDimensions(self: T; r, c: CARDINAL): T =
BEGIN
  self.rows := r;
  self.cols := c;
  self.data := NEW(REF ARRAY OF ARRAY OF RingElem.T, r, c);
  RETURN self;
END InitDimensions;

PROCEDURE Rows(self: T): CARDINAL =
BEGIN
  RETURN self.rows;
END Rows;

PROCEDURE Columns(self: T): CARDINAL =
BEGIN
  RETURN self.cols;
END Columns;

PROCEDURE Entries(self: T): REF ARRAY OF ARRAY OF RingElem.T =
BEGIN
  RETURN self.data;
END Entries;

PROCEDURE SwapRows(VAR data: ARRAY OF ARRAY OF RingElem.T; i, j: CARDINAL) =
(* swaps rows i and j of data *)
VAR
  a: RingElem.T;
BEGIN
  WITH Ai = data[i], Aj = data[j], m = FIRST(data[0]), n = LAST(data[0]) DO
    FOR k := m TO n DO
      a     := Ai[k];
      Ai[k] := Aj[k];
      Aj[k] := a;
    END;
  END;
END SwapRows;

PROCEDURE PivotExists(
    VAR data: ARRAY OF ARRAY OF RingElem.T;
    r: CARDINAL;
    VAR i: CARDINAL;
    j: CARDINAL
): BOOLEAN =
(*
  Returns true iff column j of data has a pivot in some row at or after r.
  The row with a pivot is stored in i.
*)
VAR
  searching := TRUE;
  result := LAST(data) + 1;
BEGIN
  i := r;
  WHILE searching AND i <= LAST(data) DO
    IF RingElem.Nonzero(data[i,j]) THEN
      searching := FALSE;
      result := i;
    ELSE
      INC(i);
    END;
  END;
  RETURN NOT searching;
END PivotExists;

PROCEDURE Pivot(VAR data: ARRAY OF ARRAY OF RingElem.T; i, j, k: CARDINAL) =
(*
  Pivots on row i, column j to eliminate row k, column j.
*)
BEGIN
  WITH n = LAST(data[0]), Ai = data[i], Ak = data[k] DO
    VAR a := Ai[j]; b := Ak[j];
    BEGIN
      FOR l := j TO n DO
        IF RingElem.Nonzero(Ai[l]) THEN
          Ak[l] := RingElem.Minus(
              RingElem.Times(Ak[l], a),
              RingElem.Times(Ai[l], b)
          );
        ELSE
          Ak[l] := RingElem.Times(Ak[l], a);
        END;
      END;
    END;
  END;
END Pivot;

PROCEDURE Triangularize(self: T) =
VAR
  i: CARDINAL;
  r := FIRST(self.data[0]);
BEGIN
  WITH data = self.data, m = FIRST(data[0]), n = LAST(data[0]) DO
    FOR j := m TO n DO
      IF PivotExists(data^, r, i, j) THEN
        IF i # j THEN
          SwapRows(data^, i, r);
        END;
        FOR k := r + 1 TO LAST(data^) DO
          IF RingElem.Nonzero(data[k][j]) THEN
            Pivot(data^, r, j, k);
          END;
        END;
        INC(r);
      END;
    END;
  END;
END Triangularize;

PROCEDURE PrintMatrix(self: T) =
BEGIN
  WITH data = self.data DO
    FOR i := FIRST(data^) TO LAST(data^) DO
      IO.Put("[ ");
      WITH Ai = data[i] DO
        FOR j := FIRST(Ai) TO LAST(Ai) DO
          RingElem.Print(Ai[j]);
          IF j # LAST(Ai) THEN
            IO.PutChar(' ');
          END;
        END;
      END;
      IO.Put(" ]\n");
    END;
  END;
END PrintMatrix;

BEGIN
END Matrix.