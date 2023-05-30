module MyDict = Map.Make(String)

module type SHOWER = {
   type t;
   let noun : string => t;
   let verb : string => t;
   let ad : string => t;
   let con : string => t;
   let mark : string => t;
}

type mark = Noun | Verb | Ad;

module type MARKS = {
   let noun: string;
   let verb: string;
   let ad: string;
}

module type LANGUAGE = {
   type t;
   type dictionary;
   type presentation;

   let empty : t;
   let translate : (string, dictionary) => option<list<string>>;
   let parse : (dictionary, string) => t;
   let show : t => list<presentation>;
   let map : (t, string => string) => t;
}
