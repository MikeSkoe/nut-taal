%%raw("import './app.css'")

open Lang
open Belt
open Option

let putBetween = (list: list<'a>, item: 'a): list<'a> => {
    list -> List.reduce(list{}, (acc: list<'a>, curr: 'a) =>
        acc == list{}
            ? list{curr}
            : list{...acc, item, curr}
    )
}

module Links = {
    let readmeURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/README.md";
    let dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";
    let conjugationsURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/conjugations.csv";
    let examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

    @react.component
    let make = () => <div className="samples">
        <p><a href={readmeURL}>{"README (with grammar)"->React.string}</a></p>
        <p><a href={dicrionaryURL}>{"Dictionary"->React.string}</a></p>
        <p><a href={conjugationsURL}>{"Conjugations"->React.string}</a></p>
        <p><a href={examplesURL}>{"Examples"->React.string}</a></p>
    </div>;
}

module Parser = {
    @react.component
    let make = (~text: string, ~marks) => {
        let (parsed, setParsed) = React.useState(_ => list{Lang.Start(Lang.End)});

        React.useEffect2(() => {
            text
            -> String.split_on_char('\n', _)
            -> List.map(line => Lang.parse(marks, line))
            -> res => setParsed(_ => res)
            -> _ => None;
        }, (text, marks));

        <div className="parsed">
            {parsed
            -> List.map(line => line -> Lang.show -> putBetween(" " -> React.string))
            -> putBetween(list{<br />})
            -> List.flatten
            -> List.toArray
            -> React.array}
        </div>
    }
}

module Hint = {
    @react.component
    let make = (~word, ~translations) => {
        <div className="box hint">
            <h3>{word->React.string}</h3>

            <i>
                {translations
                -> List.map(str => str->React.string)
                -> putBetween(", "->React.string)
                -> List.toArray
                -> React.array}
            </i>
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
            <input id="isEdit" onClick={_ => setIsEditMode(is => !is)} type_="checkbox" className="switch" />
            <label>{`${(isEditMode ? "Edit" : "View")} mode` -> React.string}</label>
        </>
    }
}

module Legend = {
    @react.component
    let make = () => {
        <div>
            <b>{"Legend: " -> React.string}</b>
            <span className="noun">{"noun " -> React.string}</span>
            <span className="verb">{"verb " -> React.string}</span>
            <span className="ad">{"ad " -> React.string}</span>
            <span className="conj">{"conjuction " -> React.string}</span>
        </div>
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

    React.useEffect3(() => {
        termDict -> flatMap(terms =>
        marksDict -> flatMap(marks => 
            orElse(
                query -> Lang.translate(marks),
                query -> Lang.translate(terms),
            )
            -> forEach(translations => setHint(_ => Some((
                translations -> List.headExn,
                translations -> List.tailExn,
            ))))
            -> _ => None
        ))
        -> _ => None;
    }, (query, termDict, marksDict));

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
            <h1><b>{"nut"->React.string}</b></h1>
            <Legend />
            {
                marksDict
                -> map(marks => <InputPage marks />)
                -> getWithDefault(React.null)
            }
            {
                hint
                -> map(((word, translations)) => <Hint word translations />)
                -> getWithDefault(React.null)
            }
    </DictionaryContext.OnWordClickProvider>
}
