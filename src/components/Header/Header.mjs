

import * as React from "react";

import './header.css'
;

var languageName = "nut-taal";

function Header(props) {
  return React.createElement("h1", undefined, React.createElement("a", {
                  style: {
                    color: "inherit",
                    textDecoration: "inherit"
                  },
                  href: "#"
                }, React.createElement("img", {
                      className: "logo",
                      src: "nut-taal-logo.png"
                    }), React.createElement("b", undefined, languageName)));
}

var make = Header;

export {
  languageName ,
  make ,
}
/*  Not a pure module */
