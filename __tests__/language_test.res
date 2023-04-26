open Ava
open AbstractDict

module MockTermDict: AbstractDict.TERMIN_DICTIONARY = {
  let show = (t: term) => t.str
  let parse = str => Some({
    str: str,
    noun: str,
    verb: str,
    ad: str,
    description: str,
  })
  let all = Js.Promise.resolve(list{});
}

module MockConjDict: AbstractDict.CONJ_DICTIONARY = {
  let nounMark = "a"
  let verbMark = "i"
  let adMark = "e"
  let show = (t: conjTerm) => t.str
  let parse = str => Some({
    str: str,
    definition: str,
    description: str,
  })
  let mem = word => word == "en"
  let all = Js.Promise.resolve(list{})
}

module MockShower: AbstractDict.SHOWER with type t = string = {
   type t = string
   let drawMock = root => root
    ->Belt.List.map(((_, str, _)) => str)
    ->Belt.List.reduce("", (acc, curr) => acc == "" ? curr : `${acc}-${curr}`)
   let wrapNoun = drawMock;
   let wrapVerb = drawMock;
   let wrapAd = drawMock;
   let wrapConj = (str, _) => str;
   let wrapMark = str => str;
   let wrapPunctuation = _ => "";
}

module Lang = Language.Make (MockTermDict) (MockConjDict) (MockShower)

asyncTest("foo", async t => {
  open Lang

  let parseAndShowAsString = str =>
    str
    ->Lexs.parse
    ->Lexs.show
    ->Belt.List.reduce("", (a, b) => `${a} ${b}`)
    ->Js.String2.trim;

  t->Assert.deepEqual(
    "x0"->parseAndShowAsString,
    "x0", ()
  );
  t->Assert.deepEqual(
    "x0 x1"->parseAndShowAsString,
    "x0 x1", ()
  );
  t->Assert.deepEqual(
    "x0 i x1"->parseAndShowAsString,
    "x0 x1", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 x2 i x3"->parseAndShowAsString,
    "x0 e x1 x2 i x3", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 x2 a x3"->parseAndShowAsString,
    "x0 e x1 x2 a x3", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 en x2 a x3"->parseAndShowAsString,
    "x0 e x1 en x2 a x3", ()
  );
})
