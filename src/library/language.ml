include AbstractDict

let combMark = '-'
let combMarkString = "-"

let log a =
   Js.log a;
   a

module Make
   (TD: TERMIN_DICTIONARY)
   (CD: CONJ_DICTIONARY)
= struct
   module Roots = struct
      type t =
         | Root of TD.t * t
         | Prop of string
         | End
      
      let fold t fn default = match t with
         | Root (t, _) -> fn t
         | Prop _ | End -> default

      let show t =
         let rec iter t = match t with
            | Root(term, next) -> TD.show term :: iter next
            | Prop(str) -> [str]
            | End -> []
         in
         Belt.List.reduce (iter t) "" (fun acc curr -> if acc = "" then curr else acc ^ combMarkString ^ curr)

      let parse str =
         let rec iter strings = match strings with
            | word :: next -> (
               let
                  compound = Belt.List.reduce (word :: next) "" (fun acc curr -> if acc = "" then curr else acc ^ combMarkString ^ curr)
               in
               match TD.parse compound with
               | Some(word) -> Root(word, End)
               | None -> (match TD.parse word with
                  | Some(word) -> Root(word, iter next)
                  | None -> Prop(word)
               )
            )
            | [] -> End
         in
         iter (str |> String.split_on_char combMark)
   end

   module Conjs = struct
      type t =
         | Conj of CD.t
         | End

      let fold t fn default = match t with
         | Conj t -> fn t
         | End -> default

      let show t = match t with
        | Conj str -> CD.show str
        | End -> ""
   
      let parse str = match CD.parse str with
         | Some str -> Conj str
         | None -> End
    end

   module Lexs = struct
      type t =
         | End
         | Noun of Roots.t * t
         | Verb of Roots.t * t
         | Ad of Roots.t * t
         | Con of Conjs.t * t

      let isMark str = List.mem str [CD.nounMark; CD.verbMark; CD.adMark]

      type pending = P_N | P_V | P_A

      let parse str =
         let rec iter pending strs = 
            match (pending, strs) with
               | (_, [])
                  -> End
               
               | (_, conj :: next) when CD.mem conj
                  -> Con(Conjs.parse conj, iter P_N next)

               | (_, mark :: word :: next) when mark = CD.nounMark && not (isMark word)
                  -> Noun(Roots.parse word, iter P_V next)
               | (_, mark :: word :: next) when mark = CD.verbMark && not (isMark word)
                  -> Verb(Roots.parse word, iter P_N next)
               | (_, mark :: word :: next) when mark = CD.adMark && not (isMark word)
                  -> Ad(Roots.parse word, iter P_A next)

               | (P_N, word :: next)
                  -> Noun(Roots.parse word, iter P_V next)
               | (P_V, word :: next)
                  -> Verb(Roots.parse word, iter P_N next)
               | (P_A, word :: next)
                  -> Ad(Roots.parse word, iter P_A next)
            in
            String.trim str
            |> String.split_on_char ' '
            |> iter P_N
            |> log

         let mem str = parse str != End

      let show lex =
         let rec iter lex = match lex with
            | End -> []

            | Noun(root, Ad(root', next))
               -> Roots.(show root) :: CD.adMark :: (iter @@ Ad(root', next))
            | Verb(root, Ad(root', next))
               -> Roots.(show root) :: CD.adMark :: (iter @@ Ad(root', next))

            | Noun(root, Verb(root', Ad(root'', next)))
               -> Roots.(show root) :: CD.verbMark :: (iter @@ Verb(root', Ad(root'', next)))
            | Verb(root, Noun(root', Ad(root'', next)))
               -> Roots.(show root) :: CD.verbMark :: (iter @@ Verb(root', Ad(root'', next)))

            | Noun(root, Noun(root', next))
               -> Roots.(show root) :: CD.nounMark :: (iter @@ Noun(root', next))
            | Verb(root, Verb(root', next))
               -> Roots.(show root) :: CD.nounMark :: (iter @@ Verb(root', next))

            | Noun(root, next)
               -> Roots.(show root) :: iter next
            | Verb(root, next)
               -> Roots.(show root) :: iter next

            | Ad(root, Noun(root', next))
               -> Roots.show root :: CD.nounMark :: (iter @@ Noun(root', next))
            | Ad(root, Verb(root', next))
               -> Roots.show root :: CD.verbMark :: (iter @@ Verb(root', next))
            | Ad(root, next)
               -> Roots.show root :: iter next

            | Con(conj, next)
               -> Conjs.show conj :: iter next
         in
         iter lex
         |> List.fold_left (fun acc curr -> acc ^ " " ^ curr) ""
         |> String.trim
   end
end
