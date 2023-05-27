

import * as Links from "../Links/Links.mjs";
import * as Utils from "../../Utils.mjs";
import * as React from "react";
import * as Legend from "../Legend/Legend.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

function Hint(props) {
  return React.createElement("div", {
              className: "box hint " + (
                props.fixed ? "hintFixed" : ""
              ) + ""
            }, React.createElement("i", undefined, props.word), React.createElement("h3", undefined, Belt_List.toArray(Utils.putBetween(Belt_List.map(Belt_List.keep(props.translations, (function (str) {
                                    return str !== "";
                                  })), (function (str) {
                                return str;
                              })), ", "))), React.createElement(Legend.make, {}), React.createElement(Links.make, {}));
}

var make = Hint;

export {
  make ,
}
/* Links Not a pure module */
