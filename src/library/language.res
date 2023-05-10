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
         | Prop(string, t)
         | End

      let fold: (t, term => 'a, 'a) => 'a
         = (t, fn, default) => switch t {
            | Root(t, _) => fn(t)
            | Prop(_) | End => default
         }

      let show: t => string
         = t => {
            let rec iter: t => list<string>
               = t => switch t {
                  | Root(term, next) => list{TD.show(term), ...iter(next)}
                  | Prop(str, next) => list{str, ...iter(next)}
                  | End => list{}
               }

            iter(t) -> Belt.List.reduce("",
               (acc, curr) => acc == "" ? curr : `${acc}${combMarkString}${curr}`
            )
         }

      let translate: string => promise<option<t>>
         = str => {
            let rec iter: list<string> => promise<option<t>>
               = async str => switch str {
                  | list{word, ...next} => {
                     let compound = list{word, ...next}
                        -> Belt.List.reduce("",
                           (acc, curr) => acc == "" ? curr : `${acc}${combMarkString}${curr}`,
                        );

                     switch await TD.translate(compound) {
                        | Some(word) => Some(Root(word, End))
                        | None => switch await TD.translate(word) {
                           | Some(word) => (await iter(next)) -> Belt.Option.map(next => Root(word, next))
                           | None => (await iter(next)) -> Belt.Option.map(next => Prop(word, next))
                        }
                     }
                  }
                  | list{} => Some(End)
               }

            String.split_on_char(combMark, str) -> iter
         }
   }

   module Conjs = {
      type t = Conj(conjTerm);

      let show: t => string
         = (Conj(str)) => CD.show(str);
   
      let fold: (t, conjTerm => 'a) => 'a
         = (Conj(conjTerm), fn) => fn(conjTerm)

      let translate: string => promise<option<t>>
         = async str =>
            (await CD.translate(str))
            -> Belt.Option.map(str => Conj(str));
   }

   module Lexs = {
      type rec t =
         | Start(t)
         | Noun(Roots.t, t)
         | Verb(Roots.t, t)
         | Ad(Roots.t, t)
         | Con(Conjs.t, t)
         | End;

      let isMark: string => bool
         = List.mem(_, list{CD.nounMark, CD.verbMark, CD.adMark})

      type pending = P_N | P_V | P_A;

      let parse: string => promise<option<t>>
         = async str => {
            let map2 = (
               a: option<'a>,
               b: option<'b>,
               fn: ('a, 'b) => option<'c>,
            ) => a -> Belt.Option.flatMap(a =>
                  b -> Belt.Option.flatMap(b => fn(a, b))
               )
            open Belt.Option;

            let rec iter: (pending, list<string>) => promise<option<t>>
               = async (pending, strs) => switch (pending, strs) {
                  | (_, list{}) 
                     => Some(End)

                  | (_, list{conj, ...next}) when CD.mem(conj)
                     => {
                        let conj = await Conjs.translate(conj);
                        let next = await iter(P_N, next);

                        conj -> flatMap(conj =>
                        next -> flatMap(next =>
                           Some(Con(conj, next))
                        ));
                     }

                  | (_, list{mark, word, ...next}) when mark == CD.nounMark && !isMark(word)
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_V, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Noun(word, next))
                        ))
                     }
                  
                  | (_, list{mark, word, ...next}) when mark == CD.verbMark && !isMark(word)
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_N, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Verb(word, next))
                        ))
                     }
                  | (_, list{mark, word, ...next}) when mark == CD.adMark && !isMark(word)
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_A, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Ad(word, next))
                        ))
                     }

                  | (P_N, list{word, ...next})
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_V, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Noun(word, next))
                        ))
                     }

                  | (P_V, list{word, ...next})
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_N, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Verb(word, next))
                        ))
                     }

                  | (P_A, list{word, ...next})
                     => {
                        let word = await Roots.translate(word);
                        let next = await iter(P_A, next);

                        word -> flatMap(word =>
                        next -> flatMap(next =>
                           Some(Ad(word, next))
                        ))
                     }
               }

            (await (String.trim(str) |> String.split_on_char(' ') |> iter(P_N)))
               -> Belt.Option.map(lex => Start(lex))
         }

      let show: t => list<SH.t>
         = lex => {
            let m = SH.wrapMark;
            let c: Conjs.t => SH.t
               = conj => SH.wrapConj(
                  Conjs.show(conj),
                  Conjs.fold(conj, t => t.definition),
               );

            let rec iterRoot: (term => string, Roots.t) => list<(bool, string, string)>
               = (readTerm, noun) => switch noun {
                  | Roots.Root(term, next) => list{(true, term.str, readTerm(term)), ...iterRoot(readTerm, next)}
                  | Roots.Prop(term, next) => list{(false, term, term), ...iterRoot(readTerm, next)}
                  | Roots.End => list{}
               };

            let n = root => SH.wrapNoun(iterRoot(term => term.noun, root))
            let v = root => SH.wrapVerb(iterRoot(term => term.verb, root))
            let a = root => SH.wrapAd(iterRoot(term => term.ad, root));

            let rec iter: t => list<SH.t>
             = lex => switch lex {
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
               | Start(Verb(root, next))
                  => list{m(CD.verbMark), ...iter(Ad(root, next))}

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

            iter(lex);
         }
   }
}
