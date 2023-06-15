open Lang
open Belt

let sentenceSplitterRe = %re("/\s*[.!?]\s*/");

@react.component
let make = (~text: string, ~conjunctions) => {
    let (parsed, setParsed) = React.useState(_ => list{Lang.empty});

    React.useEffect2(() => {
        text
        -> Js.String2.splitByRe(sentenceSplitterRe) 
        -> Array.reduce(list{}, (acc, curr) =>
            curr -> Option.mapWithDefault(acc, curr => List.concat(acc, list{curr}))
        )
        -> List.map(line => Lang.parse(conjunctions, line))
        -> res => setParsed(_ => res)
        -> _ => None;
    }, (text, conjunctions));

    <div className="parsed">{
        parsed
        -> List.map(line => line -> Lang.show -> Utils.putBetween(React.string(" ")))
        -> Utils.putBetween(list{<br />})
        -> List.flatten
        -> List.toArray
        -> React.array
    }</div>
}
