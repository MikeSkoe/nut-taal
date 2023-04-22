open Ava

module MockTermDict: AbstractDict.TERMIN_DICTIONARY with type t = string = {
  type t = string;
  let show = t => t
  let parse = t => Some(t)
  let getNounDef = _ => "noun"
  let getVerbDef = _ => "verb"
  let getAdDef = _ => "ad"
  let getDescription = _ => "descr"
  let all = Js.Promise.resolve(list{});
}

module MockConjDict: AbstractDict.CONJ_DICTIONARY with type t = string = {
  type t = string;
  let show = t => t
  let parse = t => Some(t)
  let nounMark = "a"
  let verbMark = "i"
  let adMark = "e"
  let mem = word => word == "en"
  let getDef = _ => "def"
  let getDescription = _ => "descr"
  let all = Js.Promise.resolve(list{})
}

module Lang = Language.Make (MockTermDict) (MockConjDict)

asyncTest("foo", async t => {
  open Lang

  t->Assert.deepEqual(
    "x0"->Lexs.parse->Lexs.show,
    "x0", ()
  );
  t->Assert.deepEqual(
    "x0 x1"->Lexs.parse->Lexs.show,
    "x0 x1", ()
  );
  t->Assert.deepEqual(
    "x0 i x1"->Lexs.parse->Lexs.show,
    "x0 x1", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 x2 i x3"->Lexs.parse->Lexs.show,
    "x0 e x1 x2 i x3", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 x2 a x3"->Lexs.parse->Lexs.show,
    "x0 e x1 x2 a x3", ()
  );
  t->Assert.deepEqual(
    "x0 e x1 en x2 a x3"->Lexs.parse->Lexs.show,
    "x0 e x1 en x2 a x3", ()
  );
})
