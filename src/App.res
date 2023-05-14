%%raw("import './app.css'")

open Lang
open Belt

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
    let make = (~text: string, ~marks) => {
        let (parsed, setParsed) = React.useState(_ => Lang.Start(Lang.End));

        React.useEffect2(() => {
            Lang.parse(marks, text)
            -> res => setParsed(_ => res)
            -> _ => None;
        }, (text, marks));

        <div className="parsed">
            {Lang.show(parsed)
            -> List.reduce(list{}, (acc, curr) =>
                acc == list{}
                    ? list{curr}
                    : list{...acc, {" "->React.string}, curr}
            )
            -> List.toArray
            -> React.array
            }
        </div>
    }
}

module Hint = {
    @react.component
    let make = (~word, ~translations) => {
        <div className="box hint">
            <h3>{word->React.string}</h3>
            {translations
            -> Belt.List.map(str => <>
                <span className="verb">{str->React.string}</span>
                <br/>
            </>)
            -> Belt.List.toArray
            -> React.array }
            <Links />
        </div>
    }
}

module InputPage = {
    @react.component
    let make = (~marks) => {
        let (isEditMode, setIsEditMode) = React.useState(_ => true);
        let (input, setInput) = React.useState(_ => "");
        let onChange = event => setInput(_ => ReactEvent.Form.target(event)["innerText"]);

        <>
            <div className="box area">
                <Parser text={input} marks={marks} />
                <div
                    className={isEditMode ? "editable" : "nonEditable"}
                    spellCheck={false}
                    contentEditable={true}
                    onInput={onChange}
                    inputMode="text"
                />
            </div>
            <input onClick={_ => setIsEditMode(is => !is)} type_="checkbox" className="switch" />
        </>
    }
}

@react.component
let make = () => {
    let (termDict, setTermDict) = React.useState(_ => None)
    let (marksDict, setMarksDict) = React.useState(_ => None)
    let (query, setQuery) = React.useState(_ => "my");
    let (hint, setHint) = React.useState(_ => None);

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

    React.useEffect2(() => {
        termDict -> Option.forEach(dict =>
        query -> Lang.translate(dict) -> Option.forEach(translations =>
            setHint(_ => Some((query, translations))))
        )
        -> _ => None;
    }, (query, termDict));

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
        <h1><b>{"taal"->React.string}</b></h1>
        {
            marksDict
            -> Option.map(marks => <InputPage marks={marks} />)
            -> Option.getWithDefault(React.null)
        }
        {
            hint
            -> Option.map(((word, translations)) => <Hint word={word} translations={translations->List.tailExn} />)
            -> Option.getWithDefault(React.null)
        }
    </DictionaryContext.OnWordClickProvider>
}
