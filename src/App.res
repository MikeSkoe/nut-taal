%%raw("import './app.css'")

open Lang

module Links = {
    let dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";
    let particlesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/particles.csv";
    let examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

    @react.component
    let make = () => <div className="samples">
        <p><a href={dicrionaryURL}>{"Dictionary"->React.string}</a></p>
        <p><a href={particlesURL}>{"Particles"->React.string}</a></p>
        <p><a href={examplesURL}>{"Examples"->React.string}</a></p>
    </div>;
}

module Parser = {
    @react.component
    let make = (~text) => {
        let (parsed, setParsed) = React.useState(_ => []);

        React.useEffect1(() => {
            String.split_on_char('\n', text)
            -> Belt.List.map(Lang.Lexs.parse)
            -> Belt.List.toArray
            -> Js.Promise.all
            -> Js.Promise.then_(arr => 
                arr
                -> Belt.Array.reduce(
                    [],
                    (acc: array<Lang.Lexs.t>, curr) => switch curr {
                        | Some(parsed) => Belt.Array.concat(acc, [parsed])
                        | None => acc
                    }
                )
                -> res => Js.Promise.resolve(setParsed(_ => res))
            , _)
            -> ignore;

            None;
        }, [text]);

        <div className="parsed">
            {parsed
            -> Belt.Array.map(lex => <>{
                lex
                -> Lang.Lexs.show
                -> Belt.List.reduce(list{}, (acc, curr) =>
                    acc == list{}
                        ? list{curr}
                        : list{...acc, {" "->React.string}, curr}
                )
                -> Belt.List.toArray
                -> React.array
            }</>)
            -> Belt.List.fromArray
            -> Belt.List.reduce(list{}, (acc, curr) =>
                acc == list{}
                    ? list{curr}
                    : list{...acc, <br />, curr}
            )
            -> Belt.List.toArray
            -> React.array
            }
        </div>
    }
}

module Hint = {
    @react.component
    let make = (~hint) => {
        <div className="box hint">
            {hint
            ->Belt.Option.map((({ str, noun, verb, ad, description }): AbstractDict.term) =>
                <>
                    <h3>{str->React.string}</h3>
                    {`noun: ${noun}`->React.string}
                    <br/>
                    <span className="verb">{`verb: ${verb}`->React.string}</span>
                    <br/>
                    <span className="ad">{`ad: ${ad}`->React.string}</span>
                    <br/>
                    {`description: ${description}`->React.string}
                </>
            )
            ->Belt.Option.getWithDefault(<></>)}
            <Links />
        </div>
    }
}

module InputPage = {
    @react.component
    let make = () => {
        let (query, setQuery) = React.useState(_ => "my");
        let divRef = React.useRef(Js.Nullable.null);
        let (hint, setHint) = React.useState(_ => None);
        let (isEditMode, setIsEditMode) = React.useState(_ => true);
        let (input, setInput) = React.useState(_ => "");
        let onChange = event => {
            let target = (event->ReactEvent.Form.target)
            let innerText: string = target["innerText"];
            let innerHtml: string = target["innerHTML"];
            setInput(_ => innerText);
            if innerHtml->Js.String2.includes("<p") {
                Js.log(innerText);
                Js.log(innerHtml);
                target["innerText"] = innerText
            }
        }

        React.useEffect1(() => {
            Lang.Roots.translate(query)
            |> Js.Promise.then_(term => Js.Promise.resolve(
                term -> Belt.Option.forEach(term => switch term {
                    | Lang.Roots.Root(term, _) => setHint(_ => Some(term))
                    | _ => ()
                })
            ))
            |> ignore;
            None;
        }, [query])

        <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
            <div className="box area">
                <Parser text={input} />
                <div
                    ref={ReactDOM.Ref.domRef(divRef)}
                    className={isEditMode ? "editable" : "nonEditable"}
                    spellCheck={false}
                    contentEditable={true}
                    onInput={onChange}
                    inputMode="text"
                />
            </div>
            <input onClick={_ => setIsEditMode(is => !is)} type_="checkbox" className="switch" />
            {isEditMode ? React.null : <Hint hint={hint} />}
        </DictionaryContext.OnWordClickProvider>
    }
}

@react.component
let make = () => {
    <>
        <h1><b>{"taal"->React.string}</b></h1>
        <InputPage />
    </>
}
