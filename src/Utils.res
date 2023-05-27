open Belt;

let concatWords: list<string> => string
    = words => words -> List.reduce("", (acc, curr) => acc == "" ? curr : `${acc}-${curr}`)

let putBetween = (list: list<'a>, item: 'a): list<'a> => {
    list -> List.reduce(list{}, (acc: list<'a>, curr: 'a) =>
        acc == list{}
            ? list{curr}
            : list{...acc, item, curr}
    )
}
