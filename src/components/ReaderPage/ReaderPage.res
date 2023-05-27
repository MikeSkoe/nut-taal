open Belt
open Lang

@react.component
let make = (~marksDict: option<Lang.dictionary>) => {
    marksDict
    -> Option.mapWithDefault(
        React.null,
        marks => <Reader textWithTranslation={Sample.fiets} marks />
    )
}