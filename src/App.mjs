

import * as Lang from "./Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "./library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

import './app.css'
;

function App$Links(props) {
  return React.createElement(React.Fragment, undefined, React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv"
                    }, "Dictionary")), React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/particles.csv"
                    }, "Particles")), React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv"
                    }, "Examples")));
}

function App$Parser(props) {
  var match = React.useState(function () {
        return "";
      });
  var setInput = match[1];
  var onChange = function ($$event) {
    Curry._1(setInput, $$event.target.value);
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, Belt_List.toArray(Belt_List.map($$String.split_on_char(/* '.' */46, match[0]), (function (string) {
                            return React.createElement(React.Fragment, undefined, Belt_List.toArray(Belt_List.reduce(Curry._1(Lang.Lang.Lexs.show, Curry._1(Lang.Lang.Lexs.parse, string)), /* [] */0, (function (acc, curr) {
                                                  if (acc === /* [] */0) {
                                                    return {
                                                            hd: curr,
                                                            tl: /* [] */0
                                                          };
                                                  } else {
                                                    return Belt_List.concatMany([
                                                                acc,
                                                                {
                                                                  hd: " ",
                                                                  tl: {
                                                                    hd: curr,
                                                                    tl: /* [] */0
                                                                  }
                                                                }
                                                              ]);
                                                  }
                                                }))));
                          })))), React.createElement("textarea", {
                  inputMode: "text",
                  onChange: onChange
                }));
}

function App$Hint(props) {
  return React.createElement("div", undefined, Belt_Option.getWithDefault(Belt_Option.map(props.hint, (function (param) {
                        var description = param.description;
                        var ad = param.ad;
                        var verb = param.verb;
                        var noun = param.noun;
                        return React.createElement(React.Fragment, undefined, React.createElement("p", undefined, React.createElement("b", undefined, "term: "), param.str), noun !== "" ? React.createElement("p", undefined, React.createElement("b", undefined, "noun: "), noun) : null, verb !== "" ? React.createElement("p", undefined, React.createElement("b", undefined, "verb: "), verb) : null, ad !== "" ? React.createElement("p", undefined, React.createElement("b", undefined, "ad: "), ad) : null, description !== "" ? React.createElement("p", undefined, React.createElement("b", undefined, "description: "), description) : null);
                      })), React.createElement(React.Fragment, undefined)));
}

function App$InputPage(props) {
  var match = React.useState(function () {
        return "";
      });
  var setQuery = match[1];
  var query = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setHint = match$1[1];
  React.useEffect((function () {
          Js_promise.then_((function (all) {
                  return Promise.resolve(Curry._1(setHint, (function (param) {
                                    return Belt_List.getBy(all, (function (term) {
                                                  return term.str === query;
                                                }));
                                  })));
                }), Dictionary.Term.all);
        }), [query]);
  return React.createElement(DictionaryContext.OnWordClickProvider.make, {
              value: (function (str) {
                  Curry._1(setQuery, (function (param) {
                          return str;
                        }));
                }),
              children: null
            }, React.createElement(App$Parser, {}), React.createElement(App$Links, {}), React.createElement(App$Hint, {
                  hint: match$1[0]
                }));
}

function App(props) {
  return React.createElement(DictionaryContext.make, {
              children: React.createElement(App$InputPage, {})
            });
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
