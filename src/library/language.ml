module type PARSABLE = sig
   type t
   val show : t -> string
   val parse : string -> t option
end

module type CONJ_DICTIONARY = sig
   include PARSABLE
   val nounMark : string
   val verbMark : string
   val adMark : string
   val mem : string -> bool
   val getDef : t -> string
   val getDescription : t -> string
   val all : t list
end

module type TERMIN_DICTIONARY = sig
   include PARSABLE
   val getNounDef : t -> string
   val getVerbDef : t -> string
   val getAdjDef : t -> string
   val getAdvDef : t -> string
   val getDescription : t -> string
   val all : t list
end

let combMark = '-'
let combMarkString = "-"

module Make
   (TD: TERMIN_DICTIONARY) (* Termin Dictionary *)
   (CD: CONJ_DICTIONARY) (* Conjugation Dictionary *)
= struct
   module Roots = struct
      type t =
         | Root of TD.t * t
         | Prop of string
         | End

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
               match TD.parse word with
               | Some(word) -> Root(word, iter next)
               | None -> Prop(word)
            )
            | [] -> End
         in
         iter (str |> String.split_on_char combMark)
   end

   module Lexs = struct
      type t =
         | End
         | Noun of Roots.t * t
         | Verb of Roots.t * t
         | Ad of Roots.t * t
         | Con of CD.t * t

      let isMark str = List.mem str [CD.nounMark; CD.verbMark; CD.adMark]

      let show lex =
         let rec iter lex = match lex with
            | End -> []
            | Noun(root, next) -> CD.nounMark :: Roots.show root :: iter next
            | Verb(root, next) -> CD.verbMark :: Roots.show root :: iter next
            | Ad(root, next) -> CD.adMark :: Roots.show root :: iter next
            | Con(conj, next) -> CD.show conj :: iter next
         in
         (match iter lex with
            | word :: next when word = CD.nounMark -> next
            | words -> words
         )
         |> List.fold_left (fun acc curr -> acc ^ " " ^ curr) ""

      let parse str =
         let rec iter strs = match strs with
            | mark :: word :: next when mark = CD.nounMark ->
               Noun(Roots.parse word, iter next)
            | mark :: word :: next when mark = CD.verbMark ->
               Verb(Roots.parse word, iter next)
            | mark :: word :: next when mark = CD.adMark ->
               Ad(Roots.parse word, iter next)
            | mark :: word :: next when CD.mem mark ->
               if isMark word
                  then (match CD.parse mark with
                     | Some(mark) -> Con(mark, iter next)
                     | None -> End
                  )
                  else (match CD.parse mark with
                     | Some(mark) -> Con(mark, iter (CD.nounMark :: next))
                     | None -> End
                  )
            | word :: next ->
               iter (CD.adMark :: word :: next)
            | [] ->
                  End
         in
         match
            str
            |> String.trim
            |> String.split_on_char ' '
         with
            | mark :: next when isMark mark -> iter (mark :: next)
            | next -> iter (CD.nounMark :: next)

         let mem str = parse str != End
   end
end