type t = React.element;

module Tooltip = {
    @react.component
    let make = (~hint) =>
        <span className="tooltip">
            {hint->React.string}
        </span>
}

let wrapNoun = (noun, def): t =>
    <span className="noun">
        <span>{` ${noun}`->React.string}</span>
        <Tooltip hint={def} />
        // <Tooltip hint={noun->Lang.Roots.fold(Dictionary.Term.getNounDef, "uknown")} />
    </span>

let wrapVerb = (verb, def) =>
    <span className="verb">
        <span>{` ${verb}`->React.string}</span>
        <Tooltip hint={def} />
        // <Tooltip hint={noun->Lang.Roots.fold(Dictionary.Term.getVerbDef, "uknown")} />
    </span>

let wrapAd = (ad, def) =>
    <span className="ad">
        <span>{` ${ad}`->React.string}</span>
        <Tooltip hint={def} />
        // <Tooltip hint={ad->Lang.Roots.fold(Dictionary.Term.getAdDef, "uknown")} />
    </span>

let wrapConj = (conj, def) =>
    <span className="conj">
        <span>{` ${conj}`->React.string}</span>
        <Tooltip hint={def} />
        // <Tooltip hint={conj->Lang.Roots.fold(Dictionary.Conj.getDef, "uknown")} />
    </span>

let wrapPunctuation = str => <span>{str->React.string}</span>

let wrapMark = mark => <span>{` ${mark}`->React.string}</span>
