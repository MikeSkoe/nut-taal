%%raw("import './app.css'")

open Lang

module Parser = {
    @react.component
    let make = (~text) => {
        let (input, setInput) = React.useState(_ => text);
        let onChange = event => setInput((event->ReactEvent.Form.target)["value"]);

        <>
            <div>
                <Unit.El pars={input->Lang.Lexs.parse} />
            </div>
            <textarea onChange inputMode="text"/>
        </>
    }
}

@react.component
let make = () => {
    let url = RescriptReactRouter.useUrl();

    <DictionaryContext>
        <>
            {switch url.path {
                | list{"text", text} =>
                    <Parser text={text->Js.String2.replaceByRe(%re("/_/g"), " ")} />
                | _ =>
                    <Parser text="" />
            }}

            <div className="flex" direction="column">
                <Table.Conjs />
                <Table.Terms />
            </div>
        </>
    </DictionaryContext>
}
