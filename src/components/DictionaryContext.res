open AbstractDict;

let termsContext: React.Context.t<list<term>> = React.createContext(list{});
let conjsContext: React.Context.t<list<conjTerm>> = React.createContext(list{}); 

module TermProvider = {
    let make = React.Context.provider(termsContext);
}

module ConjProvider = {
    let make = React.Context.provider(conjsContext);
}

@react.component
let make = (~children) => {
    let (terms, setTerms) = React.useState(_ => list{})
    let (conjs, setConjs) = React.useState(_ => list{})

    React.useEffect0(() => {
        Dictionary.Conj.all
        |> Js.Promise.then_ (conjs => setConjs(_ => conjs)->Js.Promise.resolve)
        |> ignore;
        None;
    })

    React.useEffect0(() => {
        Dictionary.Term.all
        |> Js.Promise.then_ (terms => setTerms(_ => terms)->Js.Promise.resolve)
        |> ignore;
        None;
    })

    <TermProvider value={terms}>
        <ConjProvider value={conjs}>
            {children}
        </ConjProvider>
    </TermProvider>
}