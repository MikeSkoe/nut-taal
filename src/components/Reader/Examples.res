%%raw("import './examples.css'")

open Belt

type textWithTranslation = list<(string, string)>;

@react.component
let make = (~textWithTranslation: textWithTranslation, ~conjunctions) => {
    textWithTranslation
    -> List.map(((text, translation)) =>
        <div className="reader">
            <Parser text conjunctions />
            <div>{translation->React.string}</div>
        </div>
    )
    -> List.toArray
    -> React.array
}
