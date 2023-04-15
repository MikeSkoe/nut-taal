include AbstractDict

let combMark = '-'
let combMarkString = "-"

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
               match TD.parse word with
               | Some(word) -> Root(word, iter next)
               | None -> Prop(word)
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

      let show lex =
         let rec iter lex = match lex with
            | End -> []
            | Noun(root, next) -> CD.nounMark :: Roots.show root :: iter next
            | Verb(root, next) -> CD.verbMark :: Roots.show root :: iter next
            | Ad(root, next) -> CD.adMark :: Roots.show root :: iter next
            | Con(conj, next) -> Conjs.show conj :: iter next
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
               let next = if isMark word then word :: next else CD.nounMark :: word :: next in
               Con(Conjs.parse mark, iter next)
            | word :: next ->
               iter (CD.adMark :: word :: next)
            | [] ->
               End
         in
         match
            String.trim str
            |> String.split_on_char ' '
         with
            | mark :: next when isMark mark -> iter (mark :: next)
            | next -> iter (CD.nounMark :: next)

         let mem str = parse str != End
   end
end
