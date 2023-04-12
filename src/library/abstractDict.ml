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
