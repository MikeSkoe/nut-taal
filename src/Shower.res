type t = React.element;

module Tooltip = {
    @react.component
    let make = (~hint) =>
        <span className="tooltip">
            {hint->React.string}
        </span>
}

let render = (className, prefix, (known, word, def)) => 
    <span className>
        {known
            ? <>
                <span>{`${prefix}${word}`->React.string}</span>
                <Tooltip hint={def} />
            </>
            : <u>{`${prefix}${word}`->React.string}</u>
        }
    </span>;
let unit = (render, tuples): t => switch tuples {
    | list{data, ...next} => <>
        {render(" ", data)}
        {next
        ->Belt.List.map(render("-"))
        ->Belt.List.toArray
        ->React.array}
    </>
    | list{} => <></>
}

let wrapNoun = unit(render("noun"));
let wrapVerb = unit(render("verb"));
let wrapAd = unit(render("ad"))

let wrapConj = (conj, def) =>
    <span className="conj">
        <span>{` ${conj}`->React.string}</span>
        <Tooltip hint={def} />
    </span>

let wrapPunctuation = str => <span>{str->React.string}</span>

let wrapMark = mark => <span>{` ${mark}`->React.string}</span>
