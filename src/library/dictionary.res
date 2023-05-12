include AbstractDict

module Marks: MARKS = {
   let noun = "a"
   let verb = "i"
   let ad = "e"
}

module Loader = {
   let loadDict: string => promise<MyDict.t<list<string>>>
      = async url => {
         open Js.Promise;
         open Belt.List;

         let text = await (Fetch.fetch(url) |> then_(Fetch.Response.text));
         let words = 
            String.split_on_char('\n', text)
            -> map(String.split_on_char(','));

         words -> reduce(MyDict.empty,
            (acc, line) =>
               line
               -> getExn(0)
               -> MyDict.add(line, acc),
         );
      }

   let dictUrl = "dictionary.csv";
   let marksUrl = "conjugations.csv"
}
