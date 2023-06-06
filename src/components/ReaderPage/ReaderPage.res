open Belt
open Lang

@react.component
let make = (~conjunctionDict: option<Lang.dictionary>) => {
    let (text, setText) = React.useState(() => list{("My leif jy", "I love you")})

    React.useEffect0(() => {
        let fetch = async () => {
            let fetched = await Fetch.fetch("sentences3");
            let text = await Fetch.Response.text(fetched);
            let words: list<(string, string)> = 
                Js.String.split("\n\n", text)
                -> List.fromArray
                -> List.map(
                    str => switch String.split_on_char('\n', str) {
                        | list{eng, nut, ..._} => (nut, eng)
                        | _ => ("plek-hou", "placeholder")
                    }
                );
            setText(_ => words);
        }

        fetch() -> ignore;
        None;
    });


    conjunctionDict
    -> Option.mapWithDefault(
        React.null,
        conjunctions => <Reader textWithTranslation={text} conjunctions />
    )
}