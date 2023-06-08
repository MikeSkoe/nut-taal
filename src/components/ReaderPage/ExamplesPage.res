open Belt
open Lang

@react.component
let make = (~conjunctionDict: option<Lang.dictionary>) => {
    let (text, setText) = React.useState(() => list{("My leif jy", "I love you")})

    React.useEffect0(() => {
        let fetch = async () => {
            let text = await Utils.loadFile("sentences");
            let words = Utils.parseExamples(text);
            setText(_ => words);
        }

        fetch() -> ignore;
        None;
    });


    conjunctionDict
    -> Option.mapWithDefault(
        React.null,
        conjunctions => <Examples textWithTranslation={text} conjunctions />
    )
}