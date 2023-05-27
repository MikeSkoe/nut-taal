

import * as App from "./App.mjs";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Client from "react-dom/client";

var root = Client.createRoot(Belt_Option.getExn(Caml_option.nullable_to_opt(document.querySelector("#root"))));

root.render(React.createElement(React.StrictMode, {
          children: React.createElement(App.make, {})
        }));

export {
  root ,
}
/* root Not a pure module */
