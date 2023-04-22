

import * as App from "./App.mjs";
import * as React from "react";
import * as ReactDom from "react-dom";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

ReactDom.render(React.createElement(React.StrictMode, {
          children: React.createElement(App.make, {})
        }), Belt_Option.getExn(Caml_option.nullable_to_opt(document.querySelector("#root"))));

export {
  
}
/*  Not a pure module */