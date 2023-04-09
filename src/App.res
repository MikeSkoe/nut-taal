%%raw("import './app.css'")

include Lang

let rec rootEl = (root, onClick) => switch root {
    | Root(root, End) => <span onClick={_ => onClick(root)}>{root->React.string}</span>
    | Root(root, next) => <>
        <span onClick={_ => onClick(root)}>
            {root->React.string}
            {"+"->React.string}
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
                {Lexs.nounMark->React.string}
                {" "->React.string}
            </>}
        {rootEl(root, onClick)}
        {" "->React.string}
    </span>

let verbEl = (root, onClick) =>
    <span className="verb">
        {Lexs.verbMark->React.string}
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

let rec toEl = (pars, onClick, ~isFirstWord = false, ()) => switch pars {
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
                {(Conjs.show(root)++" ")->React.string}
            </b>
            {toEl(next, onClick, ())}
        </>
}

module Hint = {
    @react.component
    let make = (~str) => {
        if !Dictionary.mem(str) {
            <></>
        } else {
            let term = Dictionary.getTerm(str);
            <table className="is-striped">
                <tr>
                    <th>{str->React.string}</th>
                    <th>{"noun: "->React.string}{term.nounDefinition->React.string}</th>
                    <th>{"verb: "->React.string}{term.verbDefinition->React.string}</th>
                    <th>{"ad: "->React.string}{term.adDefinition->React.string}</th>
                </tr>
            </table>
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
                Dictionary.dict
                ->Dictionary.MyDict.bindings
                ->Belt.List.map(((str, term): (Dictionary.MyDict.key, Dictionary.term)) =>
                <tr>
                    <td>{str->React.string}</td>
                    <td>{`${term.nounDefinition} / ${term.verbDefinition} / ${term.adDefinition}`->React.string}</td>
                    <td>{term.description->React.string}</td>
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
                Dictionary.conjDict
                ->Dictionary.MyDict.bindings
                ->Belt.List.map(((str, conjTerm): (Dictionary.MyDict.key, Dictionary.conjTerm)) =>
                <tr>
                    <td>{str->React.string}</td>
                    <td>{conjTerm.definition->React.string}</td>
                    <td>{conjTerm.description->React.string}</td>
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
                ->Lexs.parse
                ->toEl(str => setHint(_ => str), ~isFirstWord=true, ())
            }</div>
        </div>
        <div>
            <Hint str={hint} />
            <Dict />
            <ConjDict />
        </div>
    </div>
    // <p>{"mi i love a you"->Lexs.parse->toEl}</p>
}
