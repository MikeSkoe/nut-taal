@react.component
let make = () => {
    <div className="legend">
        <Tooltip text="Work markers, like: a i e, have this colour" pos="down-left">
            <i className="mark">{"mark " -> React.string}</i>
        </Tooltip>
        <Tooltip text="Nouns have this colour" pos="down">
            <i className="noun">{"noun " -> React.string}</i>
        </Tooltip>
        <Tooltip text="Verbs have this colour" pos="down">
            <i className="verb">{"verb " -> React.string}</i>
        </Tooltip>
        <Tooltip text="Adjectives and adverbs have this colour" pos="down">
            <i className="ad">{"ad " -> React.string}</i>
        </Tooltip>
        <Tooltip text={`Words that mean "and", "but", "because", etc., that introduce a clause, have this colour`} pos="down-right">
            <i className="conj">{"conjuction " -> React.string}</i>
        </Tooltip>
    </div>
}
