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

module Word = {
    @react.component
    let make = (~className, ~data) => {
        let (known, word, def) = data;

        known
            ? <Tooltip hint={def}>
                <span className>
                    {`${word}`->React.string}
                </span>
            </Tooltip>
            : <u>{`${word}`->React.string}</u>
    }
}

let collapse = (elements): list<t> =>
    elements
    ->Belt.List.reduce(list{}, (acc, curr) =>
        acc == list{}
            ? list{curr}
            : list{
                ...acc,
                "-"->React.string,
                curr,
            });

let wrapNoun = (data: list<(bool, string, string)>) =>
    <>
        {collapse(
            data
            ->Belt.List.map(data => <Word className="noun" data />)
        )->Belt.List.toArray->React.array}
    </>

let wrapVerb = (data: list<(bool, string, string)>) =>
    <>
        {collapse(
            data
            ->Belt.List.map(data => <Word className="verb" data />)
        )->Belt.List.toArray->React.array}
    </>

let wrapAd = (data: list<(bool, string, string)>) =>
    <>
        {collapse(
            data
            ->Belt.List.map(data => <Word className="ad" data />)
        )->Belt.List.toArray->React.array}
    </>

let wrapConj = (conj, def) =>
    <span className="conj">
        <Tooltip hint={def}>
            <span>{conj->React.string}</span>
        </Tooltip>
    </span>

let wrapPunctuation = str => <span>{str->React.string}</span>

let wrapMark = mark => <span>{mark->React.string}</span>
