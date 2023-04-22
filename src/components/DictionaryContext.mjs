

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dictionary from "../library/dictionary.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";

var termsContext = React.createContext(/* [] */0);

var conjsContext = React.createContext(/* [] */0);

var make = termsContext.Provider;

var TermProvider = {
  make: make
};

var make$1 = conjsContext.Provider;

var ConjProvider = {
  make: make$1
};

function DictionaryContext(props) {
  var match = React.useState(function () {
        return /* [] */0;
      });
  var setTerms = match[1];
  var match$1 = React.useState(function () {
        return /* [] */0;
      });
  var setConjs = match$1[1];
  React.useEffect((function () {
          Js_promise.then_((function (conjs) {
                  return Promise.resolve(Curry._1(setConjs, (function (param) {
                                    return conjs;
                                  })));
                }), Dictionary.Conj.all);
        }), []);
  React.useEffect((function () {
          Js_promise.then_((function (terms) {
                  return Promise.resolve(Curry._1(setTerms, (function (param) {
                                    return terms;
                                  })));
                }), Dictionary.Term.all);
        }), []);
  return React.createElement(make, {
              value: match[0],
              children: React.createElement(make$1, {
                    value: match$1[0],
                    children: props.children
                  })
            });
}

var make$2 = DictionaryContext;

export {
  termsContext ,
  conjsContext ,
  TermProvider ,
  ConjProvider ,
  make$2 as make,
}
/* termsContext Not a pure module */
