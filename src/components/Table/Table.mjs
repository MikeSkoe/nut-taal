

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

function Table$Dict(props) {
  var getColumns = props.getColumns;
  return React.createElement("table", {
              className: "is-striped"
            }, React.createElement("thead", undefined, React.createElement("tr", undefined, Belt_List.toArray(Belt_List.map(props.titles, (function (title) {
                                return React.createElement("th", undefined, title);
                              }))))), React.createElement("tbody", undefined, Belt_List.toArray(Belt_List.map(props.terms, (function (term) {
                            return React.createElement("tr", undefined, Belt_List.toArray(Belt_List.map(Curry._1(getColumns, term), (function (column) {
                                                  return React.createElement("td", undefined, column);
                                                }))));
                          })))));
}

var Dict = {
  make: Table$Dict
};

export {
  Dict ,
}
/* react Not a pure module */
