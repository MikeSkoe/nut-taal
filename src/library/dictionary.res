include AbstractDict

module MyDict = Map.Make(String)

module Utils = {
   let loadDict: (string, ref<MyDict.t<'a>>, list<MyDict.key> => 'a) => promise<MyDict.t<'a>>
      = async (url, dict, makeEntity) => {
         open Js.Promise;
         open Belt.List;

         let text = await (Fetch.fetch(url) |> then_(Fetch.Response.text));
         let words = 
            String.split_on_char('\n', text)
            -> map(String.split_on_char(','));

         dict :=
            words
            -> reduce(dict.contents,
               (acc, line) =>
                  line
                  -> getExn(0)
                  -> MyDict.add(makeEntity(line), acc),
            );

         dict.contents;
      }
}

module Term: TERMIN_DICTIONARY = {
   let dict: ref<MyDict.t<term>>
      = ref(MyDict.empty)

   let dictProm: promise<MyDict.t<term>>
      = Utils.loadDict(
         "dictionary.csv",
         dict,
         line => {
            let at = Belt.List.getExn(line);
            { str: at(0), noun: at(1), verb: at(2), ad: at(3), description: at(4) }
         },
      );

   let all: promise<list<term>>
      = dictProm |> Js.Promise.then_ (dict =>
         MyDict.bindings(dict)
         -> Belt.List.map(((_, term)) => term)
         -> Js.Promise.resolve
      );

   let translate: string => promise<option<term>>
      = async string => (await all) -> Belt.List.getBy(term => term.str == string);

   let parse: MyDict.key => option<term> 
      = string => MyDict.find_opt(string, dict.contents);

   let show: term => string
      = ({ str }) => str;
}

module Conj: CONJ_DICTIONARY = {
   let nounMark = "a"
   let verbMark = "i"
   let adMark = "e"

   let dict: ref<MyDict.t<conjTerm>> = ref(MyDict.empty);

   let dictProm: promise<MyDict.t<conjTerm>>
      = Utils.loadDict(
         "particles.csv",
         dict,
         line => {
            let at = Belt.List.getExn(line);
            { str: at(0), definition: at(1), description: at(2) };
         }
      );

   let all: promise<list<conjTerm>>
      = dictProm |> Js.Promise.then_(dict =>
         MyDict.bindings(dict)
         -> Belt.List.map(((_, term)) => term)
         -> Js.Promise.resolve
      )
   
   let translate: string => promise<option<conjTerm>>
      = async string => (await all) -> Belt.List.getBy(term => term.str == string);

   let mem: MyDict.key => bool
      = key =>
         key
         -> MyDict.find_opt(dict.contents)
         -> Belt.Option.isSome;

   let parse: MyDict.key => option<conjTerm>
      = key => key -> MyDict.find_opt(dict.contents)

   let show: conjTerm => string
      = ({ str }) => str
}
