

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Parser from "../Parser/Parser.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var initialText = "my lief jy want jy is persoon e goed";

function Input(props) {
  var ref = React.useRef(null);
  var match = React.useState(function () {
        return initialText;
      });
  var setInput = match[1];
  var onChange = function ($$event) {
    Curry._1(setInput, (function (param) {
            return $$event.target.innerText;
          }));
  };
  var onPaste = (event => {
        event.preventDefault();
        const text = event.clipboardData.getData("text");
        event.target.innerText = text;
        setInput(text);
        if (ref.current) {
            ref.current.innerText = text;
        }
    });
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "area-holder"
                }, React.createElement("div", {
                      className: "column"
                    }, React.createElement("h2", {
                          className: "area-heading"
                        }, "Type here"), React.createElement("div", {
                          className: "box area"
                        }, React.createElement("div", {
                              ref: Caml_option.some(ref),
                              className: "editable",
                              contentEditable: true,
                              spellCheck: false,
                              inputMode: "text",
                              onPaste: onPaste,
                              onInput: onChange,
                              suppressContentEditableWarning: true
                            }, initialText))), React.createElement("div", {
                      className: "column"
                    }, React.createElement("h2", {
                          className: "area-heading"
                        }, "Preview here"), React.createElement("div", {
                          className: "box area"
                        }, React.createElement(Parser.make, {
                              text: match[0],
                              marks: props.marks
                            })))));
}

var make = Input;

export {
  initialText ,
  make ,
}
/* react Not a pure module */
