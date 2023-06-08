

import * as Curry from "rescript/lib/es6/curry.js";
import * as Utils from "../../Utils.mjs";
import * as React from "react";
import * as Examples from "../Reader/Examples.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function ExamplesPage(props) {
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
          var $$fetch = async function (param) {
            var text = await Utils.loadFile("sentences");
            var words = Utils.parseExamples(text);
            return Curry._1(setText, (function (param) {
                          return words;
                        }));
          };
          $$fetch(undefined);
        }), []);
  return Belt_Option.mapWithDefault(props.conjunctionDict, null, (function (conjunctions) {
                return React.createElement(Examples.make, {
                            textWithTranslation: text,
                            conjunctions: conjunctions
                          });
              }));
}

var make = ExamplesPage;

export {
  make ,
}
/* react Not a pure module */
