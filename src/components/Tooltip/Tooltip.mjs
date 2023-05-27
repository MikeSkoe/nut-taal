

import * as React from "react";

function Tooltip(props) {
  return React.cloneElement(props.children, {
              "data-tooltip": props.text,
              "tooltip-pos": props.pos,
              "tooltip-length": "medium"
            });
}

var make = Tooltip;

export {
  make ,
}
/* react Not a pure module */
