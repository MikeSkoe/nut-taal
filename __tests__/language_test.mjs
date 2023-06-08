

import Ava from "ava";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Utils from "../src/Utils.mjs";
import * as Language from "../src/library/language.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "../src/library/dictionary.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function noun(str) {
  return "n:" + str + "";
}

function verb(str) {
  return "v:" + str + "";
}

function ad(str) {
  return "a:" + str + "";
}

function con(str) {
  return "c:" + str + "";
}

function mark(str) {
  return "m:" + str + "";
}

var MockShower = {
  noun: noun,
  verb: verb,
  ad: ad,
  con: con,
  mark: mark
};

var MockLang = Language.Make(Dictionary.Marks, MockShower);

Ava("foo", (async function (t) {
        var dict = await Dictionary.Loader.loadDict("http://localhost:5173/dictionary.csv");
        var conjunctions = await Dictionary.Loader.loadDict("http://localhost:5173/conjunctions.csv");
        var examplesText = await Utils.loadFile("http://localhost:5173/sentences");
        var sentences = Utils.parseExamples(examplesText);
        var translateAndPickFirst = function (term) {
          return Belt_Option.mapWithDefault(Curry._2(MockLang.translate, term, dict), term, (function (list) {
                        return Belt_Option.getWithDefault(Belt_List.get(list, 1), term);
                      }));
        };
        var reparseMap = function (mapFn, str) {
          return Belt_List.reduce(Curry._1(MockLang.show, Curry._2(MockLang.map, Curry._2(MockLang.parse, conjunctions, str), mapFn)), "", (function (a, b) {
                        if (a === "") {
                          return b;
                        } else {
                          return "" + a + " " + b + "";
                        }
                      }));
        };
        t.deepEqual(reparseMap((function (a) {
                    return a;
                  }), "my lief kat"), "n:my v:lief n:kat", undefined);
        t.deepEqual(reparseMap(translateAndPickFirst, "my lief kat"), "n:me v:love n:cat", undefined);
        t.deepEqual(reparseMap(translateAndPickFirst, "my lief kat maar kat nie-lief my"), "n:me v:love n:cat c:maar n:cat v:not n:me", undefined);
        t.snapshot(Belt_List.reduce(Belt_List.map(sentences, (function (param) {
                        return reparseMap((function (a) {
                                      return a;
                                    }), param[1]);
                      })), "", (function (a, b) {
                    return "" + a + "\n" + b + "";
                  })), undefined);
      }));

export {
  MockShower ,
  MockLang ,
}
/* MockLang Not a pure module */
