open Ava
open AbstractDict
open Belt

module MockShower: (SHOWER with type t = string) = {
   type t = string;

   let noun = str => `n:${str}`;
   let verb = str => `v:${str}`;
   let ad = str => `a:${str}`;
   let con = str => `c:${str}`;
   let mark = str => `m:${str}`;
}

module MockLang = Language.Make (Dictionary.Marks) (MockShower)

asyncTest("foo", async t => try {
    let dict = await Dictionary.Loader.loadDict("http://localhost:5173/dictionary.csv");
    let conjunctions = await Dictionary.Loader.loadDict("http://localhost:5173/conjunctions.csv");
    
    let translateAndPickFirst: string => string
        = term =>
            term
            -> MockLang.translate(dict)
            -> Option.mapWithDefault(term,
                list => list -> List.get(1) -> Option.getWithDefault(term),
            );

    let reparseMap: (string => string, string) => string
        = (mapFn, str) => {
            conjunctions
            -> MockLang.parse(str)
            -> MockLang.map(mapFn)
            -> MockLang.show
            -> List.reduce("", (a, b) => a === "" ? b : `${a} ${b}`)
        }

    let reparse = reparseMap(a => a);
    let translate = reparseMap(translateAndPickFirst);

    t->Assert.deepEqual(reparse("my lief kat"),
        "n:my v:lief n:kat", ());
    t->Assert.deepEqual(translate("my lief kat"),
        "n:me v:love n:cat", ());
    t->Assert.deepEqual(translate("my lief kat maar kat nie-lief my"),
        "n:me v:love n:cat c:maar n:cat v:not n:me", ());
} catch {
    | _ => Js.Exn.raiseError("Run `yarn start` with (default) port 5173")
});
