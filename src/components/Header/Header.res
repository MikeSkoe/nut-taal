%%raw("import './header.css'")

let languageName = "nut-taal";

@react.component
let make = () => <h1>
    <img className="logo" src="/nut-taal-logo.png" />
    <b>{languageName->React.string}</b>
</h1>
