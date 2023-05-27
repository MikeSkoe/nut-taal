let initialText = "my lief jy want jy is persoon e goed"

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
