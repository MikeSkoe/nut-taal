module type PARSABLE = sig
   type t
   val show : t -> string
   val parse : string -> t option
end

module type SHOWER = sig
   type t
   (* First string is the word, the second is translation *)
   val wrapNoun : string -> string -> t
   val wrapVerb : string -> string -> t
   val wrapAd : string -> string -> t
   val wrapConj : string -> string -> t
   val wrapMark : string -> t
   val wrapPunctuation : string -> t
end

type term = {
   str: string;
   noun: string;
   verb: string;
   ad: string;
   description: string;
}

type conjTerm = {
   str: string;
   definition: string;
   description: string;
}

module type CONJ_DICTIONARY = sig
   include PARSABLE with type t := conjTerm
   val nounMark : string
   val verbMark : string
   val adMark : string
   val mem : string -> bool
   val all : conjTerm list promise
end

module type TERMIN_DICTIONARY = sig
   include PARSABLE with type t := term
   (* TODO: should "mem" function be implemented? *)
   val all : term list promise
end
