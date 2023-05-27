

import * as React from "react";

var readerURL = "/#reader";

var readmeURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/README.md";

var dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";

var conjugationsURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/conjugations.csv";

var examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

function Links(props) {
  return React.createElement("div", {
              className: "links"
            }, React.createElement("a", {
                  href: "/"
                }, "Main"), React.createElement("a", {
                  href: readerURL
                }, "Reader"), React.createElement("a", {
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
  readerURL ,
  readmeURL ,
  dicrionaryURL ,
  conjugationsURL ,
  examplesURL ,
  make ,
}
/* react Not a pure module */
