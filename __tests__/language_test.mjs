

import Ava from "ava";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Language from "../src/library/language.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

function show(t) {
  return t.str;
}

function parse(str) {
  return {
          str: str,
          noun: str,
          verb: str,
          ad: str,
          description: str
        };
}

function translate(param) {
  return Promise.resolve(undefined);
}

var MockTermDict = {
  show: show,
  parse: parse,
  translate: translate
};

function show$1(t) {
  return t.str;
}

function parse$1(str) {
  return {
          str: str,
          definition: str,
          description: str
        };
}

function translate$1(param) {
  return Promise.resolve(undefined);
}

function mem(word) {
  return word === "en";
}

var MockConjDict = {
  show: show$1,
  parse: parse$1,
  nounMark: "a",
  verbMark: "i",
  adMark: "e",
  mem: mem,
  translate: translate$1
};

function drawMock(root) {
  return Belt_List.reduce(Belt_List.map(root, (function (param) {
                    return param[1];
                  })), "", (function (acc, curr) {
                if (acc === "") {
                  return curr;
                } else {
                  return "" + acc + "-" + curr + "";
                }
              }));
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
  wrapNoun: drawMock,
  wrapVerb: drawMock,
  wrapAd: drawMock,
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
/* Lang Not a pure module */
