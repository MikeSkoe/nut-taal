module Dict = {
    @react.component
    let make = (~titles, ~terms, ~getColumns) =>
        <table className="is-striped">
            <thead>
                <tr>
                    {titles
                    ->Belt.List.map(title => <th>{title->React.string}</th>)
                    ->Belt.List.toArray
                    ->React.array}
                </tr>
            </thead>
            <tbody>
                {
                    terms
                    ->Belt.List.map(term =>
                        <tr>
                            {term
                            ->getColumns
                            ->Belt.List.map(column => <td>{column->React.string}</td>)
                            ->Belt.List.toArray
                            ->React.array
                            }
                        </tr>)
                    ->Belt.List.toArray
                    ->React.array
                }
            </tbody>
        </table>
}

module Terms = {
    @react.component
    let make = () => {
        let terms = React.useContext(DictionaryContext.termsContext)

        <Dict
            terms={terms}
            titles={list{"term", "noun", "verb", "ad", "description"}}
            getColumns={term => list{
                term->Dictionary.Term.show,
                term->Dictionary.Term.getNounDef,
                term->Dictionary.Term.getVerbDef,
                term->Dictionary.Term.getAdDef,
                term->Dictionary.Term.getDescription,
            }}
        />
    }
}

module Conjs = {
    @react.component
    let make = () => {
        let conjs = React.useContext(DictionaryContext.conjsContext);

        <Dict
            terms={conjs}
            titles={list{"term", "translation", "description"}}
            getColumns={conj => list{
                conj->Dictionary.Conj.show,
                conj->Dictionary.Conj.getDef,
                conj->Dictionary.Conj.getDescription,
            }}
        />
    }
}
