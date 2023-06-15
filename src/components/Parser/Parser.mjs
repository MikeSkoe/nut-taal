

import * as Lang from "../../Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Utils from "../../Utils.mjs";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

var sentenceSplitterRe = /\s*[.!?]\s*/;

function Parser(props) {
  var conjunctions = props.conjunctions;
  var text = props.text;
  var match = React.useState(function () {
        return {
                hd: Lang.Lang.empty,
                tl: /* [] */0
              };
      });
  var setParsed = match[1];
  React.useEffect((function () {
          var res = Belt_List.map(Belt_Array.reduce(text.split(sentenceSplitterRe), /* [] */0, (function (acc, curr) {
                      return Belt_Option.mapWithDefault(curr, acc, (function (curr) {
                                    return Belt_List.concat(acc, {
                                                hd: curr,
                                                tl: /* [] */0
                                              });
                                  }));
                    })), (function (line) {
                  return Curry._2(Lang.Lang.parse, conjunctions, line);
                }));
          Curry._1(setParsed, (function (param) {
                  return res;
                }));
        }), [
        text,
        conjunctions
      ]);
  return React.createElement("div", {
              className: "parsed"
            }, Belt_List.toArray(Belt_List.flatten(Utils.putBetween(Belt_List.map(match[0], (function (line) {
                                return Utils.putBetween(Curry._1(Lang.Lang.show, line), " ");
                              })), {
                          hd: React.createElement("br", undefined),
                          tl: /* [] */0
                        }))));
}

var make = Parser;

export {
  sentenceSplitterRe ,
  make ,
}
/* Lang Not a pure module */
