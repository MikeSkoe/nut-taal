

import * as Lang from "./Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "./library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

import './app.css'
;

function putBetween(list, item) {
  return Belt_List.reduce(list, /* [] */0, (function (acc, curr) {
                if (acc === /* [] */0) {
                  return {
                          hd: curr,
                          tl: /* [] */0
                        };
                } else {
                  return Belt_List.concatMany([
                              acc,
                              {
                                hd: item,
                                tl: {
                                  hd: curr,
                                  tl: /* [] */0
                                }
                              }
                            ]);
                }
              }));
}

function App$Links(props) {
  return React.createElement("div", {
              className: "samples"
            }, React.createElement("a", {
                  href: "https://github.com/MikeSkoe/code-ish-app/blob/main/README.md"
                }, "README (with grammar)"), React.createElement("a", {
                  href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv"
                }, "Dictionary"), React.createElement("a", {
                  href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/conjugations.csv"
                }, "Conjugations"), React.createElement("a", {
                  href: "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv"
                }, "Examples"));
}

function App$Parser(props) {
  var marks = props.marks;
  var text = props.text;
  var match = React.useState(function () {
        return {
                hd: {
                  TAG: /* Start */0,
                  _0: /* End */0
                },
                tl: /* [] */0
              };
      });
  var setParsed = match[1];
  React.useEffect((function () {
          var res = Belt_List.map($$String.split_on_char(/* '.' */46, text), (function (line) {
                  return Curry._2(Lang.Lang.parse, marks, line);
                }));
          Curry._1(setParsed, (function (param) {
                  return res;
                }));
        }), [
        text,
        marks
      ]);
  return React.createElement("div", {
              className: "parsed"
            }, Belt_List.toArray(Belt_List.flatten(putBetween(Belt_List.map(match[0], (function (line) {
                                return putBetween(Curry._1(Lang.Lang.show, line), " ");
                              })), {
                          hd: ". ",
                          tl: /* [] */0
                        }))));
}

function App$WithTooltip(props) {
  return React.cloneElement(props.children, {
              "data-tooltip": props.text,
              "tooltip-pos": props.pos,
              "tooltip-length": "medium"
            });
}

function App$Legend(props) {
  return React.createElement("div", {
              className: "legend"
            }, React.createElement(App$WithTooltip, {
                  text: "Work markers, like: a i e, have this colour",
                  children: React.createElement("i", {
                        className: "mark"
                      }, "mark "),
                  pos: "down-left"
                }), React.createElement(App$WithTooltip, {
                  text: "Nouns have this colour",
                  children: React.createElement("i", {
                        className: "noun"
                      }, "noun "),
                  pos: "down"
                }), React.createElement(App$WithTooltip, {
                  text: "Verbs have this colour",
                  children: React.createElement("i", {
                        className: "verb"
                      }, "verb "),
                  pos: "down"
                }), React.createElement(App$WithTooltip, {
                  text: "Adjectives and adverbs have this colour",
                  children: React.createElement("i", {
                        className: "ad"
                      }, "ad "),
                  pos: "down"
                }), React.createElement(App$WithTooltip, {
                  text: "Words that mean \"and\", \"but\", \"because\", etc., that introduce a clause, have this colour",
                  children: React.createElement("i", {
                        className: "conj"
                      }, "conjuction "),
                  pos: "down-right"
                }));
}

function App$Hint(props) {
  return React.createElement("div", {
              className: "box hint"
            }, React.createElement("i", undefined, props.word), React.createElement("h3", undefined, Belt_List.toArray(putBetween(Belt_List.map(Belt_List.keep(props.translations, (function (str) {
                                    return str !== "";
                                  })), (function (str) {
                                return str;
                              })), ", "))), React.createElement(App$Legend, {}));
}

function App$InputPage(props) {
  var ref = React.useRef(null);
  var match = React.useState(function () {
        return true;
      });
  var setIsEditMode = match[1];
  var isEditMode = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setInput = match$1[1];
  var onChange = function ($$event) {
    Curry._1(setInput, (function (param) {
            return $$event.target.innerText;
          }));
  };
  var onPaste = (event => {
            event.preventDefault();
            const text = event.clipboardData.getData("text");
            event.target.innerText = text;
            setInput(text);
            if (ref.current) {
                ref.current.innerText = text;
            }
        });
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "box area"
                }, React.createElement(App$Parser, {
                      text: match$1[0],
                      marks: props.marks
                    }), React.createElement("div", {
                      ref: Caml_option.some(ref),
                      className: isEditMode ? "editable" : "nonEditable",
                      contentEditable: true,
                      spellCheck: false,
                      inputMode: "text",
                      onPaste: onPaste,
                      onInput: onChange
                    })), React.createElement("input", {
                  className: "switch",
                  id: "isEdit",
                  type: "checkbox",
                  onClick: (function (param) {
                      Curry._1(setIsEditMode, (function (is) {
                              return !is;
                            }));
                    })
                }), React.createElement("label", undefined, "" + (
                  isEditMode ? "Edit" : "View"
                ) + " mode"));
}

function App(props) {
  var match = React.useState(function () {
        
      });
  var setTermDict = match[1];
  var termDict = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setMarksDict = match$1[1];
  var marksDict = match$1[0];
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
  return React.createElement(DictionaryContext.OnWordClickProvider.make, {
              value: (function (str) {
                  Curry._1(setQuery, (function (param) {
                          return str;
                        }));
                }),
              children: null
            }, React.createElement("h1", undefined, React.createElement("b", undefined, "nut-taal")), Belt_Option.getWithDefault(Belt_Option.map(marksDict, (function (marks) {
                        return React.createElement(App$InputPage, {
                                    marks: marks
                                  });
                      })), null), Belt_Option.getWithDefault(Belt_Option.map(match$3[0], (function (param) {
                        return React.createElement(App$Hint, {
                                    word: param[0],
                                    translations: param[1]
                                  });
                      })), null), React.createElement(App$Links, {}));
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
