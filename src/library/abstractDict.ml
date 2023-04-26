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

module type CONJ_DICTIONARY = sig
   include PARSABLE
   val nounMark : string
   val verbMark : string
   val adMark : string
   val mem : string -> bool
   val getDef : t -> string
   val getDescription : t -> string
   val all : t list promise
end

module type TERMIN_DICTIONARY = sig
   include PARSABLE
   val getNounDef : t -> string
   val getVerbDef : t -> string
   val getAdDef : t -> string
   val getDescription : t -> string
   val all : t list promise
end
