

import * as Curry from "rescript/lib/es6/curry.js";
import * as Fetch from "bs-fetch/src/Fetch.mjs";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Js_string from "rescript/lib/es6/js_string.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";

function concatWords(words) {
  return Belt_List.reduce(words, "", (function (acc, curr) {
                if (acc === "") {
                  return curr;
                } else {
                  return "" + acc + "-" + curr + "";
                }
              }));
}

function putBetween(list, item) {
  return Belt_List.reduce(list, /* [] */0, (function (acc, curr) {
                if (acc === /* [] */0) {
                  return {
                          hd: curr,
                          tl: /* [] */0
                        };
                } else {
                  return Belt_List.concatMany([
                              acc,
                              {
                                hd: item,
                                tl: {
                                  hd: curr,
                                  tl: /* [] */0
                                }
                              }
                            ]);
                }
              }));
}

function loadFile(path) {
  var __x = fetch(path);
  return Js_promise.then_(Fetch.$$Response.text, __x);
}

function parseExamples(text) {
  return Belt_List.map(Belt_List.fromArray(Js_string.split("\n\n", text)), (function (str) {
                var match = $$String.split_on_char(/* '\n' */10, str);
                if (!match) {
                  return [
                          "plek-hou",
                          "placeholder"
                        ];
                }
                var match$1 = match.tl;
                if (match$1) {
                  return [
                          match$1.hd,
                          match.hd
                        ];
                } else {
                  return [
                          "plek-hou",
                          "placeholder"
                        ];
                }
              }));
}

function mapFirstChar(fn, str) {
  return Js_string.concat(Js_string.sliceToEnd(1, str), Curry._1(fn, Js_string.charAt(0, str)));
}

export {
  concatWords ,
  putBetween ,
  loadFile ,
  parseExamples ,
  mapFirstChar ,
}
/* No side effect */
