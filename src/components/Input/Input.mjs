

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Parser from "../Parser/Parser.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var initialText = "my lief jy want jy is persoon e goed";

function Input(props) {
  var ref = React.useRef(null);
  var match = React.useState(function () {
        return true;
      });
  var setIsEditMode = match[1];
  var isEditMode = match[0];
  var match$1 = React.useState(function () {
        return initialText;
      });
  var setInput = match$1[1];
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
                  className: "box area"
                }, React.createElement(Parser.make, {
                      text: match$1[0],
                      marks: props.marks
                    }), React.createElement("div", {
                      ref: Caml_option.some(ref),
                      className: isEditMode ? "editable" : "nonEditable",
                      contentEditable: true,
                      spellCheck: false,
                      inputMode: "text",
                      onPaste: onPaste,
                      onInput: onChange
                    }, initialText)), React.createElement("input", {
                  className: "switch",
                  id: "isEdit",
                  type: "checkbox",
                  onClick: (function (param) {
                      Curry._1(setIsEditMode, (function (is) {
                              return !is;
                            }));
                    })
                }), React.createElement("label", undefined, "" + (
                  isEditMode ? "Edit" : "View"
                ) + " mode"));
}

var make = Input;

export {
  initialText ,
  make ,
}
/* react Not a pure module */
