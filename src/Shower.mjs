

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

function Shower$Word(props) {
  var word = props.word;
  var onClick = React.useContext(DictionaryContext.onWordClickContext);
  return React.createElement("span", {
              className: props.className,
              onClick: (function (param) {
                  Curry._1(onClick, word);
                })
            }, word);
}

var Word = {
  make: Shower$Word
};

function noun(word) {
  return React.createElement(Shower$Word, {
              className: "noun",
              word: word
            });
}

function verb(word) {
  return React.createElement(Shower$Word, {
              className: "verb",
              word: word
            });
}

function ad(word) {
  return React.createElement(Shower$Word, {
              className: "ad",
              word: word
            });
}

function con(word) {
  return React.createElement(Shower$Word, {
              className: "conj",
              word: word
            });
}

function mark(mark$1) {
  return React.createElement("span", undefined, mark$1);
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
