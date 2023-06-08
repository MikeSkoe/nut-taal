%%raw("import './header.css'")

let languageName = "nut-taal";

@react.component
let make = () => <h1>
    <a
        href={"#"}
        style={ReactDOMStyle.make(
            ~color="inherit",
            ~textDecoration="inherit",
            (),
        )}
    >
        <img className="logo" src="nut-taal-logo.png" />
        <b>{languageName->React.string}</b>
    </a>
</h1>
