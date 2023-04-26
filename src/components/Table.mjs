

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as DictionaryContext from "./DictionaryContext.mjs";

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

function Table$Terms(props) {
  var terms = React.useContext(DictionaryContext.termsContext);
  return React.createElement(Table$Dict, {
              titles: {
                hd: "term",
                tl: {
                  hd: "noun",
                  tl: {
                    hd: "verb",
                    tl: {
                      hd: "ad",
                      tl: {
                        hd: "description",
                        tl: /* [] */0
                      }
                    }
                  }
                }
              },
              terms: terms,
              getColumns: (function (term) {
                  return {
                          hd: term.str,
                          tl: {
                            hd: term.noun,
                            tl: {
                              hd: term.verb,
                              tl: {
                                hd: term.ad,
                                tl: {
                                  hd: term.description,
                                  tl: /* [] */0
                                }
                              }
                            }
                          }
                        };
                })
            });
}

var Terms = {
  make: Table$Terms
};

function Table$Conjs(props) {
  var conjs = React.useContext(DictionaryContext.conjsContext);
  return React.createElement(Table$Dict, {
              titles: {
                hd: "term",
                tl: {
                  hd: "translation",
                  tl: {
                    hd: "description",
                    tl: /* [] */0
                  }
                }
              },
              terms: conjs,
              getColumns: (function (conj) {
                  return {
                          hd: conj.str,
                          tl: {
                            hd: conj.definition,
                            tl: {
                              hd: conj.description,
                              tl: /* [] */0
                            }
                          }
                        };
                })
            });
}

var Conjs = {
  make: Table$Conjs
};

export {
  Dict ,
  Terms ,
  Conjs ,
}
/* react Not a pure module */
