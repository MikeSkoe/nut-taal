%%raw("import './app.css'")

module Lang = Language.Make (Dictionary.Term) (Dictionary.Conj)

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

let rec rootEl = (root: Lang.Roots.t) => switch root {
    | Root(root, End) =>
        <span>
            {root->Dictionary.Term.show->React.string}
        </span>
    | Root(root, next) => <>
        <span>
            {root->Dictionary.Term.show->React.string}
            {Language.combMarkString->React.string}
        </span>
        {rootEl(next)}
    </>
    | Prop(root) =>
        <u>
            {root->React.string}
        </u>
    | _ =>
        <></>
}

let nounEl = (root) =>
    <span className="noun">
        {rootEl(root)}
        {" "->React.string}
        <span className="tooltip">{hint(Lang.Lexs.Noun(root, End))->React.string}</span>
    </span>

let verbEl = (root) =>
    <span className="verb">
        {rootEl(root)}
        {" "->React.string}
        <span className="tooltip">{hint(Lang.Lexs.Verb(root, End))->React.string}</span>
    </span>

let adEl = (root) =>
    <span className="ad">
        {rootEl(root)}
        {" "->React.string}
        <span className="tooltip">{hint(Lang.Lexs.Ad(root, End))->React.string}</span>
    </span>

let auxEl = (conj) =>
    <b>
        {(Lang.Conjs.show(conj)++" ")->React.string}
        {" "->React.string}
        <span className="tooltip">{hint(Lang.Lexs.Con(conj, End))->React.string}</span>
    </b>

let rec toEl = (pars: Lang.Lexs.t) => switch pars {
    | End => <></>
    | Noun(root, next) => <> {nounEl(root)} {toEl(next)} </>
    | Verb(root, next) => <> {verbEl(root)} {toEl(next)} </>
    | Ad(root, next) => <> {adEl(root)} {toEl(next)} </>
    | Con(conj, Noun(noun, next)) => <> {auxEl(conj)} {toEl(Noun(noun, next))} </>
    | Con(conj, Ad(noun, next)) => <> {auxEl(conj)} {toEl(Ad(noun, next))} </>
    | Con(conj, next) => <> {auxEl(conj)} {toEl(next)} </>
}

module DictionaryContext = {
    let termsContext: React.Context.t<list<Dictionary.Term.t>> = React.createContext(list{});
    let conjsContext: React.Context.t<list<Dictionary.Conj.t>> = React.createContext(list{}); 

    module TermProvider = {
        let make = React.Context.provider(termsContext);
    }

    module ConjProvider = {
        let make = React.Context.provider(conjsContext);
    }

    @react.component
    let make = (~children) => {
        let (terms, setTerms) = React.useState(_ => list{})
        let (conjs, setConjs) = React.useState(_ => list{})

        React.useEffect0(() => {
            Dictionary.Conj.all
            |> Js.Promise.then_ (conjs => setConjs(_ => conjs)->Js.Promise.resolve)
            |> ignore;
            None;
        })

        React.useEffect0(() => {
            Dictionary.Term.all
            |> Js.Promise.then_ (terms => setTerms(_ => terms)->Js.Promise.resolve)
            |> ignore;
            None;
        })

        <TermProvider value={terms}>
            <ConjProvider value={conjs}>
                {children}
            </ConjProvider>
        </TermProvider>
    }
}

module Dict = {
    @react.component
    let make = () => {
        let terms = React.useContext(DictionaryContext.termsContext)

        <table className="is-striped">
            <thead>
                <tr>
                    <th>{"term"->React.string}</th>
                    <th>{"noun"->React.string}</th>
                    <th>{"verb"->React.string}</th>
                    <th>{"ad"->React.string}</th>
                    <th>{"description"->React.string}</th>
                </tr>
            </thead>
            <tbody>
                {
                    terms
                    ->Belt.List.map(term =>
                        <tr key={term->Dictionary.Term.show}>
                            <td>{term->Dictionary.Term.show->React.string}</td>
                            <td>{term->Dictionary.Term.getNounDef->React.string}</td>
                            <td>{term->Dictionary.Term.getVerbDef->React.string}</td>
                            <td>{term->Dictionary.Term.getAdDef->React.string}</td>
                            <td>{term->Dictionary.Term.getDescription->React.string}</td>
                        </tr>)
                    ->Belt.List.toArray
                    ->React.array
                }
            </tbody>
        </table>
    }
}

module ConjDict = {
    @react.component
    let make = () => {
        let conjs = React.useContext(DictionaryContext.conjsContext);

        <table className="is-striped">
            <thead>
                <tr>
                    <th>{"term"->React.string}</th>
                    <th>{"noun / verb / ad"->React.string}</th>
                    <th>{"description"->React.string}</th>
                </tr>
            </thead>
            <tbody>
                {
                    conjs
                    ->Belt.List.map(conj =>
                        <tr key={conj->Dictionary.Conj.show}>
                            <td>{conj->Dictionary.Conj.show->React.string}</td>
                            <td>{conj->Dictionary.Conj.getDef->React.string}</td>
                            <td>{conj->Dictionary.Conj.getDescription->React.string}</td>
                        </tr>)
                    ->Belt.List.toArray
                    ->React.array
                }
            </tbody>
        </table>
    }
}

module Parser = {
    @react.component
    let make = (~text) => {
        let (input, setInput) = React.useState(_ => text);
        let onChange = event => setInput((event->ReactEvent.Form.target)["value"]);

        <>
            <div>{input->Lang.Lexs.parse->toEl}</div>
            <textarea onChange={onChange} inputMode="text"/>
        </>
    }
}

@react.component
let make = () => {
    let url = RescriptReactRouter.useUrl();

    <DictionaryContext>
        <>
            {switch url.path {
                | list{"text", text} => <Parser text={text->Js.String2.replaceByRe(%re("/_/g"), " ")} />
                | _ => <Parser text="" />
            }}

            <div className="flex" direction="column">
                <Dict />
                <ConjDict />
            </div>
        </>
    </DictionaryContext>
}
