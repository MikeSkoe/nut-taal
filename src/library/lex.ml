module type PARSABLE  =
  sig
    type t
    val show : t -> string
    val parse : string -> t
    val mem : string -> bool
  end

module Root : PARSABLE = struct
  let roots = ["mi"; "you"; "love"; "big"; "not"]
  type t = End | Root of string * t

  let mem str = List.mem str roots

  let show t =
    let rec iter t = match t with
      | Root(str, next) -> str :: iter next
      | End -> []
    in
    iter t
    |> List.fold_left (fun acc curr -> if acc = "" then curr else acc ^ "+" ^ curr) ""

  let parse str =
    let rec iter strings = match strings with
      | word :: next when mem word -> Root(word, iter next)
      | _ -> End in
    str |> String.split_on_char '+' |> iter
end

module Conj : PARSABLE = struct
  let roots = ["and"; "or"; "if"]
  type t = End | Conj of string

  let mem str = List.mem str roots

  let show t = match t with
    | Conj str -> str
    | End -> ""

  let parse str = if mem str then Conj str else End
end

module Lex : PARSABLE  = struct
  let nounMark = "a"
  let verbMark = "i"
  let adMark = "e"
  let isMark str = List.mem str [nounMark; verbMark; adMark]

  type t =
    | End
    | Noun of Root.t * t
    | Verb of Root.t * t
    | Ad of Root.t * t
    | Conj of Conj.t * t

  let show lex =
    let rec iter lex = match lex with
      | End -> []
      | Noun(root, next) -> nounMark :: Root.show root :: iter next
      | Verb(root, next) -> verbMark :: Root.show root :: iter next
      | Ad(root, next) -> adMark :: Root.show root :: iter next
      | Conj(conj, next) -> Conj.show conj :: iter next
    in
    iter lex |> List.fold_left (fun acc curr -> acc ^ " " ^ curr) ""

  let parse str =
    let rec iter strs = match strs with
      | mark :: word :: next when mark = nounMark ->
        Noun(Root.parse word, iter next)
      | mark :: word :: next when mark = verbMark ->
        Verb(Root.parse word, iter next)
      | mark :: word :: next when mark = adMark ->
        Ad(Root.parse word, iter next)
      | mark :: next when Conj.mem mark -> 
        Conj(Conj.parse mark, iter next)
      | word :: next -> iter (adMark :: word :: next)
      | [] -> End
    in
    match String.split_on_char ' ' str with
      | mark :: next when isMark mark -> iter (mark :: next)
      | next -> iter (nounMark :: next)

    let mem str = parse str != End
end