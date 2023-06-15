open Belt;

type t = React.element;

module Word = {
    let normalizeWord: string => string
        = word =>
            word
            |> String.map(char =>
                list{'.', ',', '!', '?'}
                -> List.has(char, (a, b) => a == b)
                    ? ' '
                    : char,
                _
            )
            |> String.trim
            |> Utils.mapFirstChar(Js.String.toLowerCase) // Only the first letter is lowercased because môre is mOre in the dictionary

    let rec iter = (~onClick, ~className, ~word, ~withDash) => {
        switch String.split_on_char('-', word) {
            | list{root, ...next} => <>
                {(withDash ? "-" : "") -> React.string}
                <span className onClick={_ => onClick(word->normalizeWord)}>
                    {root->React.string}
                </span>
                {next == list{}
                    ? React.null
                    : iter(
                        ~onClick,
                        ~className,
                        ~word=next->Utils.concatWords,
                        ~withDash=true,
                    )}
            </>
            | list{} => React.null
        }
    }

    @react.component
    let make = (~className, ~word, ~withDash) => {
        let onClick = React.useContext(DictionaryContext.onWordClickContext); 

        iter(~onClick, ~className, ~word, ~withDash)
    }
}

let noun : string => t
    = word => <Word className="noun" word withDash=false />

let verb : string => t
    = word => <Word className="verb" word withDash=false />

let ad : string => t
    = word => <Word className="ad" word withDash=false />

let con: string => t
    = word => <Word className="conj" word withDash=false />

let mark: string => t
    = mark => <span className="mark">{mark->React.string}</span>
