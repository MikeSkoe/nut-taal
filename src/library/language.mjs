

import * as List from "rescript/lib/es6/list.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";

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
                tl: iter(t._1)
              };
      }
    };
    return Belt_List.reduce(iter(t), "", (function (acc, curr) {
                  if (acc === "") {
                    return curr;
                  } else {
                    return "" + acc + "" + combMarkString + "" + curr + "";
                  }
                }));
  };
  var parse = function (str) {
    var iter = function (str) {
      if (!str) {
        return /* End */0;
      }
      var next = str.tl;
      var word = str.hd;
      var compound = Belt_List.reduce({
            hd: word,
            tl: next
          }, "", (function (acc, curr) {
              if (acc === "") {
                return curr;
              } else {
                return "" + acc + "" + combMarkString + "" + curr + "";
              }
            }));
      var word$1 = Curry._1(TD.parse, compound);
      if (word$1 !== undefined) {
        return {
                TAG: /* Root */0,
                _0: word$1,
                _1: /* End */0
              };
      }
      var word$2 = Curry._1(TD.parse, word);
      if (word$2 !== undefined) {
        return {
                TAG: /* Root */0,
                _0: word$2,
                _1: iter(next)
              };
      } else {
        return {
                TAG: /* Prop */1,
                _0: word,
                _1: iter(next)
              };
      }
    };
    return iter($$String.split_on_char(/* '-' */45, str));
  };
  var Roots_translate = TD.translate;
  var Roots = {
    fold: fold,
    show: show,
    parse: parse,
    translate: Roots_translate
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
              _0: str$1
            };
    } else {
      return /* End */0;
    }
  };
  var Conjs_translate = CD.translate;
  var Conjs = {
    fold: fold$1,
    show: show$1,
    parse: parse$1,
    translate: Conjs_translate
  };
  var isMark = function (__x) {
    return List.mem(__x, {
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
    var m = SH.wrapMark;
    var c = function (conj) {
      return Curry._2(SH.wrapConj, show$1(conj), fold$1(conj, (function (t) {
                        return t.definition;
                      }), "unknown"));
    };
    var iterRoot = function (readTerm, noun) {
      if (typeof noun === "number") {
        return /* [] */0;
      }
      if (noun.TAG === /* Root */0) {
        var term = noun._0;
        return {
                hd: [
                  true,
                  term.str,
                  Curry._1(readTerm, term)
                ],
                tl: iterRoot(readTerm, noun._1)
              };
      }
      var term$1 = noun._0;
      return {
              hd: [
                false,
                term$1,
                term$1
              ],
              tl: iterRoot(readTerm, noun._1)
            };
    };
    var n = function (root) {
      return Curry._1(SH.wrapNoun, iterRoot((function (term) {
                        return term.noun;
                      }), root));
    };
    var v = function (root) {
      return Curry._1(SH.wrapVerb, iterRoot((function (term) {
                        return term.verb;
                      }), root));
    };
    var a = function (root) {
      return Curry._1(SH.wrapAd, iterRoot((function (term) {
                        return term.ad;
                      }), root));
    };
    var iter = function (_lex) {
      while(true) {
        var lex = _lex;
        if (typeof lex === "number") {
          return /* [] */0;
        }
        switch (lex.TAG | 0) {
          case /* Start */0 :
              var next = lex._0;
              if (typeof next === "number") {
                _lex = next;
                continue ;
              }
              switch (next.TAG | 0) {
                case /* Verb */2 :
                    return {
                            hd: Curry._1(m, CD.verbMark),
                            tl: iter({
                                  TAG: /* Ad */3,
                                  _0: next._0,
                                  _1: next._1
                                })
                          };
                case /* Ad */3 :
                    return {
                            hd: Curry._1(m, CD.adMark),
                            tl: iter({
                                  TAG: /* Ad */3,
                                  _0: next._0,
                                  _1: next._1
                                })
                          };
                default:
                  _lex = next;
                  continue ;
              }
          case /* Noun */1 :
              var next$1 = lex._1;
              var root = lex._0;
              if (typeof next$1 === "number") {
                return {
                        hd: n(root),
                        tl: iter(next$1)
                      };
              }
              switch (next$1.TAG | 0) {
                case /* Noun */1 :
                    return {
                            hd: n(root),
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
                            hd: n(root),
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
                  return {
                          hd: n(root),
                          tl: iter(next$1)
                        };
              }
          case /* Verb */2 :
              var next$2 = lex._1;
              var root$1 = lex._0;
              if (typeof next$2 === "number") {
                return {
                        hd: v(root$1),
                        tl: iter(next$2)
                      };
              }
              switch (next$2.TAG | 0) {
                case /* Verb */2 :
                    return {
                            hd: v(root$1),
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
                            hd: v(root$1),
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
                  return {
                          hd: v(root$1),
                          tl: iter(next$2)
                        };
              }
          case /* Ad */3 :
              var next$3 = lex._1;
              var root$2 = lex._0;
              if (typeof next$3 === "number") {
                return {
                        hd: a(root$2),
                        tl: iter(next$3)
                      };
              }
              switch (next$3.TAG | 0) {
                case /* Noun */1 :
                    return {
                            hd: a(root$2),
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
                            hd: a(root$2),
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
                  return {
                          hd: a(root$2),
                          tl: iter(next$3)
                        };
              }
          case /* Con */4 :
              var next$4 = lex._1;
              var conj = lex._0;
              if (typeof next$4 === "number") {
                return {
                        hd: c(conj),
                        tl: iter(next$4)
                      };
              }
              switch (next$4.TAG | 0) {
                case /* Verb */2 :
                    return {
                            hd: c(conj),
                            tl: {
                              hd: Curry._1(m, CD.verbMark),
                              tl: iter({
                                    TAG: /* Verb */2,
                                    _0: next$4._0,
                                    _1: next$4._1
                                  })
                            }
                          };
                case /* Ad */3 :
                    return {
                            hd: c(conj),
                            tl: {
                              hd: Curry._1(m, CD.adMark),
                              tl: iter({
                                    TAG: /* Ad */3,
                                    _0: next$4._0,
                                    _1: next$4._1
                                  })
                            }
                          };
                default:
                  return {
                          hd: c(conj),
                          tl: iter(next$4)
                        };
              }
          
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
