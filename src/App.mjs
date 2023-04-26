

import * as Lang from "./Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Table from "./components/Table.mjs";
import * as React from "react";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Dictionary from "./library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as DictionaryContext from "./components/DictionaryContext.mjs";
import * as RescriptReactRouter from "@rescript/react/src/RescriptReactRouter.mjs";

import './app.css'
;

function App$Parser(props) {
  var match = React.useState(function () {
        return "";
      });
  var setInput = match[1];
  var onChange = function ($$event) {
    Curry._1(setInput, $$event.target.value);
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, Belt_List.toArray(Belt_List.map($$String.split_on_char(/* '.' */46, match[0]), (function (string) {
                            return React.createElement(React.Fragment, undefined, Belt_List.toArray(Curry._1(Lang.Lang.Lexs.show, Curry._1(Lang.Lang.Lexs.parse, string))));
                          })))), React.createElement("textarea", {
                  inputMode: "text",
                  onChange: onChange
                }));
}

function App$VocabPage(props) {
  var conjs = React.useContext(DictionaryContext.conjsContext);
  var terms = React.useContext(DictionaryContext.termsContext);
  var match = React.useState(function () {
        return "";
      });
  var setQuery = match[1];
  var query = match[0];
  var onChange = function ($$event) {
    Curry._1(setQuery, $$event.target.value);
  };
  return React.createElement("div", {
              className: "flex",
              direction: "column"
            }, React.createElement("a", {
                  href: "/"
                }, "parse text"), React.createElement("input", {
                  inputMode: "text",
                  onChange: onChange
                }), React.createElement(Table.Dict.make, {
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
                  terms: Belt_List.keep(conjs, (function (conjTerm) {
                          return conjTerm.str.includes(query);
                        })),
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
                }), React.createElement(Table.Dict.make, {
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
                  terms: Belt_List.keep(terms, (function (conjTerm) {
                          return conjTerm.str.includes(query);
                        })),
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
                }));
}

function App$InputPage(props) {
  var match = React.useState(function () {
        return "begin";
      });
  var setQuery = match[1];
  var query = match[0];
  var match$1 = React.useState(function () {
        
      });
  var setHint = match$1[1];
  React.useEffect((function () {
          Js_promise.then_((function (all) {
                  return Promise.resolve(Curry._1(setHint, (function (param) {
                                    return Belt_List.getBy(all, (function (term) {
                                                  return term.str === query;
                                                }));
                                  })));
                }), Dictionary.Term.all);
        }), [query]);
  return React.createElement(DictionaryContext.OnWordClickProvider.make, {
              value: (function (str) {
                  Curry._1(setQuery, (function (param) {
                          return str;
                        }));
                }),
              children: null
            }, React.createElement(App$Parser, {}), React.createElement("a", {
                  href: "/vocab"
                }, "see vocab"), Belt_Option.getWithDefault(Belt_Option.map(match$1[0], (function (term) {
                        return React.createElement(Table.Dict.make, {
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
                                    terms: {
                                      hd: term,
                                      tl: /* [] */0
                                    },
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
                      })), React.createElement(React.Fragment, undefined)));
}

function App(props) {
  var url = RescriptReactRouter.useUrl(undefined, undefined);
  var match = url.path;
  var tmp;
  tmp = match && match.hd === "vocab" && !match.tl ? React.createElement(App$VocabPage, {}) : React.createElement(App$InputPage, {});
  return React.createElement(DictionaryContext.make, {
              children: React.createElement(React.Fragment, undefined, tmp)
            });
}

var make = App;

export {
  make ,
}
/*  Not a pure module */
