

import * as $$Map from "rescript/lib/es6/map.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Fetch from "bs-fetch/src/Fetch.mjs";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

var MyDict = $$Map.Make({
      compare: $$String.compare
    });

function loadDict(url, dict, makeEntity) {
  return Js_promise.then_((function (text) {
                var words = Belt_List.map($$String.split_on_char(/* '\n' */10, text), (function (param) {
                        return $$String.split_on_char(/* ';' */59, param);
                      }));
                dict.contents = Belt_List.reduce(words, dict.contents, (function (acc, line) {
                        return Curry._3(MyDict.add, Belt_List.getExn(line, 0), Curry._1(makeEntity, line), acc);
                      }));
                return Promise.resolve(dict.contents);
              }), Js_promise.then_(Fetch.$$Response.text, fetch(url)));
}

var Utils = {
  loadDict: loadDict
};

var dict = {
  contents: MyDict.empty
};

var compDict = {
  contents: MyDict.empty
};

var dictProm = loadDict("dictionary.csv", dict, (function (line) {
        return {
                str: Belt_List.getExn(line, 0),
                noun: Belt_List.getExn(line, 1),
                verb: Belt_List.getExn(line, 2),
                ad: Belt_List.getExn(line, 3),
                description: Belt_List.getExn(line, 4)
              };
      }));

var compoundProm = loadDict("compound.csv", compDict, (function (line) {
        return {
                str: Belt_List.getExn(line, 0),
                noun: Belt_List.getExn(line, 1),
                verb: Belt_List.getExn(line, 2),
                ad: Belt_List.getExn(line, 3),
                description: Belt_List.getExn(line, 4)
              };
      }));

var all = Js_promise.then_((function (param) {
        var bindings = Belt_List.concat(Curry._1(MyDict.bindings, param[0]), Curry._1(MyDict.bindings, param[1]));
        return Promise.resolve(Belt_List.map(bindings, (function (param) {
                          return param[1];
                        })));
      }), Promise.all([
          dictProm,
          compoundProm
        ]));

function parse(string) {
  return Curry._2(MyDict.find_opt, string, dict.contents);
}

function show(param) {
  return param.str;
}

function getAdDef(param) {
  return param.ad;
}

function getNounDef(param) {
  return param.noun;
}

function getVerbDef(param) {
  return param.verb;
}

function getDescription(param) {
  return param.description;
}

var Term = {
  show: show,
  parse: parse,
  getNounDef: getNounDef,
  getVerbDef: getVerbDef,
  getAdDef: getAdDef,
  getDescription: getDescription,
  all: all
};

var dict$1 = {
  contents: MyDict.empty
};

var dictProm$1 = loadDict("particles.csv", dict$1, (function (line) {
        return {
                str: Belt_List.getExn(line, 0),
                definition: Belt_List.getExn(line, 1),
                description: Belt_List.getExn(line, 2)
              };
      }));

var all$1 = Js_promise.then_((function (dict) {
        return Promise.resolve(Belt_List.map(Curry._1(MyDict.bindings, dict), (function (param) {
                          return param[1];
                        })));
      }), dictProm$1);

function mem(key) {
  return Belt_Option.isSome(Curry._2(MyDict.find_opt, key, dict$1.contents));
}

function parse$1(key) {
  return Curry._2(MyDict.find_opt, key, dict$1.contents);
}

function show$1(param) {
  return param.str;
}

function getDef(param) {
  return param.definition;
}

function getDescription$1(param) {
  return param.description;
}

var Conj = {
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

export {
  MyDict ,
  Utils ,
  Term ,
  Conj ,
}
/* MyDict Not a pure module */
