include AbstractDict

module MyDict = Map.Make(String)

module Utils = {
   let loadDict = (url, dict, makeEntity) =>
      Fetch.fetch(url)
      |> Js.Promise.then_(Fetch.Response.text)
      |> Js.Promise.then_(text => {
         let words = 
            text
            ->String.split_on_char('\n', _)
            ->Belt.List.map(String.split_on_char(','));
         dict :=
            words
            ->Belt.List.reduce(
               dict.contents,
               (acc, line) => line->Belt.List.getExn(0)->MyDict.add(makeEntity(line), acc),
            );
         Js.Promise.resolve(dict.contents)
      })
}

module Term: TERMIN_DICTIONARY = {
   let dict: ref<MyDict.t<term>> = ref(MyDict.empty)

   let dictProm = "dictionary.csv"
      ->Utils.loadDict(
         dict,
         line => ({
            str: Belt.List.getExn(line, 0),
            noun: Belt.List.getExn(line, 1),
            verb: Belt.List.getExn(line, 2),
            ad: Belt.List.getExn(line, 3),
            description: Belt.List.getExn(line, 4),
         }),
      )

   let all =
      dictProm
      |> Js.Promise.then_ (dict =>
         MyDict.bindings(dict)
         ->Belt.List.map(((_, term)) => term)
         ->Js.Promise.resolve
      );

   let parse = string => MyDict.find_opt(string, dict.contents);
   let show = ({ str }: term) => str;
}

module Conj: CONJ_DICTIONARY = {
   let nounMark = "a"
   let verbMark = "i"
   let adMark = "e"

   let dict: ref<MyDict.t<conjTerm>> = ref(MyDict.empty);
   
   let dictProm = "particles.csv"
      ->Utils.loadDict(
         dict,
         line => ({
            str: Belt.List.getExn(line, 0),
            definition: Belt.List.getExn(line, 1),
            description: Belt.List.getExn(line, 2),
         }),
      );

   let all = dictProm
      |> Js.Promise.then_(dict =>
         MyDict.bindings(dict)
         ->Belt.List.map(((_, term)) => term)
         -> Js.Promise.resolve
      )

   let mem = key => key->MyDict.find_opt(dict.contents)->Belt.Option.isSome
   let parse = key => key->MyDict.find_opt(dict.contents)
   let show = ({ str }: conjTerm) => str
}
