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
                {terms
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
                ->React.array}
            </tbody>
        </table>
}
