open Belt;

let concatWords: list<string> => string
    = words => words -> List.reduce("", (acc, curr) => acc == "" ? curr : `${acc}-${curr}`)
