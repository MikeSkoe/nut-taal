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
