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
        <a href={readmeURL}>{"README (with grammar)"->React.string}</a>
        <a href={dicrionaryURL}>{"Dictionary"->React.string}</a>
        <a href={conjugationsURL}>{"Conjugations"->React.string}</a>
        <a href={examplesURL}>{"Examples"->React.string}</a>
    </div>;
}

module Parser = {
    @react.component
    let make = (~text: string, ~marks) => {
        let (parsed, setParsed) = React.useState(_ => list{Lang.Start(Lang.End)});

        React.useEffect2(() => {
            text
            -> String.split_on_char('.', _)
            -> List.map(line => Lang.parse(marks, line))
            -> res => setParsed(_ => res)
            -> _ => None;
        }, (text, marks));

        <div className="parsed">{
            parsed
            -> List.map(line => line -> Lang.show -> putBetween(" " -> React.string))
            -> putBetween(list{". " -> React.string})
            -> List.flatten
            -> List.toArray
            -> React.array
        }</div>
    }
}

module WithTooltip = {
    @react.component
    let make = (~text, ~children, ~pos) => {
        React.cloneElement(
            children,
            { "data-tooltip": text, "tooltip-pos": pos, "tooltip-length": "medium" },
        )
    }
}

module Legend = {
    @react.component
    let make = () => {
        <div className="legend">
            <WithTooltip text="Work markers, like: a i e, have this colour" pos="down-left">
                <i className="mark">{"mark " -> React.string}</i>
            </WithTooltip>
            <WithTooltip text="Nouns have this colour" pos="down">
                <i className="noun">{"noun " -> React.string}</i>
            </WithTooltip>
            <WithTooltip text="Verbs have this colour" pos="down">
                <i className="verb">{"verb " -> React.string}</i>
            </WithTooltip>
            <WithTooltip text="Adjectives and adverbs have this colour" pos="down">
                <i className="ad">{"ad " -> React.string}</i>
            </WithTooltip>
            <WithTooltip text={`Words that mean "and", "but", "because", etc., that introduce a clause, have this colour`} pos="down-right">
                <i className="conj">{"conjuction " -> React.string}</i>
            </WithTooltip>
        </div>
    }
}

module Hint = {
    @react.component
    let make = (~word, ~translations) => {
        <div className="box hint">
            <i>{word->React.string}</i>
            <h3>{
                translations
                -> List.keep(str => str != "")
                -> List.map(str => str->React.string)
                -> putBetween(", "->React.string)
                -> List.toArray
                -> React.array
            }</h3>
            <Legend />
        </div>
    }
}

module InputPage = {
    let initialText = "my lief jy"

    @react.component
    let make = (~marks) => {
        let ref = React.useRef(Js.Nullable.null);
        let (isEditMode, setIsEditMode) = React.useState(_ => true);
        let (input, setInput) = React.useState(_ => initialText);
        let onChange = event => setInput(_ => ReactEvent.Form.target(event)["innerText"]);
        let onPaste = %raw(`event => {
            event.preventDefault();
            const text = event.clipboardData.getData("text");
            event.target.innerText = text;
            setInput(text);
            if (ref.current) {
                ref.current.innerText = text;
            }
        }`);

        <>
            <div className="box area">
                <Parser text={input} marks={marks} />
                <div
                    ref={ReactDOM.Ref.domRef(ref)}
                    onPaste={onPaste}
                    className={isEditMode ? "editable" : "nonEditable"}
                    spellCheck={false}
                    contentEditable={true}
                    onInput={onChange}
                    inputMode="text"
                >
                    {initialText -> React.string}
                </div>
            </div>
            <input id="isEdit" onClick={_ => setIsEditMode(is => !is)} type_="checkbox" className="switch" />
            <label>{`${(isEditMode ? "Edit" : "View")} mode` -> React.string}</label>
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

    React.useEffect3(() => {
        termDict -> flatMap(terms =>
        marksDict -> flatMap(marks => 
            Lang.translate(query , marks)
            -> orElse(Lang.translate(query, terms))
            -> forEach(translations => setHint(_ => Some((
                translations -> List.headExn,
                translations -> List.tailExn,
            ))))
            -> _ => None
        ))
        -> _ => None;
    }, (query, termDict, marksDict));

    <DictionaryContext.OnWordClickProvider value={str => setQuery(_ => str)}>
            <h1><b>{"nut-taal"->React.string}</b></h1>
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
            <Links />
    </DictionaryContext.OnWordClickProvider>
}
