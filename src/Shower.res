type t = React.element;

module Word = {
    @react.component
    let make = (~className, ~word) => {
        let onClick = React.useContext(DictionaryContext.onWordClickContext); 

        <span className onClick={_ => onClick(word)}>
            {word->React.string}
        </span>
    }
}

let noun : string => t
    = word => <Word className="noun" word />

let verb : string => t
    = word => <Word className="verb" word />

let ad : string => t
    = word => <Word className="ad" word />

let con: string => t
    = word => <span className="conj">{word->React.string}</span>

let mark: string => t
    = mark => <span>{mark->React.string}</span>
