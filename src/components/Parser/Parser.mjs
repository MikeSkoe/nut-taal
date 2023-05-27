

import * as Lang from "../../Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Utils from "../../Utils.mjs";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

function Parser(props) {
  var marks = props.marks;
  var text = props.text;
  var match = React.useState(function () {
        return {
                hd: Lang.Lang.empty,
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
            }, Belt_List.toArray(Belt_List.flatten(Utils.putBetween(Belt_List.map(match[0], (function (line) {
                                return Utils.putBetween(Curry._1(Lang.Lang.show, line), " ");
                              })), {
                          hd: ". ",
                          tl: /* [] */0
                        }))));
}

var make = Parser;

export {
  make ,
}
/* Lang Not a pure module */
