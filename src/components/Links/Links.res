let readerURL = "#reader";
let readmeURL = "https://github.com/MikeSkoe/nut-taal/blob/main/README.md";
let dicrionaryURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv";
let conjunctionsURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/conjunctions.csv";
let examplesURL = "https://github.com/MikeSkoe/nut-taal/blob/main/public/examples.csv";

@react.component
let make = () => <div className="links">
    <a href={"#"}>{"Main"->React.string}</a>
    <a href={readerURL}>{"Reader"->React.string}</a>
    <a href={readmeURL}>{"README (with grammar)"->React.string}</a>
    <a href={dicrionaryURL}>{"Dictionary"->React.string}</a>
    <a href={conjunctionsURL}>{"conjunctions"->React.string}</a>
    <a href={examplesURL}>{"Examples"->React.string}</a>
</div>;
