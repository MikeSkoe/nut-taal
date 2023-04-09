module type PARSABLE  =
  sig
    type t
    val show : t -> string
    val parse : string -> t
    val mem : string -> bool
  end

type root =
  | End
  | Root of string * root
  | Prop of string

type conj =
  | End
  | Conj of string

type lex =
  | End
  | Noun of root * lex
  | Verb of root * lex
  | Ad of root * lex
  | Con of conj * lex

module Roots : (PARSABLE with type t := root) = struct
  let mem = Dictionary.mem
  let show t =
    let rec iter t = match t with
      | Root(str, next) -> str :: iter next
      | Prop(str) -> [str]
      | End -> []
    in
    iter t
    |> List.fold_left (fun acc curr -> if acc = "" then curr else acc ^ "+" ^ curr) ""

  let parse str =
    let rec iter strings = match strings with
      | word :: next when mem word -> Root(word, iter next)
      | word :: _ -> Prop(word)
      | _ -> End in
    str |> String.split_on_char '+' |> iter
end

module Conjs : (PARSABLE with type t := conj) = struct
  let mem = Dictionary.conjMem
  let show t = match t with
    | Conj str -> str
    | End -> ""

  let parse str = if mem str then Conj str else End
end

module type LEX = sig
      include PARSABLE with type t := lex
      val nounMark: string
      val verbMark: string
      val adMark : string
      val isMark: string -> bool
end

module Lexs : LEX = struct
  let nounMark = "a"
  let verbMark = "i"
  let adMark = "e"
  let isMark str = List.mem str [nounMark; verbMark; adMark]

  let show lex =
    let rec iter lex = match lex with
      | End -> []
      | Noun(root, next) -> nounMark :: Roots.show root :: iter next
      | Verb(root, next) -> verbMark :: Roots.show root :: iter next
      | Ad(root, next) -> adMark :: Roots.show root :: iter next
      | Con(conj, next) -> Conjs.show conj :: iter next
    in
    (match iter lex with
      | word :: next when word = nounMark -> next
      | words -> words
    )
    |> List.fold_left (fun acc curr -> acc ^ " " ^ curr) ""

  let parse str =
    let rec iter strs = match strs with
      | mark :: word :: next when mark = nounMark ->
        Noun(Roots.parse word, iter next)
      | mark :: word :: next when mark = verbMark ->
        Verb(Roots.parse word, iter next)
      | mark :: word :: next when mark = adMark ->
        Ad(Roots.parse word, iter next)
      | mark :: next when Conjs.mem mark -> 
        Con(Conjs.parse mark, iter next)
      | word :: next -> iter (adMark :: word :: next)
      | [] -> End
    in
    match
      str
      |> String.trim
      |> String.split_on_char ' '
    with
      | mark :: next when isMark mark -> iter (mark :: next)
      | next -> iter (nounMark :: next)

    let mem str = parse str != End
end
