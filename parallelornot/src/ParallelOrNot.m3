MODULE ParallelOrNot EXPORTS Main;

(*
Used to verify that CM3 implements true parallelism.
There are two tasks:
  (1) Fill a 2xn array with integers.
  (2) Sum the integers in each row.
When "parallel" is set to "FALSE", this runs sequentially.
When it is set to "TRUE", CM3 spawns threads to perform each of these tasks.
It takes about half as long to perform the tasks with two threads,
though it can be difficult to see this when we allocate the array,
because CM3 apparently initializes the array with values, and this takes time.
*)

IMPORT Thread, IO, Time, Fmt;

TYPE

  ClosureFill = Thread.Closure OBJECT
  (* used to fill the given "row" of the array with values *)
    row, start, stop: CARDINAL;
  OVERRIDES
    apply := ApplyFill;
  END;

  ClosureSum = Thread.Closure OBJECT
  (* used to sum the given "row" of the array *)
    row, start, stop: CARDINAL;
  OVERRIDES
    apply := ApplySum;
  END;

CONST

  n = 1000000000;
  (* larger than this won't compile, unless array is REF *)
  parallel = TRUE;
  (* set to "TRUE" for parallel operation; set to "FALSE" for sequential *)

VAR

  (* can change to REF, but then un-comment allocation in Main *)
  (* a: ARRAY[0..1] OF ARRAY[0..n-1] OF CARDINAL; *)
  a: REF ARRAY OF ARRAY OF CARDINAL;

PROCEDURE ApplyFill(clos: ClosureFill): REFANY =
(* fill "clos.row" with the values 0..n-1 *)
BEGIN
  WITH i = clos.row DO
    FOR j := clos.start TO clos.stop DO
      a[i][j] := j * i;
    END;
  END;
  RETURN NIL;
END ApplyFill;

PROCEDURE ApplySum(clos: ClosureSum): REFANY =
(* sum the values in the row and return *)
VAR
  sum: REF CARDINAL := NEW(REF CARDINAL);
BEGIN
  sum^ := 0;
  WITH i = clos.row DO
    FOR j := clos.start TO clos.stop DO
      INC(sum^, a[i][j]);
    END;
  END;
  RETURN sum;
END ApplySum;

VAR

  clossum1, clossum2, clossum3, clossum4: ClosureSum;
  closfil1, closfil2, closfil3, closfil4: ClosureFill;
  th1, th2, th3, th4: Thread.T;
  s1, s2, s3, s4: REF CARDINAL;

BEGIN

  closfil1 := NEW(ClosureFill, row := 0, start := 0, stop := n DIV 2);
  closfil2 := NEW(ClosureFill, row := 0, start := n DIV 2 + 1, stop := n - 1);
  closfil3 := NEW(ClosureFill, row := 1, start := 0, stop := n DIV 2);
  closfil4 := NEW(ClosureFill, row := 1, start := n DIV 2 + 1, stop := n - 1);
  clossum1 := NEW(ClosureSum, row := 0, start := 0, stop := n DIV 2);
  clossum2 := NEW(ClosureSum, row := 0, start := n DIV 2 + 1, stop := n - 1);
  clossum3 := NEW(ClosureSum, row := 1, start := 0, stop := n DIV 2);
  clossum4 := NEW(ClosureSum, row := 1, start := n DIV 2 + 1, stop := n - 1);

  (* remove comments if array is REF *)
  (* this mysteriously takes a long time, perhaps filling with zeroes? *)
  VAR start := Time.Now(); stop: LONGREAL;
  BEGIN
    a := NEW(REF ARRAY OF ARRAY OF CARDINAL, 2, n);
    stop := Time.Now();
    IO.Put("initialization overhead: "); IO.Put(Fmt.LongReal(stop - start));
    IO.PutChar('\n');
  END;

  IF parallel THEN

    th1 := Thread.Fork(closfil1);
    th2 := Thread.Fork(closfil2);
    th3 := Thread.Fork(closfil3);
    th4 := Thread.Fork(closfil4);
  
    EVAL Thread.Join(th1);
    EVAL Thread.Join(th2);
    EVAL Thread.Join(th3);
    EVAL Thread.Join(th4);
  
    IO.Put("Joined fill\n");
    IO.Put("Will sum from 0 to "); IO.PutInt(a[0][LAST(a[0])]); IO.PutChar('\n');
    IO.Put("Will sum from 0 to "); IO.PutInt(a[1][LAST(a[1])]); IO.PutChar('\n');
  
    th1 := Thread.Fork(clossum1);
    th2 := Thread.Fork(clossum2);
    th3 := Thread.Fork(clossum3);
    th4 := Thread.Fork(clossum4);
  
    s1 := Thread.Join(th1);
    s2 := Thread.Join(th2);
    s3 := Thread.Join(th3);
    s4 := Thread.Join(th4);
  
    IO.Put("Joined sum\n");

  ELSE

    EVAL ApplyFill(closfil1);
    EVAL ApplyFill(closfil2);
    s1 := ApplySum(clossum1);
    s2 := ApplySum(clossum2);

  END;

  IO.PutInt(s1^ + s2^); IO.PutChar(' ');
  IO.PutInt(s3^ + s4^); IO.PutChar('\n');

END ParallelOrNot.