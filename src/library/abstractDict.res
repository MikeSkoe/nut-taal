module type SHOWER = {
   type t;
   // First string is the word, the second is translation
   let wrapNoun : list<(bool, string, string)> => t;
   let wrapVerb : list<(bool, string, string)> => t;
   let wrapAd : list<(bool, string, string)> => t;
   let wrapConj : (string, string) => t;
   let wrapMark : string => t;
   let wrapPunctuation : string => t;
}

type term = {
   str: string,
   noun: string,
   verb: string,
   ad: string,
   description: string,
}

type conjTerm = {
   str: string,
   definition: string,
   description: string,
}

let emptyTerm: term = { str: "", noun: "", verb: "", ad: "", description: "" }
let emptyConjTerm: conjTerm = { str: "", definition: "", description: "" }

module type CONJ_DICTIONARY = {
   let nounMark : string
   let verbMark : string
   let adMark : string
   let mem : string => bool
   let show : conjTerm => string
   let translate : string => promise<option<conjTerm>>
}

module type TERMIN_DICTIONARY = {
   let show : term => string
   let translate : string => promise<option<term>>
}
