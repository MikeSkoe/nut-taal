let readerURL = "reader";
let readmeURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/README.md";
let dicrionaryURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/dictionary.csv";
let conjugationsURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/conjugations.csv";
let examplesURL = "https://github.com/MikeSkoe/code-ish-app/blob/main/public/examples.csv";

@react.component
let make = () => <div className="samples">
    <a href={readerURL}>{"Reader"->React.string}</a>
    <a href={readmeURL}>{"README (with grammar)"->React.string}</a>
    <a href={dicrionaryURL}>{"Dictionary"->React.string}</a>
    <a href={conjugationsURL}>{"Conjugations"->React.string}</a>
    <a href={examplesURL}>{"Examples"->React.string}</a>
</div>;
