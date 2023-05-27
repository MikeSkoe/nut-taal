@react.component
let make = (~text, ~children, ~pos) => {
    React.cloneElement(
        children,
        { "data-tooltip": text, "tooltip-pos": pos, "tooltip-length": "medium" },
    )
}
