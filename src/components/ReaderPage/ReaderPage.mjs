

import * as React from "react";
import * as Reader from "../Reader/Reader.mjs";
import * as Sample from "./Sample.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function ReaderPage(props) {
  return Belt_Option.mapWithDefault(props.marksDict, null, (function (marks) {
                return React.createElement(Reader.make, {
                            textWithTranslation: Sample.fiets,
                            marks: marks
                          });
              }));
}

var make = ReaderPage;

export {
  make ,
}
/* react Not a pure module */
