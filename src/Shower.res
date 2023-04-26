type t = React.element;

module Tooltip = {
    @react.component
    let make = (~hint) =>
        <span className="tooltip">
            {hint->React.string}
        </span>
}

let wrapNoun = (tuples): t => {
    let render = (prefix, (noun, def)) => 
        <span className="noun">
            <span>{`${prefix}${noun}`->React.string}</span>
            <Tooltip hint={def} />
        </span>;
    switch tuples {
        | list{(noun, def), ...next} => <>
            {render(" ", (noun, def))}
            {next
            ->Belt.List.map(render("-"))
            ->Belt.List.toArray
            ->React.array}
        </>
        | list{} => <></>
    }
}

let wrapVerb = (tuples): t => {
    let render = (prefix, (verb, def)) => 
        <span className="verb">
            <span>{`${prefix}${verb}`->React.string}</span>
            <Tooltip hint={def} />
        </span>
    switch tuples {
        | list{(verb, def), ...next} => <>
            {render(" ", (verb, def))}
            {next
            ->Belt.List.map(render("-"))
            ->Belt.List.toArray
            ->React.array}
        </>
        | list{} => <></>
    }
}

let wrapAd = (tuples): t => {
    let render = (prefix, (ad, def)) => 
        <span className="ad">
            <span>{`${prefix}${ad}`->React.string}</span>
            <Tooltip hint={def} />
        </span>
    switch tuples {
        | list{(ad, def), ...next} => <>
            {render(" ", (ad, def))}
            {next
            ->Belt.List.map(render("-"))
            ->Belt.List.toArray
            ->React.array}
        </>
        | list{} => <></>
    }
}

let wrapConj = (conj, def) =>
    <span className="conj">
        <span>{` ${conj}`->React.string}</span>
        <Tooltip hint={def} />
    </span>

let wrapPunctuation = str => <span>{str->React.string}</span>

let wrapMark = mark => <span>{` ${mark}`->React.string}</span>
