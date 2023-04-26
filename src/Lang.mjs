

import * as Shower from "./Shower.mjs";
import * as Language from "./library/language.mjs";
import * as Dictionary from "./library/dictionary.mjs";

var param = {
  wrapNoun: Shower.wrapNoun,
  wrapVerb: Shower.wrapVerb,
  wrapAd: Shower.wrapAd,
  wrapConj: Shower.wrapConj,
  wrapMark: Shower.wrapMark,
  wrapPunctuation: Shower.wrapPunctuation
};

var Lang = Language.Make(Dictionary.Term, Dictionary.Conj, param);

export {
  Lang ,
}
/* Lang Not a pure module */
