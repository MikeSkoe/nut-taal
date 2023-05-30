include AbstractDict

module Marks: MARKS = {
   let noun = "a"
   let verb = "i"
   let ad = "e"
}

module Loader = {
   let loadDict: string => promise<MyDict.t<list<string>>>
      = async url => {
         open Belt.List;

         let fetched = await Fetch.fetch(url);
         let text = await Fetch.Response.text(fetched);
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
   let conjunctionsUrl = "conjunctions.csv"
}
