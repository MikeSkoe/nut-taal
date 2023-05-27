%%raw("import './app.css'")

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

module MainPage = {
    @react.component
    let make = (~marksDict: option<Lang.dictionary>) => {
        marksDict
        -> Option.map(marks => <Input marks />)
        -> Option.getWithDefault(React.null)
    }
}

@react.component
let make = () => {
    let (termDict, marksDict) = useDictionary();
    let (query, setQuery) = React.useState(_ => "taal");
    let hint = useHint(termDict, marksDict, query);
    let url = RescriptReactRouter.useUrl();

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
        <Header />
        {
            switch url.hash {
                | "reader" => <ReaderPage marksDict />
                | _ => <MainPage marksDict />
            }
        }
        {
            hint
            -> Option.map(((word, translations)) => {
                switch url.hash {
                    | "reader" => <Hint word translations fixed=true/>
                    | _ => <Hint word translations fixed=false/>
                }
            })
            -> Option.getWithDefault(React.null)
        }
        <div className="floor" />
    </DictionaryContext.OnWordClickProvider>
}
