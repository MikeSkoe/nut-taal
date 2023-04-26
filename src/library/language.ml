include AbstractDict

let combMark = '-'
let combMarkString = "-"

module Make
   (TD: TERMIN_DICTIONARY)
   (CD: CONJ_DICTIONARY)
   (SH: SHOWER)
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
         | Start of t
         | Noun of Roots.t * t
         | Verb of Roots.t * t
         | Ad of Roots.t * t
         | Con of Conjs.t * t
         | End

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
            |> fun lex -> Start lex

         let mem str = parse str != End

      let show lex =
         let n = SH.wrapNoun in
         let v = SH.wrapVerb in
         let a = SH.wrapAd in
         let m = SH.wrapMark in
         let p = SH.wrapPunctuation in
         let c = SH.wrapConj in
         let nd root = Roots.(fold root TD.getNounDef "unknown") in
         let vd root = Roots.(fold root TD.getVerbDef "unknown") in
         let ad root = Roots.(fold root TD.getAdDef "unknown") in
         let cd root = Conjs.(fold root CD.getDef "unknown") in
         let rec iter lex = match lex with
            | End -> [p(".")]

            | Noun(root, Ad(root', next))
               -> n Roots.(show root)  (nd root) :: m(CD.adMark) :: (iter @@ Ad(root', next))
            | Verb(root, Ad(root', next))
               -> v Roots.(show root) (vd root) :: m(CD.adMark) :: (iter @@ Ad(root', next))

            | Noun(root, Noun(root', next))
               -> n Roots.(show root) (nd root) :: m(CD.nounMark) :: (iter @@ Noun(root', next))
            | Verb(root, Verb(root', next))
               -> v Roots.(show root) (vd root) :: m(CD.verbMark) :: (iter @@ Verb(root', next))

            | Noun(root, next)
               -> n Roots.(show root) (nd root) :: iter next
            | Verb(root, next)
               -> v Roots.(show root) (vd root) :: iter next

            | Start(Ad(root, next))
               -> (m CD.adMark) :: (iter @@ Ad(root, next))
            | Ad(root, Noun(root', next))
               -> a Roots.(show root) (ad root) :: m(CD.nounMark) :: (iter @@ Noun(root', next))
            | Ad(root, Verb(root', next))
               -> a Roots.(show root) (ad root) :: m(CD.verbMark) :: (iter @@ Verb(root', next))
            | Ad(root, next)
               -> a Roots.(show root) (ad root) :: iter next

            | Con(conj, next)
               -> c Conjs.(show conj) (cd conj) :: iter next
            | Start(next) -> iter next
         in
         iter lex
   end
end
