include AbstractDict

let combMark = '-'
let combMarkString = "-"

module Make = (
   TD: TERMIN_DICTIONARY,
   CD: CONJ_DICTIONARY,
   SH: SHOWER,
) => {
   module Roots = {
      type rec t =
         | Root(term, t)
         | Prop(string)
         | End

      let fold = (t, fn, default) => switch t {
         | Root(t, _) => fn(t)
         | Prop(_) | End => default
      }

      let show = t => {
         let rec iter = t => switch t {
            | Root(term, next) => list{TD.show(term), ...iter(next)}
            | Prop(str) => list{str}
            | End => list{}
         }
         iter(t)
         ->Belt.List.reduce(
            "",
            (acc, curr) => acc == "" ? curr : `${acc}${combMarkString}${curr}`
         )
      }

      let parse = str => {
         let rec iter = str => switch str {
            | list{word, ...next} => {
               let compound = list{word, ...next}
                  ->Belt.List.reduce("",
                     (acc, curr) => acc == "" ? curr : `${acc}${combMarkString}${curr}`,
                  );
               switch TD.parse(compound) {
                  | Some(word) => Root(word, End)
                  | None => switch TD.parse(word) {
                     | Some(word) => Root(word, iter(next))
                     | None => Prop(word)
                  }
               }
            }
            | list{} => End
         }
         iter(str |> String.split_on_char(combMark))
      }
   }

   module Conjs = {
      type t =
         | Conj(conjTerm)
         | End

      let fold = (t, fn, default) => switch t {
         | Conj(t) => fn(t)
         | End => default
      }

      let show = t => switch t {
        | Conj(str) => CD.show(str)
        | End => ""
      }
   
      let parse = str => switch CD.parse(str) {
         | Some(str) => Conj(str)
         | None => End
      }
   }

   module Lexs = {
      type rec t =
         | Start(t)
         | Noun(Roots.t, t)
         | Verb(Roots.t, t)
         | Ad(Roots.t, t)
         | Con(Conjs.t, t)
         | End

      let isMark = str => str->List.mem(list{CD.nounMark, CD.verbMark, CD.adMark})

      type pending = P_N | P_V | P_A

      let parse = str => {
         let rec iter = (pending, strs) => switch (pending, strs) {
            | (_, list{}) 
               => End
            
            | (_, list{conj, ...next}) when CD.mem(conj)
               => Con(Conjs.parse(conj), iter(P_N, next))

            | (_, list{mark, word, ...next}) when mark == CD.nounMark && !isMark(word)
               => Noun(Roots.parse(word), iter(P_V, next))
            | (_, list{mark, word, ...next}) when mark == CD.verbMark && !isMark(word)
               => Verb(Roots.parse(word), iter(P_N, next))
            | (_, list{mark, word, ...next}) when mark == CD.adMark && !isMark(word)
               => Ad(Roots.parse(word), iter(P_A, next))

            | (P_N, list{word, ...next})
               => Noun(Roots.parse(word), iter(P_V, next))
            | (P_V, list{word, ...next})
               => Verb(Roots.parse(word), iter(P_N, next))
            | (P_A, list{word, ...next})
               => Ad(Roots.parse(word), iter(P_A, next))
         }
         String.trim(str)
         |> String.split_on_char(' ')
         |> iter(P_N)
         |> lex => Start(lex)
      }

      let mem = str => parse(str) != End;

      let show = lex => {
         let m = SH.wrapMark;
         let c = conj => SH.wrapConj(
            Conjs.show(conj),
            Conjs.fold(conj, t => t.definition, "unknown"),
         );
         let rec iterRoot = (readTerm, noun) => switch noun {
            | Roots.Root(term, next) => list{(true, term.str, readTerm(term)), ...iterRoot(readTerm, next)}
            | Roots.Prop(term) => list{(false, term, "unknown")}
            | Roots.End => list{}
         }
         let n = root => SH.wrapNoun(iterRoot(term => term.noun, root))
         let v = root => SH.wrapVerb(iterRoot(term => term.verb, root))
         let a = root => SH.wrapAd(iterRoot(term => term.ad, root));
         let rec iter = lex => switch lex {
            | End => list{}

            | Noun(root, Ad(root', next))
               => list{
                  n(root),
                  m(CD.adMark),
                  ...iter(Ad(root', next))
               }
            | Verb(root, Ad(root', next))
               => list{v(root), m(CD.adMark), ...iter(Ad(root', next))}

            | Noun(root, Noun(root', next))
               => list{
                  n(root),
                  m(CD.nounMark),
                  ...iter(Noun(root', next)),
               }
            | Verb(root, Verb(root', next))
               => list{v(root), m(CD.verbMark), ...iter(Verb(root', next))}

            | Noun(root, next)
               => list{n(root), ...iter(next)}
            | Verb(root, next)
               => list{v(root), ...iter(next)}

            | Start(Ad(root, next))
               => list{m(CD.adMark), ...iter(Ad(root, next))}
            | Ad(root, Noun(root', next))
               => list{a(root), m(CD.nounMark), ...iter(Noun(root', next))}
            | Ad(root, Verb(root', next))
               => list{a(root), m(CD.verbMark), ...iter(Verb(root', next))}
            | Ad(root, next)
               => list{a(root), ...iter(next)}

            | Con(conj, Ad(root, next))
               => list{c(conj), m(CD.adMark), ...iter(Ad(root, next))}
            | Con(conj, Verb(root, next))
               => list{c(conj), m(CD.verbMark), ...iter(Verb(root, next))}
            | Con(conj, next)
               => list{c(conj), ...iter(next)}
            | Start(next) => iter(next)
         }
         iter(lex)
      }
   }
}
