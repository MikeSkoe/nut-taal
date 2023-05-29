

import * as React from "react";

var readerURL = "#reader";

var readmeURL = "https://github.com/MikeSkoe/nut-taal/blob/main/README.md";

var dicrionaryURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv";

var conjunctionsURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/conjunctions.csv";

var examplesURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/examples.csv";

function Links(props) {
  return React.createElement("div", {
              className: "links"
            }, React.createElement("a", {
                  href: "#"
                }, "Main"), React.createElement("a", {
                  href: readerURL
                }, "Reader"), React.createElement("a", {
                  href: readmeURL
                }, "README (with grammar)"), React.createElement("a", {
                  href: dicrionaryURL
                }, "Dictionary"), React.createElement("a", {
                  href: conjunctionsURL
                }, "conjunctions"), React.createElement("a", {
                  href: examplesURL
                }, "Examples"));
}

var make = Links;

export {
  readerURL ,
  readmeURL ,
  dicrionaryURL ,
  conjunctionsURL ,
  examplesURL ,
  make ,
}
/* react Not a pure module */
