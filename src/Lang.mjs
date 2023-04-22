

import * as Language from "./library/language.mjs";
import * as Dictionary from "./library/dictionary.mjs";

var Lang = Language.Make(Dictionary.Term, Dictionary.Conj);

export {
  Lang ,
}
/* Lang Not a pure module */
