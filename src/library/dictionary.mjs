

import * as Curry from "rescript/lib/es6/curry.js";
import * as Fetch from "bs-fetch/src/Fetch.mjs";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as AbstractDict from "./abstractDict.mjs";

var Marks = {
  noun: "an",
  verb: "te",
  ad: "om"
};

async function loadDict(url) {
  var fetched = await fetch(url);
  var text = await Fetch.$$Response.text(fetched);
  var words = Belt_List.map($$String.split_on_char(/* '\n' */10, text), (function (param) {
          return $$String.split_on_char(/* ',' */44, param);
        }));
  return Belt_List.reduce(words, AbstractDict.MyDict.empty, (function (acc, line) {
                return Curry._3(AbstractDict.MyDict.add, Belt_List.getExn(line, 0), line, acc);
              }));
}

var Loader = {
  loadDict: loadDict,
  dictUrl: "dictionary.csv",
  conjunctionsUrl: "conjunctions.csv"
};

var MyDict = AbstractDict.MyDict;

export {
  MyDict ,
  Marks ,
  Loader ,
}
/* AbstractDict Not a pure module */
