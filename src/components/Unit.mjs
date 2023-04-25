

import * as Lang from "../Lang.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dictionary from "../library/dictionary.mjs";
import * as Caml_module from "rescript/lib/es6/caml_module.js";

function hint(lex) {
  if (typeof lex === "number") {
    return "";
  }
  switch (lex.TAG | 0) {
    case /* Noun */0 :
        return Curry._3(Lang.Lang.Roots.fold, lex._0, Dictionary.Term.getNounDef, "uknown");
    case /* Verb */1 :
        return Curry._3(Lang.Lang.Roots.fold, lex._0, Dictionary.Term.getVerbDef, "uknown");
    case /* Ad */2 :
        return Curry._3(Lang.Lang.Roots.fold, lex._0, Dictionary.Term.getAdDef, "uknown");
    case /* Con */3 :
        return Curry._3(Lang.Lang.Conjs.fold, lex._0, Dictionary.Conj.getDef, "uknown");
    
  }
}

var Root = Caml_module.init_mod([
      "Unit.res",
      21,
      4
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

function Unit$Root(props) {
  var root = props.root;
  if (typeof root === "number") {
    return React.createElement(React.Fragment, undefined);
  } else if (root.TAG === /* Root */0) {
    return React.createElement("span", undefined, Curry._1(Lang.Lang.Roots.show, {
                    TAG: /* Root */0,
                    _0: root._0,
                    _1: root._1
                  }));
  } else {
    return React.createElement("u", undefined, root._0);
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, Root, {
      make: Unit$Root
    });

function Unit$Tooltip(props) {
  return React.createElement("span", {
              className: "tooltip"
            }, props.hint);
}

var Tooltip = {
  make: Unit$Tooltip
};

function Unit$Noun(props) {
  var root = props.root;
  return React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "noun"
                }, " ", React.createElement(Root.make, {
                      root: root
                    }), React.createElement(Unit$Tooltip, {
                      hint: hint({
                            TAG: /* Noun */0,
                            _0: root,
                            _1: /* End */0
                          })
                    })), props.children);
}

var Noun = {
  make: Unit$Noun
};

function Unit$Verb(props) {
  var root = props.root;
  return React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "verb"
                }, " ", React.createElement(Root.make, {
                      root: root
                    }), React.createElement(Unit$Tooltip, {
                      hint: hint({
                            TAG: /* Verb */1,
                            _0: root,
                            _1: /* End */0
                          })
                    })), props.children);
}

var Verb = {
  make: Unit$Verb
};

function Unit$Ad(props) {
  var root = props.root;
  return React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "ad"
                }, " ", React.createElement(Root.make, {
                      root: root
                    }), React.createElement(Unit$Tooltip, {
                      hint: hint({
                            TAG: /* Ad */2,
                            _0: root,
                            _1: /* End */0
                          })
                    })), props.children);
}

var Ad = {
  make: Unit$Ad
};

function Unit$Conj(props) {
  var conj = props.conj;
  return React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "conj"
                }, " ", Curry._1(Lang.Lang.Conjs.show, conj) + " ", React.createElement(Unit$Tooltip, {
                      hint: hint({
                            TAG: /* Con */3,
                            _0: conj,
                            _1: /* End */0
                          })
                    })), props.children);
}

var Conj = {
  make: Unit$Conj
};

var El = Caml_module.init_mod([
      "Unit.res",
      95,
      4
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

function Unit$El(props) {
  var pars = props.pars;
  if (typeof pars === "number") {
    return React.createElement(React.Fragment, undefined);
  }
  switch (pars.TAG | 0) {
    case /* Noun */0 :
        return React.createElement(Unit$Noun, {
                    root: pars._0,
                    children: React.createElement(El.make, {
                          pars: pars._1
                        })
                  });
    case /* Verb */1 :
        return React.createElement(Unit$Verb, {
                    root: pars._0,
                    children: React.createElement(El.make, {
                          pars: pars._1
                        })
                  });
    case /* Ad */2 :
        return React.createElement(Unit$Ad, {
                    root: pars._0,
                    children: React.createElement(El.make, {
                          pars: pars._1
                        })
                  });
    case /* Con */3 :
        var next = pars._1;
        var conj = pars._0;
        if (typeof next !== "number") {
          switch (next.TAG | 0) {
            case /* Noun */0 :
                return React.createElement(Unit$Conj, {
                            conj: conj,
                            children: React.createElement(El.make, {
                                  pars: {
                                    TAG: /* Noun */0,
                                    _0: next._0,
                                    _1: next._1
                                  }
                                })
                          });
            case /* Ad */2 :
                return React.createElement(Unit$Conj, {
                            conj: conj,
                            children: React.createElement(El.make, {
                                  pars: {
                                    TAG: /* Ad */2,
                                    _0: next._0,
                                    _1: next._1
                                  }
                                })
                          });
            default:
              
          }
        }
        return React.createElement(Unit$Conj, {
                    conj: conj,
                    children: React.createElement(El.make, {
                          pars: next
                        })
                  });
    
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, El, {
      make: Unit$El
    });

export {
  hint ,
  Root ,
  Tooltip ,
  Noun ,
  Verb ,
  Ad ,
  Conj ,
  El ,
}
/* Root Not a pure module */
