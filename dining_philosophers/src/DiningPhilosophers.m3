MODULE DiningPhilosophers EXPORTS Main;

IMPORT IO, Random, Thread;

CONST

  PartySize = 5; (* modify for more/fewer philosophers *)

TYPE

  Closure = Thread.Closure OBJECT
  (* thread information *)
    which: [1..PartySize]; (* identifies the thread *)
  OVERRIDES
    apply := Live; (* procedure to execute *)
  END;

VAR

  (* how long to eat/think *)
  random: Random.T;

  (* controls access to resources *)
  test := NEW(MUTEX);
  forks := NEW(Thread.Condition); (* condition variable, used for signaling *)
  forkAvailable := ARRAY[1..PartySize] OF BOOLEAN {
    TRUE, TRUE, TRUE, TRUE, TRUE
  };
  (* the philosophers/tasks *)
  thread: ARRAY[1..PartySize] OF Thread.T;
  name := ARRAY[1..PartySize] OF TEXT {
    "Aristotle", "Kant", "Spinoza", "Marx", "Russell"
  };

PROCEDURE PlaceAvailable(): CARDINAL =
(*
  Determines whether a place is available at the table.
  If so, returns the place number. Otherwise, returns 0.
  We consider a place available if and only if *both* forks are free.
*)
BEGIN
  FOR i := 1 TO PartySize DO
    IF forkAvailable[i] AND forkAvailable[((i+1) MOD PartySize) + 1] THEN
      RETURN i;
    END;
  END;
  RETURN 0;
END PlaceAvailable;

PROCEDURE Live(philosopher: Closure): REFANY =
(* philosophers eat, sleep, ... and that's about it *)
VAR
  place: CARDINAL;
BEGIN
  WITH which = philosopher.which DO
    WHILE TRUE DO
      (* first make sure a place is available: both forks must be free! *)
      LOCK test DO
        place := PlaceAvailable();
        (* if not, release mutex and use condition variable to wait for one *)
        WHILE place = 0 DO
          IO.Put(name[which]); IO.Put(" starving!\n");
          Thread.Wait(test, forks);
          (* in Modula-3 we arrive here only if we have the lock again *)
          place := PlaceAvailable();
        END;
        (* a place has come available! seize the forks while mutex is locked *)
        forkAvailable[place] := FALSE;
        forkAvailable[(place MOD PartySize) + 1] := FALSE;
        IO.Put(name[which]); IO.Put(" eating at place "); IO.PutInt(place);
        IO.PutChar('\n');
      END;
      Thread.Pause(FLOAT(random.integer(1,3), LONGREAL));
      (* put down the forks *)
      forkAvailable[place]  := TRUE;
      forkAvailable[(place MOD PartySize) + 1] := TRUE;
      Thread.Signal(forks); (* signal the condition variable *)
      LOCK test DO
        IO.Put(name[which]); IO.Put(" thinking\n");
      END;
      Thread.Pause(FLOAT(random.integer(1,3), LONGREAL));
    END; (* WHILE *)
  END; (* WITH *)
  RETURN NIL;
END Live;

BEGIN
  random := NEW(Random.Default).init();
  (* bring philosophers to life *)
  FOR i := 1 TO PartySize DO
    thread[i] := Thread.Fork(NEW(Closure, apply := Live, which := i));
  END;
  (*
    We need to wait, otherwise the program will terminate,
    and the philosophers with it. Technically we could wait
    for just one philosopher, but in the interest of symmetry...
  *)
  FOR i := 1 TO PartySize DO
    EVAL Thread.Join(thread[i]);
  END;
END DiningPhilosophers.