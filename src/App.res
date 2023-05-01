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

module Hint = {
    @react.component
    let make = (~hint) => {
        <div>
            {hint
            ->Belt.Option.map((({ str, noun, verb, ad, description }): AbstractDict.term) =>
                <>
                    <p><b>{"term: "->React.string}</b>{str->React.string}</p>
                    {noun != ""
                        ? <p><b>{"noun: "->React.string}</b>{noun->React.string}</p>
                        : React.null
                    }
                    {verb != ""
                        ? <p><b>{"verb: "->React.string}</b>{verb->React.string}</p>
                        : React.null
                    }
                    {ad != ""
                        ? <p><b>{"ad: "->React.string}</b>{ad->React.string}</p>
                        : React.null
                    }
                    {description != ""
                        ?  <p><b>{"description: "->React.string}</b>{description->React.string}</p>
                        : React.null
                    }
                </>
            )
            ->Belt.Option.getWithDefault(<></>)}
        </div>
    }
}

module InputPage = {
    @react.component
    let make = () => {
        let (query, setQuery) = React.useState(_ => "");
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
            <Hint hint={hint} />
        </DictionaryContext.OnWordClickProvider>
    }
}

@react.component
let make = () => {
    <DictionaryContext>
        <InputPage />
    </DictionaryContext>
}
