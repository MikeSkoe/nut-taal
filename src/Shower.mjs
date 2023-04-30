

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";

function Shower$Tooltip(props) {
  return React.createElement(React.Fragment, undefined, React.cloneElement(props.children, {
                  "data-tooltip": props.hint,
                  "tooltip-pos": "up"
                }));
}

var Tooltip = {
  make: Shower$Tooltip
};

function render(className, prefix, param) {
  var word = param[1];
  var onClick = React.useContext(DictionaryContext.onWordClickContext);
  return React.createElement("span", {
              className: className
            }, param[0] ? React.createElement(Shower$Tooltip, {
                    children: React.createElement("span", {
                          onClick: (function (param) {
                              Curry._1(onClick, word);
                            })
                        }, "" + prefix + "" + word + ""),
                    hint: param[2]
                  }) : React.createElement("u", undefined, "" + prefix + "" + word + ""));
}

function unit(render, tuples) {
  if (tuples) {
    return React.createElement(React.Fragment, undefined, Curry._2(render, " ", tuples.hd), Belt_List.toArray(Belt_List.map(tuples.tl, Curry._1(render, "-"))));
  } else {
    return React.createElement(React.Fragment, undefined);
  }
}

function wrapNoun(param) {
  return unit((function (param, param$1) {
                return render("noun", param, param$1);
              }), param);
}

function wrapVerb(param) {
  return unit((function (param, param$1) {
                return render("verb", param, param$1);
              }), param);
}

function wrapAd(param) {
  return unit((function (param, param$1) {
                return render("ad", param, param$1);
              }), param);
}

function wrapConj(conj, def) {
  return React.createElement("span", {
              className: "conj"
            }, React.createElement(Shower$Tooltip, {
                  children: React.createElement("span", undefined, " " + conj + ""),
                  hint: def
                }));
}

function wrapPunctuation(str) {
  return React.createElement("span", undefined, str);
}

function wrapMark(mark) {
  return React.createElement("span", undefined, " " + mark + "");
}

export {
  Tooltip ,
  render ,
  unit ,
  wrapNoun ,
  wrapVerb ,
  wrapAd ,
  wrapConj ,
  wrapPunctuation ,
  wrapMark ,
}
/* react Not a pure module */
