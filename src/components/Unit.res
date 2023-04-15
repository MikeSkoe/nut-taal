open Lang

let hint = (lex: Lang.Lexs.t) => {
    switch lex {
        | End =>
            ""
        | Noun(root, _) =>
            root->Lang.Roots.fold(Dictionary.Term.getNounDef, "uknown")
        | Verb(root, _) =>
            root->Lang.Roots.fold(Dictionary.Term.getVerbDef, "uknown")
        | Ad(root, _) =>
            root->Lang.Roots.fold(Dictionary.Term.getAdDef, "uknown")
        | Con(conj, _) =>
            conj->Lang.Conjs.fold(Dictionary.Conj.getDef, "uknown")
    }
}

module rec Root: {
    @react.component
    let make: (~root: Lang.Roots.t) => React.element
} = {
    @react.component
    let make = (~root: Lang.Roots.t) => {
        switch root {
            | Root(root, End) => <span>
                {root->Dictionary.Term.show->React.string}
            </span>
            | Root(root, next) => <>
                <span>
                    {root->Dictionary.Term.show->React.string}
                    {Language.combMarkString->React.string}
                </span>
                <Root root=next />
            </>
            | Prop(root) => <u>
                {root->React.string}
            </u>
            | _ =>
                <></>
        }
    }
}

module Tooltip = {
    @react.component
    let make = (~hint) =>
        <span className="tooltip">
            {hint->React.string}
        </span>
}

module Noun = {
    @react.component
    let make = (~root) => {
        <span className="noun">
            <Root root={root} />
            {" "->React.string}
            <Tooltip hint={hint(Lang.Lexs.Noun(root, End))} />
        </span>
    }
}

module Verb = {
    @react.component
    let make = (~root) => {
        <span className="verb">
            <Root root=root />
            {" "->React.string}
            <Tooltip hint={hint(Lang.Lexs.Verb(root, End))} />
        </span>
    }
}

module Ad = {
    @react.component
    let make = (~root) => {
        <span className="ad">
            <Root root=root />
            {" "->React.string}
            <Tooltip hint={hint(Lang.Lexs.Ad(root, End))} />
        </span>
    }
}

module Aux = {
    @react.component
    let make = (~conj) => {
        <span className="aux">
            {(Lang.Conjs.show(conj)++" ")->React.string}
            {" "->React.string}
            <Tooltip hint={hint(Lang.Lexs.Con(conj, End))} />
        </span>
    }
}

module rec El: {
    @react.component
    let make: (~pars: Lang.Lexs.t) => React.element
} = {
    @react.component
    let make = (~pars: Lang.Lexs.t) => switch pars {
        | End => <></>
        | Noun(root, next) => <>
            <Noun root=root />
            <El pars=next />
        </>
        | Verb(root, next) => <>
            <Verb root=root />
            <El pars=next />
        </>
        | Ad(root, next) => <>
            <Ad root=root />
            <El pars=next />
        </>
        | Con(conj, Noun(noun, next)) => <>
            <Aux conj=conj />
            <El pars=Noun(noun, next) />
        </>
        | Con(conj, Ad(noun, next)) => <>
            <Aux conj=conj />
            <El pars=Ad(noun, next) />
        </>
        | Con(conj, next) => <>
            <Aux conj=conj />
            <El pars=next />
        </>
    }
}
