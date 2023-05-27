open Belt

@react.component
let make = (~word, ~translations) => {
    <div className="box hint">
        <i>{word->React.string}</i>
        <h3>{
            translations
            -> List.keep(str => str != "")
            -> List.map(str => str->React.string)
            -> Utils.putBetween(", "->React.string)
            -> List.toArray
            -> React.array
        }</h3>
        <Legend />
    </div>
}