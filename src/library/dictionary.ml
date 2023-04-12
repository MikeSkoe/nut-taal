module MyDict = Map.Make(String)

module Utils = struct
   let loadDict url dict makeEntity = (Fetch.fetch url)
      |> Js.Promise.then_ Fetch.Response.text
      |> Js.Promise.then_ (fun text ->
         let words = Belt.List.map
            (String.split_on_char '\n' text)
            (String.split_on_char ',')
         in
         dict := Belt.List.reduce
            words
            dict.contents
            (fun acc line ->
               MyDict.add
               (Belt.List.getExn line 0)
               (makeEntity line)
               acc
            );
         Js.Promise.resolve ()
      )
end

module Term: Language.TERMIN_DICTIONARY = struct
   type t = {
      str: string;
      nounDefinition: string;
      verbDefinition: string;
      adjectiveDefinition: string;
      adverbDefinition: string;
      description: string;
   }

   let dict: t MyDict.t ref = ref MyDict.empty

   let _ = Utils.loadDict "/dictionary.csv" dict
      (fun line -> ({
         str=(Belt.List.getExn line 0);
         nounDefinition=(Belt.List.getExn line 1);
         verbDefinition=(Belt.List.getExn line 2);
         adjectiveDefinition=(Belt.List.getExn line 3);
         adverbDefinition=(Belt.List.getExn line 4);
         description=(Belt.List.getExn line 5);
      }))

   let all = Belt.List.map (MyDict.bindings dict.contents) (fun (_, term) -> term)

   let parse string = MyDict.(find_opt string dict.contents)
   let getAdjDef { adjectiveDefinition } = adjectiveDefinition
   let getAdvDef { adverbDefinition } = adverbDefinition
   let getNounDef { nounDefinition } = nounDefinition
   let getVerbDef { verbDefinition } = verbDefinition
   let getDescription { description } = description
   let show { str } = str
end

module Conj: Language.CONJ_DICTIONARY = struct
   let nounMark = "a"
   let verbMark = "i"
   let adMark = "e"

   type t = {
         str: string;
         definition: string;
         description: string;
   }

   let dict: t MyDict.t ref = ref MyDict.empty
   
   let _ = Utils.loadDict "/auxiliary.csv" dict
      (fun line -> ({
         str=(Belt.List.getExn line 0);
         definition=(Belt.List.getExn line 1);
         description=(Belt.List.getExn line 2);
      }))

   let all = Belt.List.map (MyDict.bindings dict.contents) (fun (_, term) -> term)

   let mem key = Belt.Option.isSome MyDict.(find_opt key dict.contents)
   let parse key = MyDict.find_opt key dict.contents
   let show { str } = str
   let getDef { definition } = definition
   let getDescription { description } = description
end
