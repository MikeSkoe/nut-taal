%%raw("import './app.css'")

module Lang = Language.Make (Dictionary.Term) (Dictionary.Conj)

let rec rootEl = (root: Lang.Roots.t, onClick) => switch root {
    | Root(root, End) => <span onClick={_ => onClick(root)}>{root->Dictionary.Term.show->React.string}</span>
    | Root(root, next) => <>
        <span onClick={_ => onClick(root)}>
            {root->Dictionary.Term.show->React.string}
            {Language.combMarkString->React.string}
        </span>
        {rootEl(next, onClick)}
    </>
    | Prop(root) => <u>{root->React.string}</u>
    | _ => <></>
}

let nounEl = (root, onClick, isFirstWord) =>
    <span className="noun">
        {isFirstWord
            ? React.null
            : <>
                {Dictionary.Conj.nounMark->React.string}
                {" "->React.string}
            </>}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let verbEl = (root, onClick) =>
    <span className="verb">
        {Dictionary.Conj.verbMark->React.string}
        {" "->React.string}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let adEl = (root, onClick, isFirstWord) =>
    <span className="ad">
        {isFirstWord
            ? <>
                {Dictionary.Conj.adMark->React.string}
                {" "->React.string}
            </>
            : React.null}
        {" "->React.string}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let rec toEl = (pars: Lang.Lexs.t, onClick, ~isFirstWord = false, ()) => switch pars {
    | End => <></>
    | Noun(root, next) => <>
        {nounEl(root, onClick, isFirstWord)}
        {toEl(next, onClick, ())}
    </>
    | Verb(root, next) => <>
        {verbEl(root, onClick)}
        {toEl(next, onClick, ())}
    </>
    | Ad(root, next) => <>
        {adEl(root, onClick, isFirstWord)}
        {toEl(next, onClick, ())}
    </>
    | Con(root, Noun(noun, next)) =>
        <>
            <b>
                {(Lang.Conjs.show(root)++" ")->React.string}
            </b>
            {toEl(Noun(noun, next), onClick, ~isFirstWord=true, ())}
        </>
    | Con(root, Ad(noun, next)) =>
        <>
            <b>
                {(Lang.Conjs.show(root)++" ")->React.string}
            </b>
            {toEl(Ad(noun, next), onClick, ~isFirstWord=true, ())}
        </>
    | Con(root, next) =>
        <>
            <b>
                {(Lang.Conjs.show(root)++" ")->React.string}
            </b>
            {toEl(next, onClick, ())}
        </>
}

module Hint = {
    @react.component
    let make = (~str) => {
        let term = Dictionary.Term.parse(str);
        switch term {
            | None => <></>
            | Some(term) => {
                <table className="is-striped">
                    <tr>
                        <th>{str->React.string}</th>
                        <th>{"noun: "->React.string}{term->Dictionary.Term.getNounDef->React.string}</th>
                        <th>{"verb: "->React.string}{term->Dictionary.Term.getVerbDef->React.string}</th>
                        <th>{"ad: "->React.string}{term->Dictionary.Term.getAdjDef->React.string}</th>
                    </tr>
                </table>
            }
        }
    }
}

module Dict = {
    @react.component
    let make = () => {
        let (terms, setTerms) = React.useState(_ => list{})

        React.useEffect0(() => {
            Dictionary.Term.all
            |> Js.Promise.then_ (terms => setTerms(_ => terms)->Js.Promise.resolve)
            |> ignore;
            None;
        })

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
                    terms
                    ->Belt.List.map(term =>
                        <tr key={term->Dictionary.Term.show}>
                            <td>{term->Dictionary.Term.show->React.string}</td>
                            <td>{`${term->Dictionary.Term.getNounDef} / ${term->Dictionary.Term.getVerbDef} / ${term->Dictionary.Term.getAdjDef}`->React.string}</td>
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
        let (terms, setTerms) = React.useState(_ => list{})

        React.useEffect0(() => {
            Dictionary.Conj.all
            |> Js.Promise.then_ (terms => setTerms(_ => terms)->Js.Promise.resolve)
            |> ignore;
            None;
        })

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
                    terms
                    ->Belt.List.map(term =>
                        <tr key={term->Dictionary.Conj.show}>
                            <td>{term->Dictionary.Conj.show->React.string}</td>
                            <td>{term->Dictionary.Conj.getDef->React.string}</td>
                            <td>{term->Dictionary.Conj.getDescription->React.string}</td>
                        </tr>)
                    ->Belt.List.toArray
                    ->React.array
                }
            </tbody>
        </table>
    }
}

@react.component
let make = () => {
    let (hint, setHint) = React.useState(_ => "");
    let (input, setInput) = React.useState(_ => "");
    let onChange = event => setInput((event->ReactEvent.Form.target)["value"])

    <div className="flex" direction="column">
        <textarea onChange={onChange} inputMode="text"/>
        <div>{
            input
            ->Lang.Lexs.parse
            ->toEl(str => setHint(_ => str->Dictionary.Term.show), ~isFirstWord=true, ())
        }</div>
        <Hint str={hint} />
        <Dict />
        <ConjDict />
    </div>
}
