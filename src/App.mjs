

import * as Lang from "./Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "./library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

import './app.css'
;

function App$Links(props) {
  return React.createElement("div", {
              className: "samples"
            }, React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv"
                    }, "Dictionary")), React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/particles.csv"
                    }, "Particles")), React.createElement("p", undefined, React.createElement("a", {
                      href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv"
                    }, "Examples")));
}

function App$Parser(props) {
  var marks = props.marks;
  var text = props.text;
  var match = React.useState(function () {
        return {
                TAG: /* Start */0,
                _0: /* End */0
              };
      });
  var setParsed = match[1];
  React.useEffect((function () {
          var res = Curry._2(Lang.Lang.parse, marks, text);
          Curry._1(setParsed, (function (param) {
                  return res;
                }));
        }), [
        text,
        marks
      ]);
  return React.createElement("div", {
              className: "parsed"
            }, Belt_List.toArray(Belt_List.reduce(Curry._1(Lang.Lang.show, match[0]), /* [] */0, (function (acc, curr) {
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
}

function App$Hint(props) {
  return React.createElement("div", {
              className: "box hint"
            }, React.createElement("h3", undefined, props.word), Belt_List.toArray(Belt_List.map(props.translations, (function (str) {
                        return React.createElement(React.Fragment, undefined, React.createElement("span", {
                                        className: "verb"
                                      }, str), React.createElement("br", undefined));
                      }))), React.createElement(App$Links, {}));
}

function App$InputPage(props) {
  var match = React.useState(function () {
        return true;
      });
  var setIsEditMode = match[1];
  var match$1 = React.useState(function () {
        return "";
      });
  var setInput = match$1[1];
  var onChange = function ($$event) {
    Curry._1(setInput, (function (param) {
            return $$event.target.innerText;
          }));
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "box area"
                }, React.createElement(App$Parser, {
                      text: match$1[0],
                      marks: props.marks
                    }), React.createElement("div", {
                      className: match[0] ? "editable" : "nonEditable",
                      contentEditable: true,
                      spellCheck: false,
                      inputMode: "text",
                      onInput: onChange
                    })), React.createElement("input", {
                  className: "switch",
                  type: "checkbox",
                  onClick: (function (param) {
                      Curry._1(setIsEditMode, (function (is) {
                              return !is;
                            }));
                    })
                }));
}

function App(props) {
  var match = React.useState(function () {
        
      });
  var setTermDict = match[1];
  var termDict = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setMarksDict = match$1[1];
  var match$2 = React.useState(function () {
        return "my";
      });
  var setQuery = match$2[1];
  var query = match$2[0];
  var match$3 = React.useState(function () {
        
      });
  var setHint = match$3[1];
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
  React.useEffect((function () {
          Belt_Option.forEach(termDict, (function (dict) {
                  Belt_Option.forEach(Curry._2(Lang.Lang.translate, query, dict), (function (translations) {
                          Curry._1(setHint, (function (param) {
                                  return [
                                          query,
                                          translations
                                        ];
                                }));
                        }));
                }));
        }), [
        query,
        termDict
      ]);
  return React.createElement(DictionaryContext.OnWordClickProvider.make, {
              value: (function (str) {
                  Curry._1(setQuery, (function (param) {
                          return str;
                        }));
                }),
              children: null
            }, React.createElement("h1", undefined, React.createElement("b", undefined, "taal")), Belt_Option.getWithDefault(Belt_Option.map(match$1[0], (function (marks) {
                        return React.createElement(App$InputPage, {
                                    marks: marks
                                  });
                      })), null), Belt_Option.getWithDefault(Belt_Option.map(match$3[0], (function (param) {
                        return React.createElement(App$Hint, {
                                    word: param[0],
                                    translations: param[1]
                                  });
                      })), null));
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
