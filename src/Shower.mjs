

import * as React from "react";

function Shower$Tooltip(props) {
  return React.createElement("span", {
              className: "tooltip"
            }, props.hint);
}

var Tooltip = {
  make: Shower$Tooltip
};

function wrapNoun(noun, def) {
  return React.createElement("span", {
              className: "noun"
            }, React.createElement("span", undefined, " " + noun + ""), React.createElement(Shower$Tooltip, {
                  hint: def
                }));
}

function wrapVerb(verb, def) {
  return React.createElement("span", {
              className: "verb"
            }, React.createElement("span", undefined, " " + verb + ""), React.createElement(Shower$Tooltip, {
                  hint: def
                }));
}

function wrapAd(ad, def) {
  return React.createElement("span", {
              className: "ad"
            }, React.createElement("span", undefined, " " + ad + ""), React.createElement(Shower$Tooltip, {
                  hint: def
                }));
}

function wrapConj(conj, def) {
  return React.createElement("span", {
              className: "conj"
            }, React.createElement("span", undefined, " " + conj + ""), React.createElement(Shower$Tooltip, {
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
  wrapNoun ,
  wrapVerb ,
  wrapAd ,
  wrapConj ,
  wrapPunctuation ,
  wrapMark ,
}
/* react Not a pure module */
