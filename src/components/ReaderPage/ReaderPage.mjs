

import * as Curry from "rescript/lib/es6/curry.js";
import * as Fetch from "bs-fetch/src/Fetch.mjs";
import * as React from "react";
import * as Reader from "../Reader/Reader.mjs";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function ReaderPage(props) {
  var match = React.useState(function () {
        return {
                hd: [
                  "My leif jy",
                  "I love you"
                ],
                tl: /* [] */0
              };
      });
  var setText = match[1];
  var text = match[0];
  React.useEffect((function () {
          var $$fetch$1 = async function (param) {
            var fetched = await fetch("sentences3");
            var text = await Fetch.$$Response.text(fetched);
            var words = Belt_List.map(Belt_List.fromArray(Js_string.split("\n\n", text)), (function (str) {
                    var match = $$String.split_on_char(/* '\n' */10, str);
                    if (!match) {
                      return [
                              "plek-hou",
                              "placeholder"
                            ];
                    }
                    var match$1 = match.tl;
                    if (match$1) {
                      return [
                              match$1.hd,
                              match.hd
                            ];
                    } else {
                      return [
                              "plek-hou",
                              "placeholder"
                            ];
                    }
                  }));
            return Curry._1(setText, (function (param) {
                          return words;
                        }));
          };
          $$fetch$1(undefined);
        }), []);
  return Belt_Option.mapWithDefault(props.conjunctionDict, null, (function (conjunctions) {
                return React.createElement(Reader.make, {
                            textWithTranslation: text,
                            conjunctions: conjunctions
                          });
              }));
}

var make = ReaderPage;

export {
  make ,
}
/* react Not a pure module */
