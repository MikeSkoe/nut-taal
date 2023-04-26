

import * as List from "rescript/lib/es6/list.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

var combMarkString = "-";

function Make(TD, CD, SH) {
  var fold = function (t, fn, $$default) {
    if (typeof t === "number" || t.TAG !== /* Root */0) {
      return $$default;
    } else {
      return Curry._1(fn, t._0);
    }
  };
  var show = function (t) {
    var iter = function (t) {
      if (typeof t === "number") {
        return /* [] */0;
      } else if (t.TAG === /* Root */0) {
        return {
                hd: Curry._1(TD.show, t._0),
                tl: iter(t._1)
              };
      } else {
        return {
                hd: t._0,
                tl: /* [] */0
              };
      }
    };
    return Belt_List.reduce(iter(t), "", (function (acc, curr) {
                  if (acc === "") {
                    return curr;
                  } else {
                    return acc + (combMarkString + curr);
                  }
                }));
  };
  var parse = function (str) {
    var iter = function (strings) {
      if (!strings) {
        return /* End */0;
      }
      var next = strings.tl;
      var word = strings.hd;
      var compound = Belt_List.reduce({
            hd: word,
            tl: next
          }, "", (function (acc, curr) {
              if (acc === "") {
                return curr;
              } else {
                return acc + (combMarkString + curr);
              }
            }));
      var word$1 = Curry._1(TD.parse, compound);
      if (word$1 !== undefined) {
        return {
                TAG: /* Root */0,
                _0: Caml_option.valFromOption(word$1),
                _1: /* End */0
              };
      }
      var word$2 = Curry._1(TD.parse, word);
      if (word$2 !== undefined) {
        return {
                TAG: /* Root */0,
                _0: Caml_option.valFromOption(word$2),
                _1: iter(next)
              };
      } else {
        return {
                TAG: /* Prop */1,
                _0: word
              };
      }
    };
    return iter($$String.split_on_char(/* '-' */45, str));
  };
  var Roots = {
    fold: fold,
    show: show,
    parse: parse
  };
  var fold$1 = function (t, fn, $$default) {
    if (t) {
      return Curry._1(fn, t._0);
    } else {
      return $$default;
    }
  };
  var show$1 = function (t) {
    if (t) {
      return Curry._1(CD.show, t._0);
    } else {
      return "";
    }
  };
  var parse$1 = function (str) {
    var str$1 = Curry._1(CD.parse, str);
    if (str$1 !== undefined) {
      return /* Conj */{
              _0: Caml_option.valFromOption(str$1)
            };
    } else {
      return /* End */0;
    }
  };
  var Conjs = {
    fold: fold$1,
    show: show$1,
    parse: parse$1
  };
  var isMark = function (str) {
    return List.mem(str, {
                hd: CD.nounMark,
                tl: {
                  hd: CD.verbMark,
                  tl: {
                    hd: CD.adMark,
                    tl: /* [] */0
                  }
                }
              });
  };
  var parse$2 = function (str) {
    var iter = function (pending, strs) {
      if (!strs) {
        return /* End */0;
      }
      var next = strs.tl;
      var conj = strs.hd;
      if (Curry._1(CD.mem, conj)) {
        return {
                TAG: /* Con */4,
                _0: parse$1(conj),
                _1: iter(/* P_N */0, next)
              };
      }
      if (next) {
        var next$1 = next.tl;
        var word = next.hd;
        if (conj === CD.nounMark && !isMark(word)) {
          return {
                  TAG: /* Noun */1,
                  _0: parse(word),
                  _1: iter(/* P_V */1, next$1)
                };
        }
        if (conj === CD.verbMark && !isMark(word)) {
          return {
                  TAG: /* Verb */2,
                  _0: parse(word),
                  _1: iter(/* P_N */0, next$1)
                };
        }
        if (conj === CD.adMark && !isMark(word)) {
          return {
                  TAG: /* Ad */3,
                  _0: parse(word),
                  _1: iter(/* P_A */2, next$1)
                };
        }
        
      }
      switch (pending) {
        case /* P_N */0 :
            return {
                    TAG: /* Noun */1,
                    _0: parse(strs.hd),
                    _1: iter(/* P_V */1, strs.tl)
                  };
        case /* P_V */1 :
            return {
                    TAG: /* Verb */2,
                    _0: parse(strs.hd),
                    _1: iter(/* P_N */0, strs.tl)
                  };
        case /* P_A */2 :
            return {
                    TAG: /* Ad */3,
                    _0: parse(strs.hd),
                    _1: iter(/* P_A */2, strs.tl)
                  };
        
      }
    };
    return {
            TAG: /* Start */0,
            _0: iter(/* P_N */0, $$String.split_on_char(/* ' ' */32, $$String.trim(str)))
          };
  };
  var mem = function (str) {
    return parse$2(str) !== /* End */0;
  };
  var show$2 = function (lex) {
    var n = SH.wrapNoun;
    var v = SH.wrapVerb;
    var a = SH.wrapAd;
    var m = SH.wrapMark;
    var p = SH.wrapPunctuation;
    var c = SH.wrapConj;
    var iter = function (_lex) {
      while(true) {
        var lex = _lex;
        if (typeof lex === "number") {
          return {
                  hd: Curry._1(p, "."),
                  tl: /* [] */0
                };
        }
        switch (lex.TAG | 0) {
          case /* Start */0 :
              var next = lex._0;
              if (typeof next === "number") {
                _lex = next;
                continue ;
              }
              if (next.TAG === /* Ad */3) {
                return {
                        hd: Curry._1(m, CD.adMark),
                        tl: iter({
                              TAG: /* Ad */3,
                              _0: next._0,
                              _1: next._1
                            })
                      };
              }
              _lex = next;
              continue ;
          case /* Noun */1 :
              var next$1 = lex._1;
              var root = lex._0;
              if (typeof next$1 !== "number") {
                switch (next$1.TAG | 0) {
                  case /* Noun */1 :
                      return {
                              hd: Curry._2(n, show(root), fold(root, TD.getNounDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.nounMark),
                                tl: iter({
                                      TAG: /* Noun */1,
                                      _0: next$1._0,
                                      _1: next$1._1
                                    })
                              }
                            };
                  case /* Ad */3 :
                      return {
                              hd: Curry._2(n, show(root), fold(root, TD.getNounDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.adMark),
                                tl: iter({
                                      TAG: /* Ad */3,
                                      _0: next$1._0,
                                      _1: next$1._1
                                    })
                              }
                            };
                  default:
                    
                }
              }
              return {
                      hd: Curry._2(n, show(root), fold(root, TD.getNounDef, "unknown")),
                      tl: iter(next$1)
                    };
          case /* Verb */2 :
              var next$2 = lex._1;
              var root$1 = lex._0;
              if (typeof next$2 !== "number") {
                switch (next$2.TAG | 0) {
                  case /* Verb */2 :
                      return {
                              hd: Curry._2(v, show(root$1), fold(root$1, TD.getVerbDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.verbMark),
                                tl: iter({
                                      TAG: /* Verb */2,
                                      _0: next$2._0,
                                      _1: next$2._1
                                    })
                              }
                            };
                  case /* Ad */3 :
                      return {
                              hd: Curry._2(v, show(root$1), fold(root$1, TD.getVerbDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.adMark),
                                tl: iter({
                                      TAG: /* Ad */3,
                                      _0: next$2._0,
                                      _1: next$2._1
                                    })
                              }
                            };
                  default:
                    
                }
              }
              return {
                      hd: Curry._2(v, show(root$1), fold(root$1, TD.getVerbDef, "unknown")),
                      tl: iter(next$2)
                    };
          case /* Ad */3 :
              var next$3 = lex._1;
              var root$2 = lex._0;
              if (typeof next$3 !== "number") {
                switch (next$3.TAG | 0) {
                  case /* Noun */1 :
                      return {
                              hd: Curry._2(a, show(root$2), fold(root$2, TD.getAdDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.nounMark),
                                tl: iter({
                                      TAG: /* Noun */1,
                                      _0: next$3._0,
                                      _1: next$3._1
                                    })
                              }
                            };
                  case /* Verb */2 :
                      return {
                              hd: Curry._2(a, show(root$2), fold(root$2, TD.getAdDef, "unknown")),
                              tl: {
                                hd: Curry._1(m, CD.verbMark),
                                tl: iter({
                                      TAG: /* Verb */2,
                                      _0: next$3._0,
                                      _1: next$3._1
                                    })
                              }
                            };
                  default:
                    
                }
              }
              return {
                      hd: Curry._2(a, show(root$2), fold(root$2, TD.getAdDef, "unknown")),
                      tl: iter(next$3)
                    };
          case /* Con */4 :
              var conj = lex._0;
              return {
                      hd: Curry._2(c, show$1(conj), fold$1(conj, CD.getDef, "unknown")),
                      tl: iter(lex._1)
                    };
          
        }
      };
    };
    return iter(lex);
  };
  var Lexs = {
    isMark: isMark,
    parse: parse$2,
    mem: mem,
    show: show$2
  };
  return {
          Roots: Roots,
          Conjs: Conjs,
          Lexs: Lexs
        };
}

var combMark = /* '-' */45;

export {
  combMark ,
  combMarkString ,
  Make ,
}
/* No side effect */
