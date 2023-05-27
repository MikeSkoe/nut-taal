let initialText = "my lief jy want jy is persoon e goed"

@react.component
let make = (~marks) => {
    let ref = React.useRef(Js.Nullable.null);
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
        <div className="area-holder">
            <div className="column">
                <h2 className="area-heading">{"Type here" -> React.string}</h2>
                <div className="box area">
                    <div
                        ref={ReactDOM.Ref.domRef(ref)}
                        onPaste={onPaste}
                        className="editable"
                        spellCheck={false}
                        contentEditable={true}
                        suppressContentEditableWarning={true}
                        onInput={onChange}
                        inputMode="text"
                    >
                        {initialText -> React.string}
                    </div>
                </div>
            </div>
            <div className="column">
                <h2 className="area-heading">{"Preview here" -> React.string}</h2>
                <div className="box area">
                    <Parser text={input} marks={marks} />
                </div>
            </div>
        </div>
    </>
}
