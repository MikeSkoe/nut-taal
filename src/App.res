%%raw("import './app.css'")

open Lang
open Belt

let useDictionary = () => {
    let (termDict, setTermDict) = React.useState(_ => None);
    let (conjunctionDict, setConjunctionDict) = React.useState(_ => None);

    React.useEffect0(() => {
        Js.Promise.all2((
            Dictionary.Loader.loadDict(Dictionary.Loader.dictUrl),
            Dictionary.Loader.loadDict(Dictionary.Loader.conjunctionsUrl),
        ))
        -> Js.Promise.then_(((terms, conjunctions)) => Js.Promise.resolve({
            setTermDict(_ => Some(terms))
            setConjunctionDict(_ => Some(conjunctions))
        }), _)
        -> _ => None;
    });

    (termDict, conjunctionDict);
}

let useHint = (termDict, conjunctionDict, query) => {
    let (hint, setHint) = React.useState(_ => None);

    React.useEffect3(() => {
        termDict -> Option.flatMap(terms =>
        conjunctionDict -> Option.flatMap(conjunction => 
            Lang.translate(query, conjunction)
            -> Option.orElse(Lang.translate(query, terms))
            -> Option.forEach(translations => setHint(_ => Some((
                translations -> List.headExn,
                translations -> List.tailExn,
            ))))
            -> _ => None
        ))
        -> _ => None;
    }, (query, termDict, conjunctionDict));

    hint
}

module MainPage = {
    @react.component
    let make = (~conjunctionDict: option<Lang.dictionary>) => {
        conjunctionDict
        -> Option.map(conjunctions => <Input conjunctions />)
        -> Option.getWithDefault(React.null)
    }
}

@react.component
let make = () => {
    let (termDict, conjunctionDict) = useDictionary();
    let (query, setQuery) = React.useState(_ => "taal");
    let hint = useHint(termDict, conjunctionDict, query);
    let url = RescriptReactRouter.useUrl();

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
        <Header />
        {
            switch url.hash {
                | "examples" => <ExamplesPage conjunctionDict />
                | _ => <MainPage conjunctionDict />
            }
        }
        {
            hint
            -> Option.map(((word, translations)) => {
                switch url.hash {
                    | "examples" => <Hint word translations fixed=true/>
                    | _ => <Hint word translations fixed=false/>
                }
            })
            -> Option.getWithDefault(React.null)
        }
        <div className="floor" />
    </DictionaryContext.OnWordClickProvider>
}
