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
    let make = (~root, ~children) => <>
        <span className="noun">
            {" "->React.string}
            <Root root={root} />
            <Tooltip hint={hint(Lang.Lexs.Noun(root, End))} />
        </span>
        {children}
    </>
}

module Verb = {
    @react.component
    let make = (~root, ~children) => <>
        <span className="verb">
            {" "->React.string}
            <Root root=root />
            <Tooltip hint={hint(Lang.Lexs.Verb(root, End))} />
        </span>
        {children}
    </>
}

module Ad = {
    @react.component
    let make = (~root, ~children) => <>
        <span className="ad">
            {" "->React.string}
            <Root root=root />
            <Tooltip hint={hint(Lang.Lexs.Ad(root, End))} />
        </span>
        {children}
    </>
}

module Conj = {
    @react.component
    let make = (~conj, ~children) => <>
        <span className="conj">
            {" "->React.string}
            {(Lang.Conjs.show(conj)++" ")->React.string}
            <Tooltip hint={hint(Lang.Lexs.Con(conj, End))} />
        </span>
        {children}
    </>
}

module rec El: {
    @react.component
    let make: (~pars: Lang.Lexs.t) => React.element
} = {
    @react.component
    let make = (~pars: Lang.Lexs.t) => switch pars {
        | End =>
            <></>
        | Noun(root, next) =>
            <Noun root=root> <El pars=next /> </Noun>
        | Verb(root, next) =>
            <Verb root=root> <El pars=next /> </Verb>
        | Ad(root, next) =>
            <Ad root=root> <El pars=next /> </Ad>
        | Con(conj, Noun(noun, next)) =>
            <Conj conj=conj> <El pars=Noun(noun, next) /> </Conj>
        | Con(conj, Ad(noun, next)) =>
            <Conj conj=conj> <El pars=Ad(noun, next) /> </Conj>
        | Con(conj, next) =>
            <Conj conj=conj> <El pars=next /> </Conj>
    }
}
