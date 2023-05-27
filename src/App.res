%%raw("import './app.css'")

let languageName = "nut-taal";

open Lang
open Belt

let useDictionary = () => {
    let (termDict, setTermDict) = React.useState(_ => None);
    let (marksDict, setMarksDict) = React.useState(_ => None);

    React.useEffect0(() => {
        Js.Promise.all2((
            Dictionary.Loader.loadDict(Dictionary.Loader.dictUrl),
            Dictionary.Loader.loadDict(Dictionary.Loader.marksUrl),
        ))
        -> Js.Promise.then_(((terms, marks)) => Js.Promise.resolve({
            setTermDict(_ => Some(terms))
            setMarksDict(_ => Some(marks))
        }), _)
        -> _ => None;
    });

    (termDict, marksDict);
}

let useHint = (termDict, marksDict, query) => {
    let (hint, setHint) = React.useState(_ => None);

    React.useEffect3(() => {
        termDict -> Option.flatMap(terms =>
        marksDict -> Option.flatMap(marks => 
            Lang.translate(query, marks)
            -> Option.orElse(Lang.translate(query, terms))
            -> Option.forEach(translations => setHint(_ => Some((
                translations -> List.headExn,
                translations -> List.tailExn,
            ))))
            -> _ => None
        ))
        -> _ => None;
    }, (query, termDict, marksDict));

    hint
}

@react.component
let make = () => {
    let (query, setQuery) = React.useState(_ => "taal");
    let (termDict, marksDict) = useDictionary();
    let hint = useHint(termDict, marksDict, query);

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
            <h1><b>{languageName->React.string}</b></h1>
            {
                marksDict
                -> Option.map(marks => <Input marks />)
                -> Option.getWithDefault(React.null)
            }
            {
                hint
                -> Option.map(((word, translations)) => <Hint word translations />)
                -> Option.getWithDefault(React.null)
            }
            <Links />
    </DictionaryContext.OnWordClickProvider>
}
