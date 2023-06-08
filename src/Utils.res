open Belt;

let concatWords: list<string> => string
    = words => words -> List.reduce("", (acc, curr) => acc == "" ? curr : `${acc}-${curr}`)

let putBetween: (list<'a>, 'a) => list<'a>
    = (list: list<'a>, item: 'a): list<'a> => {
        list -> List.reduce(list{}, (acc: list<'a>, curr: 'a) =>
            acc == list{}
                ? list{curr}
                : list{...acc, item, curr}
        )
    }

let loadFile: string => promise<string>
    = path => path
        -> Fetch.fetch
        -> Js.Promise.then_(Fetch.Response.text, _)

let parseExamples: string => list<(string, string)>
    = text => text
        -> Js.String.split("\n\n", _)
        -> List.fromArray
        -> List.map(
            str => switch String.split_on_char('\n', str) {
                | list{eng, nut, ..._} => (nut, eng)
                | _ => ("plek-hou", "placeholder")
            }
        );
