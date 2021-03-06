MODULE Caesar EXPORTS Main;

(*
This implementation distinguishes between "encoding" and "encryption."
The former turns letters into numbers;
the latter turns numbers into different ("cryptic") numbers.
The distinction between "decoding" and "decryption" is similar.
*)

IMPORT IO, IntSeq, Text;

EXCEPTION BadCharacter;
(* Used whenever message contains a non-alphabetic character. *)

PROCEDURE Encode(READONLY message: TEXT; numbers: IntSeq.T) RAISES { BadCharacter } =
(*
Converts upper or lower case letter to 0..25.
Raises a "BadCharacter" exception for non-alphabetic characters.
*)
VAR
  c: CHAR;
  v: INTEGER;
BEGIN
  FOR i := 0 TO Text.Length(message) - 1 DO
    c := Text.GetChar(message, i);
    CASE c OF
    | 'A'..'Z' => v := ORD(c) - ORD('A');
    | 'a'..'z' => v := ORD(c) - ORD('a');
    ELSE
      RAISE BadCharacter;
    END;
    numbers.addhi(v);
  END;
END Encode;

PROCEDURE Decode(READONLY numbers: IntSeq.T; VAR message: TEXT) =
(* converts numbers in 0..26 to lower case characters *)
BEGIN
  FOR i := 0 TO numbers.size() - 1 DO
    message := message & Text.FromChar(VAL(numbers.get(i) + ORD('a'), CHAR));
  END;
END Decode;

PROCEDURE Crypt(numbers: IntSeq.T; key: INTEGER) =
(*
In the Caesar cipher, encryption and decryption are really the same;
one adds the key, the other subtracts it. We can view this as adding a positive
or nevative integer; the common task is adding an integer. We call this "Crypt".
*)
BEGIN
  FOR i := 0 TO numbers.size() - 1 DO
    numbers.put(i, (numbers.get(i) + key) MOD 26);
  END;
END Crypt;

PROCEDURE Encrypt(numbers: IntSeq.T; key := 4) =
(*
Encrypts a message of numbers using the designated key.
The result is also stored in "numbers".
*)
BEGIN
  Crypt(numbers, key);
END Encrypt;

PROCEDURE Decrypt(numbers: IntSeq.T; key := 4) =
(*
Decrypts a message of numbers using the designated key.
The result is also stored in "numbers".
*)
BEGIN
  Crypt(numbers, -key);
END Decrypt;

VAR

  message := "";
  buffer := NEW(IntSeq.T).init(22); (* sequence of 22 int's *)

BEGIN
  TRY
    Encode("WhenCaesarSetOffToGaul", buffer);
  EXCEPT BadCharacter =>
    (* 
      This should never occur.
      Try adding spaces to the above to see what happens.
    *)
    IO.Put("Encountered a bad character in the input; completing partial task\n");
  END;
  Encrypt(buffer);
  Decrypt(buffer);
  Decode(buffer, message);
  IO.Put(message); IO.PutChar('\n');
END Caesar.