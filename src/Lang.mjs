

import * as Shower from "./Shower.mjs";
import * as Language from "./library/language.mjs";
import * as Dictionary from "./library/dictionary.mjs";

var param = {
  noun: Shower.noun,
  verb: Shower.verb,
  ad: Shower.ad,
  con: Shower.con,
  mark: Shower.mark
};

var Lang = Language.Make(Dictionary.Marks, param);

export {
  Lang ,
}
/* Lang Not a pure module */
