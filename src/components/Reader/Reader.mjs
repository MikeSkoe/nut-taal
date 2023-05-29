

import * as React from "react";
import * as Parser from "../Parser/Parser.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

import './reader.css'
;

function Reader(props) {
  var conjunctions = props.conjunctions;
  return Belt_List.toArray(Belt_List.map(props.textWithTranslation, (function (param) {
                    return React.createElement("div", {
                                className: "reader"
                              }, React.createElement(Parser.make, {
                                    text: param[0],
                                    conjunctions: conjunctions
                                  }), React.createElement("div", undefined, param[1]));
                  })));
}

var make = Reader;

export {
  make ,
}
/*  Not a pure module */
