

import * as React from "react";
import * as Tooltip from "../Tooltip/Tooltip.mjs";

function Legend(props) {
  return React.createElement("div", {
              className: "legend"
            }, React.createElement(Tooltip.make, {
                  text: "Work markers, like: a i e, have this colour",
                  children: React.createElement("i", {
                        className: "mark"
                      }, "mark "),
                  pos: "down-left"
                }), React.createElement(Tooltip.make, {
                  text: "Nouns have this colour",
                  children: React.createElement("i", {
                        className: "noun"
                      }, "noun "),
                  pos: "down"
                }), React.createElement(Tooltip.make, {
                  text: "Verbs have this colour",
                  children: React.createElement("i", {
                        className: "verb"
                      }, "verb "),
                  pos: "down"
                }), React.createElement(Tooltip.make, {
                  text: "Adjectives and adverbs have this colour",
                  children: React.createElement("i", {
                        className: "ad"
                      }, "ad "),
                  pos: "down"
                }), React.createElement(Tooltip.make, {
                  text: "Words that mean \"and\", \"but\", \"because\", etc., that introduce a clause, have this colour",
                  children: React.createElement("i", {
                        className: "conj"
                      }, "conjuction "),
                  pos: "down-right"
                }));
}

var make = Legend;

export {
  make ,
}
/* react Not a pure module */
