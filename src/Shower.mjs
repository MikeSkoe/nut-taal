

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

function Shower$Tooltip(props) {
  return React.createElement(React.Fragment, undefined, React.cloneElement(props.children, {
                  "data-tooltip": props.hint,
                  "tooltip-pos": "up"
                }));
}

var Tooltip = {
  make: Shower$Tooltip
};

function Shower$Word(props) {
  var data = props.data;
  var word = data[1];
  var onClick = React.useContext(DictionaryContext.onWordClickContext);
  if (data[0]) {
    return React.createElement(Shower$Tooltip, {
                children: React.createElement("span", {
                      className: props.className,
                      onClick: (function (param) {
                          Curry._1(onClick, word);
                        })
                    }, "" + word + ""),
                hint: data[2]
              });
  } else {
    return React.createElement("u", undefined, "" + word + "");
  }
}

var Word = {
  make: Shower$Word
};

function collapse(elements) {
  return Belt_List.reduce(elements, /* [] */0, (function (acc, curr) {
                if (acc === /* [] */0) {
                  return {
                          hd: curr,
                          tl: /* [] */0
                        };
                } else {
                  return Belt_List.concatMany([
                              acc,
                              {
                                hd: "-",
                                tl: {
                                  hd: curr,
                                  tl: /* [] */0
                                }
                              }
                            ]);
                }
              }));
}

function wrapNoun(data) {
  return React.createElement(React.Fragment, undefined, Belt_List.toArray(collapse(Belt_List.map(data, (function (data) {
                            return React.createElement(Shower$Word, {
                                        className: "noun",
                                        data: data
                                      });
                          })))));
}

function wrapVerb(data) {
  return React.createElement(React.Fragment, undefined, Belt_List.toArray(collapse(Belt_List.map(data, (function (data) {
                            return React.createElement(Shower$Word, {
                                        className: "verb",
                                        data: data
                                      });
                          })))));
}

function wrapAd(data) {
  return React.createElement(React.Fragment, undefined, Belt_List.toArray(collapse(Belt_List.map(data, (function (data) {
                            return React.createElement(Shower$Word, {
                                        className: "ad",
                                        data: data
                                      });
                          })))));
}

function wrapConj(conj, def) {
  return React.createElement("span", {
              className: "conj"
            }, React.createElement(Shower$Tooltip, {
                  children: React.createElement("span", undefined, conj),
                  hint: def
                }));
}

function wrapPunctuation(str) {
  return React.createElement("span", undefined, str);
}

function wrapMark(mark) {
  return React.createElement("span", undefined, mark);
}

export {
  Tooltip ,
  Word ,
  collapse ,
  wrapNoun ,
  wrapVerb ,
  wrapAd ,
  wrapConj ,
  wrapPunctuation ,
  wrapMark ,
}
/* react Not a pure module */
