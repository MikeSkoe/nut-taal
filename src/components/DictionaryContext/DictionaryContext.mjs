

import * as React from "react";

var onWordClickContext = React.createContext(function (param) {
      
    });

var make = onWordClickContext.Provider;

var OnWordClickProvider = {
  make: make
};

export {
  onWordClickContext ,
  OnWordClickProvider ,
}
/* onWordClickContext Not a pure module */
