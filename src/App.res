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

let nounEl = (root, onClick) =>
    <span className="noun">
        {Lexs.nounMark->React.string}
        {" "->React.string}
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

let rec toEl = (pars, onClick) => switch pars {
    | End => <></>
    | Noun(root, next) => <>
        {nounEl(root, onClick)}
        {toEl(next, onClick)}
    </>
    | Verb(root, next) => <>
        {verbEl(root, onClick)}
        {toEl(next, onClick)}
    </>
    | Ad(root, next) => <>
        {adEl(root, onClick)}
        {toEl(next, onClick)}
    </>
    | Con(root, next) =>
        <>
            <b>
                {(Conjs.show(root)++" ")->React.string}
            </b>
            {toEl(next, onClick)}
        </>
}

module Hint = {
    @react.component
    let make = (~str) => {
        switch Dictionary.fromStr(str)->Belt.Option.map(Dictionary.getTerm) {
            | Some(item) => <div className="hint">
                <p>{item.str->React.string}</p>
                <p>{"noun: "->React.string}{item.nounDefinition->React.string}</p>
                <p>{"verb: "->React.string}{item.verbDefinition->React.string}</p>
                <p>{"ad: "->React.string}{item.adDefinition->React.string}</p>
            </div>
            | None => <></>
        }
    }
}

@react.component
let make = () => {
    let (hint, setHint) = React.useState(_ => "");
    let (input, setInput) = React.useState(_ => "");
    let onChange = event => setInput((event->ReactEvent.Form.target)["value"])
  
    <div>
        <input onChange={onChange}/>
        <div>{input->Lexs.parse->toEl(str => setHint(_ => str))}</div>
        <Hint str={hint} />
    </div>
    // <p>{"mi i love a you"->Lexs.parse->toEl}</p>
}
