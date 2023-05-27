

import * as Hint from "./components/Hint/Hint.mjs";
import * as Lang from "./Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./components/Input/Input.mjs";
import * as Links from "./components/Links/Links.mjs";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "./library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as DictionaryContext from "./components/DictionaryContext/DictionaryContext.mjs";

import './app.css'
;

function useDictionary(param) {
  var match = React.useState(function () {
        
      });
  var setTermDict = match[1];
  var match$1 = React.useState(function () {
        
      });
  var setMarksDict = match$1[1];
  React.useEffect((function () {
          var __x = Promise.all([
                Dictionary.Loader.loadDict(Dictionary.Loader.dictUrl),
                Dictionary.Loader.loadDict(Dictionary.Loader.marksUrl)
              ]);
          Js_promise.then_((function (param) {
                  var marks = param[1];
                  var terms = param[0];
                  return Promise.resolve((Curry._1(setTermDict, (function (param) {
                                      return Caml_option.some(terms);
                                    })), Curry._1(setMarksDict, (function (param) {
                                      return Caml_option.some(marks);
                                    }))));
                }), __x);
        }), []);
  return [
          match[0],
          match$1[0]
        ];
}

function useHint(termDict, marksDict, query) {
  var match = React.useState(function () {
        
      });
  var setHint = match[1];
  React.useEffect((function () {
          Belt_Option.flatMap(termDict, (function (terms) {
                  return Belt_Option.flatMap(marksDict, (function (marks) {
                                Belt_Option.forEach(Belt_Option.orElse(Curry._2(Lang.Lang.translate, query, marks), Curry._2(Lang.Lang.translate, query, terms)), (function (translations) {
                                        Curry._1(setHint, (function (param) {
                                                return [
                                                        Belt_List.headExn(translations),
                                                        Belt_List.tailExn(translations)
                                                      ];
                                              }));
                                      }));
                              }));
                }));
        }), [
        query,
        termDict,
        marksDict
      ]);
  return match[0];
}

function App(props) {
  var match = React.useState(function () {
        return "taal";
      });
  var setQuery = match[1];
  var match$1 = useDictionary(undefined);
  var marksDict = match$1[1];
  var hint = useHint(match$1[0], marksDict, match[0]);
  return React.createElement(DictionaryContext.OnWordClickProvider.make, {
              value: (function (str) {
                  Curry._1(setQuery, (function (param) {
                          return str;
                        }));
                }),
              children: null
            }, React.createElement("h1", undefined, React.createElement("b", undefined, "nut-taal")), Belt_Option.getWithDefault(Belt_Option.map(marksDict, (function (marks) {
                        return React.createElement(Input.make, {
                                    marks: marks
                                  });
                      })), null), Belt_Option.getWithDefault(Belt_Option.map(hint, (function (param) {
                        return React.createElement(Hint.make, {
                                    word: param[0],
                                    translations: param[1]
                                  });
                      })), null), React.createElement(Links.make, {}));
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
