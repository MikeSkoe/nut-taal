

import * as Lang from "./Lang.mjs";
import * as Unit from "./components/Unit.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Table from "./components/Table.mjs";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.mjs";

import './app.css'
;

function App$Parser(props) {
  var text = props.text;
  var match = React.useState(function () {
        return text;
      });
  var setInput = match[1];
  var onChange = function ($$event) {
    Curry._1(setInput, $$event.target.value);
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, Belt_List.toArray(Belt_List.map($$String.split_on_char(/* '.' */46, match[0]), (function (string) {
                            return React.createElement(React.Fragment, undefined, React.createElement(Unit.El.make, {
                                            pars: Curry._1(Lang.Lang.Lexs.parse, string.trim())
                                          }), ".");
                          })))), React.createElement("textarea", {
                  inputMode: "text",
                  onChange: onChange
                }));
}

function App(props) {
  var url = RescriptReactRouter.useUrl(undefined, undefined);
  var match = url.path;
  var tmp;
  if (match && match.hd === "text") {
    var match$1 = match.tl;
    tmp = match$1 && !match$1.tl ? React.createElement(App$Parser, {
            text: match$1.hd.replace(/_/g, " ")
          }) : React.createElement(App$Parser, {
            text: ""
          });
  } else {
    tmp = React.createElement(App$Parser, {
          text: ""
        });
  }
  return React.createElement(DictionaryContext.make, {
              children: React.createElement(React.Fragment, undefined, tmp, React.createElement("div", {
                        className: "flex",
                        direction: "column"
                      }, React.createElement(Table.Conjs.make, {}), React.createElement(Table.Terms.make, {})))
            });
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
