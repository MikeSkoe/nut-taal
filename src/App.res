%%raw("import './app.css'")

open Lang

module Parser = {
    @react.component
    let make = () => {
        let (input, setInput) = React.useState(_ => "");
        let onChange = event => setInput((event->ReactEvent.Form.target)["value"]);

        <>
            <div>
                {String.split_on_char('.', input)
                ->Belt.List.map(string => <>{
                    string
                    ->Lang.Lexs.parse
                    ->Lang.Lexs.show
                    ->Belt.List.reduce(list{}, (acc, curr) =>
                        acc == list{}
                            ? list{curr}
                            : list{
                                ...acc,
                                {" "->React.string},
                                curr,
                            }
                    )
                    ->Belt.List.toArray
                    ->React.array
                }
                </>)
                ->Belt.List.toArray
                ->React.array
                }
            </div>
            <textarea onChange inputMode="text"/>
        </>
    }
}

module VocabPage = {
    @react.component
    let make = () => {
        let conjs = React.useContext(DictionaryContext.conjsContext);
        let terms = React.useContext(DictionaryContext.termsContext)
        let (query, setQuery) = React.useState(_ => "");
        let onChange = event => setQuery((event->ReactEvent.Form.target)["value"]);

        <div className="flex" direction="column">
            <a href="/">{"parse text"->React.string}</a>
            <input onChange inputMode="text"/>
            <Table.Dict
                terms={conjs->Belt.List.keep(conjTerm => conjTerm.str->Js.String2.includes(query))}
                titles={list{"term", "translation", "description"}}
                getColumns={conj => list{
                    conj.str,
                    conj.definition,
                    conj.description,
                }}
            />
            <Table.Dict
                terms={terms->Belt.List.keep(conjTerm => conjTerm.str->Js.String2.includes(query))}
                titles={list{"term", "noun", "verb", "ad", "description"}}
                getColumns={term => list{
                    term.str,
                    term.noun,
                    term.verb,
                    term.ad,
                    term.description,
                }}
            />
        </div>
        
    }
}

module InputPage = {
    @react.component
    let make = () => {
        let (query, setQuery) = React.useState(_ => "begin");
        let (hint, setHint) = React.useState(_ => None);

        React.useEffect1(() => {
            Dictionary.Term.all
            |>Js.Promise.then_((all: list<AbstractDict.term>) =>
                setHint(
                    _ => all->Belt.List.getBy(term => term.str == query)
                )
                ->Js.Promise.resolve
            )
            |>ignore;
            None;
        }, [query])

        <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
            <Parser />
            <a href="/vocab">{"see vocab"->React.string}</a>
            {hint
            ->Belt.Option.map((term: AbstractDict.term) => 
                <Table.Dict
                    terms={list{term}}
                    titles={list{"term", "noun", "verb", "ad", "description"}}
                    getColumns={term => list{
                        term.str,
                        term.noun,
                        term.verb,
                        term.ad,
                        term.description,
                    }}
                />)
            ->Belt.Option.getWithDefault(<></>)}
        </DictionaryContext.OnWordClickProvider>
    }
}

@react.component
let make = () => {
    let url = RescriptReactRouter.useUrl();

    <DictionaryContext>
        <>
            {switch url.path {
                | list{"vocab"} => <VocabPage />
                | _ => <InputPage />
            }}
        </>
    </DictionaryContext>
}
