

import * as Belt_List from "rescript/lib/es6/belt_List.js";

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

export {
  concatWords ,
  putBetween ,
}
/* No side effect */
