type t = React.element;

module Tooltip = {
    @react.component
    let make = (~children, ~hint: string) => <>
        {React.cloneElement(
            children,
            { "data-tooltip": hint, "tooltip-pos": "up"},
        )}
    </>
}

let render = (className, prefix, (known, word, def)) => {
    let onClick = React.useContext(DictionaryContext.onWordClickContext);

    <span className>
        {known
            ? <Tooltip hint={def}>
                <span onClick={_ => onClick(word)}>{`${prefix}${word}`->React.string}</span>
            </Tooltip>
            : <u>{`${prefix}${word}`->React.string}</u>
        }
    </span>;
}

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
        <Tooltip hint={def}>
            <span>{` ${conj}`->React.string}</span>
        </Tooltip>
    </span>

let wrapPunctuation = str => <span>{str->React.string}</span>

let wrapMark = mark => <span>{` ${mark}`->React.string}</span>
