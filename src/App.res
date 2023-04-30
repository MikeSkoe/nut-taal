%%raw("import './app.css'")

open Lang

module Links = {
    let dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";
    let particlesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/particles.csv";
    let examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

    @react.component
    let make = () => <>
        <p><a href={dicrionaryURL}>{"Dictionary"->React.string}</a></p>
        <p><a href={particlesURL}>{"Particles"->React.string}</a></p>
        <p><a href={examplesURL}>{"Examples"->React.string}</a></p>
    </>;
}

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
            <Links />
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
    <DictionaryContext>
        <InputPage />
    </DictionaryContext>
}
