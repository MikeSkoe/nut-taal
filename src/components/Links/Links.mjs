

import * as React from "react";

var readmeURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/README.md";

var dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";

var conjugationsURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/conjugations.csv";

var examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

function Links(props) {
  return React.createElement("div", {
              className: "column"
            }, React.createElement("a", {
                  href: readmeURL
                }, "README (with grammar)"), React.createElement("a", {
                  href: dicrionaryURL
                }, "Dictionary"), React.createElement("a", {
                  href: conjugationsURL
                }, "Conjugations"), React.createElement("a", {
                  href: examplesURL
                }, "Examples"));
}

var make = Links;

export {
  readmeURL ,
  dicrionaryURL ,
  conjugationsURL ,
  examplesURL ,
  make ,
}
/* react Not a pure module */
