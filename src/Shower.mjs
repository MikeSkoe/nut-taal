

import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

function Shower$Tooltip(props) {
  return React.createElement("span", {
              className: "tooltip"
            }, props.hint);
}

var Tooltip = {
  make: Shower$Tooltip
};

function wrapNoun(tuples) {
  var render = function (prefix, param) {
    return React.createElement("span", {
                className: "noun"
              }, React.createElement("span", undefined, "" + prefix + "" + param[0] + ""), React.createElement(Shower$Tooltip, {
                    hint: param[1]
                  }));
  };
  if (!tuples) {
    return React.createElement(React.Fragment, undefined);
  }
  var match = tuples.hd;
  return React.createElement(React.Fragment, undefined, render(" ", [
                  match[0],
                  match[1]
                ]), Belt_List.toArray(Belt_List.map(tuples.tl, (function (param) {
                        return render("-", param);
                      }))));
}

function wrapVerb(tuples) {
  var render = function (prefix, param) {
    return React.createElement("span", {
                className: "verb"
              }, React.createElement("span", undefined, "" + prefix + "" + param[0] + ""), React.createElement(Shower$Tooltip, {
                    hint: param[1]
                  }));
  };
  if (!tuples) {
    return React.createElement(React.Fragment, undefined);
  }
  var match = tuples.hd;
  return React.createElement(React.Fragment, undefined, render(" ", [
                  match[0],
                  match[1]
                ]), Belt_List.toArray(Belt_List.map(tuples.tl, (function (param) {
                        return render("-", param);
                      }))));
}

function wrapAd(tuples) {
  var render = function (prefix, param) {
    return React.createElement("span", {
                className: "ad"
              }, React.createElement("span", undefined, "" + prefix + "" + param[0] + ""), React.createElement(Shower$Tooltip, {
                    hint: param[1]
                  }));
  };
  if (!tuples) {
    return React.createElement(React.Fragment, undefined);
  }
  var match = tuples.hd;
  return React.createElement(React.Fragment, undefined, render(" ", [
                  match[0],
                  match[1]
                ]), Belt_List.toArray(Belt_List.map(tuples.tl, (function (param) {
                        return render("-", param);
                      }))));
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
