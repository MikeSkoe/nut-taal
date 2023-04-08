@react.component
let make = () => {
  <h1>{
    "mi i love a you"
    ->Lex.Lex.parse
    ->Lex.Lex.show
    ->React.string
  }</h1>
}
