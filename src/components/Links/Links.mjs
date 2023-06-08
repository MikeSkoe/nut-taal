

import * as React from "react";

var examplesURL = "#examples";

var readmeURL = "https://github.com/MikeSkoe/nut-taal/blob/main/README.md";

var dicrionaryURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv";

var conjunctionsURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/conjunctions.csv";

function Links(props) {
  return React.createElement("div", {
              className: "links"
            }, React.createElement("a", {
                  href: examplesURL
                }, "Examples"), React.createElement("a", {
                  href: readmeURL
                }, "README (with grammar)"), React.createElement("a", {
                  href: dicrionaryURL
                }, "Dictionary"), React.createElement("a", {
                  href: conjunctionsURL
                }, "conjunctions"));
}

var make = Links;

export {
  examplesURL ,
  readmeURL ,
  dicrionaryURL ,
  conjunctionsURL ,
  make ,
}
/* react Not a pure module */
