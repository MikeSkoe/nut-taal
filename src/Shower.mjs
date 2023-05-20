

import * as Curry from "rescript/lib/es6/curry.js";
import * as Utils from "./Utils.mjs";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

function normalizeWord(word) {
  return $$String.lowercase_ascii($$String.trim($$String.map((function ($$char) {
                        if (Belt_List.has({
                                hd: /* '.' */46,
                                tl: {
                                  hd: /* ',' */44,
                                  tl: {
                                    hd: /* '!' */33,
                                    tl: {
                                      hd: /* '?' */63,
                                      tl: /* [] */0
                                    }
                                  }
                                }
                              }, $$char, (function (a, b) {
                                  return a === b;
                                }))) {
                          return /* ' ' */32;
                        } else {
                          return $$char;
                        }
                      }), word)));
}

function iter(onClick, className, word, withDash) {
  var match = $$String.split_on_char(/* '-' */45, word);
  if (!match) {
    return null;
  }
  var next = match.tl;
  return React.createElement(React.Fragment, undefined, withDash ? "-" : "", React.createElement("span", {
                  className: className,
                  onClick: (function (param) {
                      Curry._1(onClick, normalizeWord(word));
                    })
                }, match.hd), next === /* [] */0 ? null : iter(onClick, className, Utils.concatWords(next), true));
}

function Shower$Word(props) {
  var onClick = React.useContext(DictionaryContext.onWordClickContext);
  return iter(onClick, props.className, props.word, props.withDash);
}

var Word = {
  normalizeWord: normalizeWord,
  iter: iter,
  make: Shower$Word
};

function noun(word) {
  return React.createElement(Shower$Word, {
              className: "noun",
              word: word,
              withDash: false
            });
}

function verb(word) {
  return React.createElement(Shower$Word, {
              className: "verb",
              word: word,
              withDash: false
            });
}

function ad(word) {
  return React.createElement(Shower$Word, {
              className: "ad",
              word: word,
              withDash: false
            });
}

function con(word) {
  return React.createElement(Shower$Word, {
              className: "conj",
              word: word,
              withDash: false
            });
}

function mark(mark$1) {
  return React.createElement("span", {
              className: "mark"
            }, mark$1);
}

export {
  Word ,
  noun ,
  verb ,
  ad ,
  con ,
  mark ,
}
/* react Not a pure module */
