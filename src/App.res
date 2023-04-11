%%raw("import './app.css'")

module Lang = Lang.Make (Dictionary.Term) (Dictionary.Conj)

let rec rootEl = (root: Lang.Roots.t, onClick) => switch root {
    | Root(root, End) => <span onClick={_ => onClick(root)}>{root->Dictionary.Term.show->React.string}</span>
    | Root(root, next) => {
        Js.log(root);
        Js.log(next);
        <>
            <span onClick={_ => onClick(root)}>
                {root->Dictionary.Term.show->React.string}
                {"+"->React.string}
            </span>
            {rootEl(next, onClick)}
        </>
    }
    | Prop(root) => <u>{root->React.string}</u>
    | _ => <></>
}

let nounEl = (root, onClick, isFirstWord) =>
    <span className="noun">
        {isFirstWord
            ? React.null
            : <>
                {Lang.nounMark->React.string}
                {" "->React.string}
            </>}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let verbEl = (root, onClick) =>
    <span className="verb">
        {Lang.verbMark->React.string}
        {" "->React.string}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let adEl = (root, onClick) =>
    <span className="ad">
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
        {adEl(root, onClick)}
        {toEl(next, onClick, ())}
    </>
    | Con(root, next) =>
        <>
            <b>
                {(Dictionary.Conj.show(root)++" ")->React.string}
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
                        <th>{"ad: "->React.string}{term->Dictionary.Term.getAdDef->React.string}</th>
                    </tr>
                </table>
            }
        }
    }
}

module Dict = {
    @react.component
    let make = () => {
        <table className="is-striped">
            <tr>
                <th>{"term"->React.string}</th>
                <th>{"noun / verb / ad"->React.string}</th>
                <th>{"description"->React.string}</th>
            </tr>
            {
                Dictionary.Term.all
                ->Belt.List.map(term =>
                    <tr>
                        <td>{term->Dictionary.Term.show->React.string}</td>
                        <td>{`${term->Dictionary.Term.getNounDef} / ${term->Dictionary.Term.getVerbDef} / ${term->Dictionary.Term.getAdDef}`->React.string}</td>
                        <td>{term->Dictionary.Term.getDescription->React.string}</td>
                    </tr>)
                ->Belt.List.toArray
                ->React.array
            }
        </table>
    }
}

module ConjDict = {
    @react.component
    let make = () => {
        <table className="is-striped">
            <tr>
                <th>{"term"->React.string}</th>
                <th>{"noun / verb / ad"->React.string}</th>
                <th>{"description"->React.string}</th>
            </tr>
            {
                Dictionary.Conj.all
                ->Belt.List.map(term =>
                    <tr>
                        <td>{term->Dictionary.Conj.show->React.string}</td>
                        <td>{term->Dictionary.Conj.getDef->React.string}</td>
                        <td>{term->Dictionary.Conj.getDescription->React.string}</td>
                    </tr>)
                ->Belt.List.toArray
                ->React.array
            }
        </table>
    }
}

@react.component
let make = () => {
    let (hint, setHint) = React.useState(_ => "");
    let (input, setInput) = React.useState(_ => "");
    let onChange = event => setInput((event->ReactEvent.Form.target)["value"])
  
    <div className="flex" direction="row">
        <div>
            <textarea onChange={onChange} inputMode="text"/>
            <div>{
                input
                ->Lang.Lexs.parse
                ->toEl(str => setHint(_ => str->Dictionary.Term.show), ~isFirstWord=true, ())
            }</div>
        </div>
        <div>
            <Hint str={hint} />
            <Dict />
            <ConjDict />
        </div>
    </div>
}
