

import Ava from "ava";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Language from "../src/library/language.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function show(t) {
  return t;
}

function parse(t) {
  return Caml_option.some(t);
}

function getNounDef(param) {
  return "noun";
}

function getVerbDef(param) {
  return "verb";
}

function getAdDef(param) {
  return "ad";
}

function getDescription(param) {
  return "descr";
}

var all = Promise.resolve(/* [] */0);

var MockTermDict = {
  show: show,
  parse: parse,
  getNounDef: getNounDef,
  getVerbDef: getVerbDef,
  getAdDef: getAdDef,
  getDescription: getDescription,
  all: all
};

function show$1(t) {
  return t;
}

function parse$1(t) {
  return Caml_option.some(t);
}

function mem(word) {
  return word === "en";
}

function getDef(param) {
  return "def";
}

function getDescription$1(param) {
  return "descr";
}

var all$1 = Promise.resolve(/* [] */0);

var MockConjDict = {
  show: show$1,
  parse: parse$1,
  nounMark: "a",
  verbMark: "i",
  adMark: "e",
  mem: mem,
  getDef: getDef,
  getDescription: getDescription$1,
  all: all$1
};

function wrapNoun(str, param) {
  return str;
}

function wrapVerb(str, param) {
  return str;
}

function wrapAd(str, param) {
  return str;
}

function wrapConj(str, param) {
  return str;
}

function wrapMark(str) {
  return str;
}

function wrapPunctuation(param) {
  return "";
}

var MockShower = {
  wrapNoun: wrapNoun,
  wrapVerb: wrapVerb,
  wrapAd: wrapAd,
  wrapConj: wrapConj,
  wrapMark: wrapMark,
  wrapPunctuation: wrapPunctuation
};

var Lang = Language.Make(MockTermDict, MockConjDict, MockShower);

Ava("foo", (async function (t) {
        var parseAndShowAsString = function (str) {
          return Belt_List.reduce(Curry._1(Lang.Lexs.show, Curry._1(Lang.Lexs.parse, str)), "", (function (a, b) {
                          return "" + a + " " + b + "";
                        })).trim();
        };
        t.deepEqual(parseAndShowAsString("x0"), "x0", undefined);
        t.deepEqual(parseAndShowAsString("x0 x1"), "x0 x1", undefined);
        t.deepEqual(parseAndShowAsString("x0 i x1"), "x0 x1", undefined);
        t.deepEqual(parseAndShowAsString("x0 e x1 x2 i x3"), "x0 e x1 x2 i x3", undefined);
        t.deepEqual(parseAndShowAsString("x0 e x1 x2 a x3"), "x0 e x1 x2 a x3", undefined);
        t.deepEqual(parseAndShowAsString("x0 e x1 en x2 a x3"), "x0 e x1 en x2 a x3", undefined);
      }));

export {
  MockTermDict ,
  MockConjDict ,
  MockShower ,
  Lang ,
}
/* all Not a pure module */
