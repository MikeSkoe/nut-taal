%%raw("import './reader.css'")

open Belt

type textWithTranslation = list<(string, string)>;

@react.component
let make = (~textWithTranslation: textWithTranslation, ~marks) => {
    textWithTranslation
    -> List.map(((text, translation)) =>
        <div className="reader">
            <Parser text marks />
            <div>{translation->React.string}</div>
        </div>
    )
    -> List.toArray
    -> React.array
}
