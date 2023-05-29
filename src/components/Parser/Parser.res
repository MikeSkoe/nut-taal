open Lang
open Belt

@react.component
let make = (~text: string, ~conjunctions) => {
    let (parsed, setParsed) = React.useState(_ => list{Lang.empty});

    React.useEffect2(() => {
        text
        -> String.split_on_char('.', _)
        -> List.map(line => Lang.parse(conjunctions, line))
        -> res => setParsed(_ => res)
        -> _ => None;
    }, (text, conjunctions));

    <div className="parsed">{
        parsed
        -> List.map(line => line -> Lang.show -> Utils.putBetween(" " -> React.string))
        -> Utils.putBetween(list{". " -> React.string})
        -> List.flatten
        -> List.toArray
        -> React.array
    }</div>
}
