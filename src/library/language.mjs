

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$String from "rescript/lib/es6/string.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as AbstractDict from "./abstractDict.mjs";

function Make(Marks, Show) {
  var translate = function (str, dict) {
    return Curry._2(AbstractDict.MyDict.find_opt, str, dict);
  };
  var parse = function (marks, str) {
    var isMark = function (str) {
      return Belt_List.some({
                  hd: Marks.noun,
                  tl: {
                    hd: Marks.verb,
                    tl: {
                      hd: Marks.ad,
                      tl: /* [] */0
                    }
                  }
                }, (function (mark) {
                    return mark === str;
                  }));
    };
    var toMark = function (str) {
      if (str === Marks.noun) {
        return /* Noun */0;
      } else if (str === Marks.verb) {
        return /* Verb */1;
      } else {
        return /* Ad */2;
      }
    };
    var iter = function (_mark, _strs) {
      while(true) {
        var strs = _strs;
        var mark = _mark;
        if (!strs) {
          return /* End */0;
        }
        var next = strs.tl;
        var con = strs.hd;
        if (Belt_Option.isSome(Curry._2(AbstractDict.MyDict.find_opt, con, marks))) {
          return {
                  TAG: /* Con */4,
                  _0: con,
                  _1: iter(/* Noun */0, next)
                };
        }
        if (next) {
          var markB = next.hd;
          if (isMark(con) && isMark(markB)) {
            _strs = {
              hd: markB,
              tl: next.tl
            };
            continue ;
          }
          
        }
        if (isMark(con)) {
          _strs = next;
          _mark = toMark(con);
          continue ;
        }
        switch (mark) {
          case /* Noun */0 :
              return {
                      TAG: /* Noun */1,
                      _0: strs.hd,
                      _1: iter(/* Verb */1, strs.tl)
                    };
          case /* Verb */1 :
              return {
                      TAG: /* Verb */2,
                      _0: strs.hd,
                      _1: iter(/* Noun */0, strs.tl)
                    };
          case /* Ad */2 :
              return {
                      TAG: /* Ad */3,
                      _0: strs.hd,
                      _1: iter(/* Ad */2, strs.tl)
                    };
          
        }
      };
    };
    return {
            TAG: /* Start */0,
            _0: iter(/* Noun */0, $$String.split_on_char(/* ' ' */32, $$String.trim(str)))
          };
  };
  var show = function (lex) {
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
                            hd: Curry._1(Show.mark, Marks.verb),
                            tl: iter({
                                  TAG: /* Ad */3,
                                  _0: next._0,
                                  _1: next._1
                                })
                          };
                case /* Ad */3 :
                    return {
                            hd: Curry._1(Show.mark, Marks.ad),
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
                        hd: Curry._1(Show.noun, root),
                        tl: iter(next$1)
                      };
              }
              switch (next$1.TAG | 0) {
                case /* Noun */1 :
                    return {
                            hd: Curry._1(Show.noun, root),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.noun),
                              tl: iter({
                                    TAG: /* Noun */1,
                                    _0: next$1._0,
                                    _1: next$1._1
                                  })
                            }
                          };
                case /* Ad */3 :
                    return {
                            hd: Curry._1(Show.noun, root),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.ad),
                              tl: iter({
                                    TAG: /* Ad */3,
                                    _0: next$1._0,
                                    _1: next$1._1
                                  })
                            }
                          };
                default:
                  return {
                          hd: Curry._1(Show.noun, root),
                          tl: iter(next$1)
                        };
              }
          case /* Verb */2 :
              var next$2 = lex._1;
              var root$1 = lex._0;
              if (typeof next$2 === "number") {
                return {
                        hd: Curry._1(Show.verb, root$1),
                        tl: iter(next$2)
                      };
              }
              switch (next$2.TAG | 0) {
                case /* Verb */2 :
                    return {
                            hd: Curry._1(Show.verb, root$1),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.verb),
                              tl: iter({
                                    TAG: /* Verb */2,
                                    _0: next$2._0,
                                    _1: next$2._1
                                  })
                            }
                          };
                case /* Ad */3 :
                    return {
                            hd: Curry._1(Show.verb, root$1),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.ad),
                              tl: iter({
                                    TAG: /* Ad */3,
                                    _0: next$2._0,
                                    _1: next$2._1
                                  })
                            }
                          };
                default:
                  return {
                          hd: Curry._1(Show.verb, root$1),
                          tl: iter(next$2)
                        };
              }
          case /* Ad */3 :
              var next$3 = lex._1;
              var root$2 = lex._0;
              if (typeof next$3 === "number") {
                return {
                        hd: Curry._1(Show.ad, root$2),
                        tl: iter(next$3)
                      };
              }
              switch (next$3.TAG | 0) {
                case /* Noun */1 :
                    return {
                            hd: Curry._1(Show.ad, root$2),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.noun),
                              tl: iter({
                                    TAG: /* Noun */1,
                                    _0: next$3._0,
                                    _1: next$3._1
                                  })
                            }
                          };
                case /* Verb */2 :
                    return {
                            hd: Curry._1(Show.ad, root$2),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.verb),
                              tl: iter({
                                    TAG: /* Verb */2,
                                    _0: next$3._0,
                                    _1: next$3._1
                                  })
                            }
                          };
                default:
                  return {
                          hd: Curry._1(Show.ad, root$2),
                          tl: iter(next$3)
                        };
              }
          case /* Con */4 :
              var next$4 = lex._1;
              var con = lex._0;
              if (typeof next$4 === "number") {
                return {
                        hd: Curry._1(Show.con, con),
                        tl: iter(next$4)
                      };
              }
              switch (next$4.TAG | 0) {
                case /* Verb */2 :
                    return {
                            hd: Curry._1(Show.con, con),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.verb),
                              tl: iter({
                                    TAG: /* Verb */2,
                                    _0: next$4._0,
                                    _1: next$4._1
                                  })
                            }
                          };
                case /* Ad */3 :
                    return {
                            hd: Curry._1(Show.con, con),
                            tl: {
                              hd: Curry._1(Show.mark, Marks.ad),
                              tl: iter({
                                    TAG: /* Ad */3,
                                    _0: next$4._0,
                                    _1: next$4._1
                                  })
                            }
                          };
                default:
                  return {
                          hd: Curry._1(Show.con, con),
                          tl: iter(next$4)
                        };
              }
          
        }
      };
    };
    return iter(lex);
  };
  return {
          translate: translate,
          parse: parse,
          show: show
        };
}

var MyDict = AbstractDict.MyDict;

var combMark = /* '-' */45;

var combMarkString = "-";

export {
  MyDict ,
  combMark ,
  combMarkString ,
  Make ,
}
/* AbstractDict Not a pure module */
