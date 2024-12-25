---- MODULE loop ----
EXTENDS Integers, Sequences, TLC

(*--algorithm dup
  variable seq = <<1, 2, 3, 2>>;
  index = 1;
  seen = {};
  is_unique = TRUE;

begin
  TheMainLoop:
    while index <= Len(seq) do
      if seq[index] \notin seen then
        seen := seen \union {seq[index]};
      else
        is_unique := FALSE;
      end if;
      index := index + 1;
    end while;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "4a7c5608" /\ chksum(tla) = "6b7a49fa")
VARIABLES seq, index, seen, is_unique, pc

vars == << seq, index, seen, is_unique, pc >>

Init == (* Global variables *)
        /\ seq = <<1, 2, 3, 2>>
        /\ index = 1
        /\ seen = {}
        /\ is_unique = TRUE
        /\ pc = "TheMainLoop"

TheMainLoop == /\ pc = "TheMainLoop"
               /\ IF index <= Len(seq)
                     THEN /\ IF seq[index] \notin seen
                                THEN /\ seen' = (seen \union {seq[index]})
                                     /\ UNCHANGED is_unique
                                ELSE /\ is_unique' = FALSE
                                     /\ seen' = seen
                          /\ index' = index + 1
                          /\ pc' = "TheMainLoop"
                     ELSE /\ pc' = "Done"
                          /\ UNCHANGED << index, seen, is_unique >>
               /\ seq' = seq

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == TheMainLoop
           \/ Terminating

Spec == /\ Init 
        /\ [][Next]_vars 
        /\ SF_vars(Next) \* we assume strong fairness: we can't stutter forever

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
