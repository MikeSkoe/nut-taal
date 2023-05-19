

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

export {
  concatWords ,
}
/* No side effect */
