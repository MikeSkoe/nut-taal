open Belt
open Lang

@react.component
let make = (~conjunctionDict: option<Lang.dictionary>) => {
    conjunctionDict
    -> Option.mapWithDefault(
        React.null,
        conjunctions => <Reader textWithTranslation={Sample.fiets} conjunctions />
    )
}