type term = {
      str: string;
      nounDefinition: string;
      verbDefinition: string;
      adDefinition: string;
      description: string;
}

type item =
      | Me | You | It
      | Have | Love | Book
      | Good

module MyDict = Map.Make(struct
      type t = item
      let compare = compare
end)

let dict: term MyDict.t = MyDict.empty
      |> MyDict.add Me { str="ek"; nounDefinition="me"; verbDefinition="TODO"; adDefinition="my"; description="Afrikaans: ek" }
      |> MyDict.add You { str="jy"; nounDefinition="you"; verbDefinition="TODO"; adDefinition="your"; description="Afrikaans: jy" }
      |> MyDict.add It { str="sy"; nounDefinition="he/she/it"; verbDefinition="TODO"; adDefinition="his/her/its"; description="Afrikaans: sy" }
      |> MyDict.add Have { str="het"; nounDefinition="have"; verbDefinition="to have"; adDefinition="owning/having"; description="Afrikaans: het" }
      |> MyDict.add Love { str="lief"; nounDefinition="love"; verbDefinition="to love"; adDefinition="lovely"; description="Afrikaans: lief" }
      |> MyDict.add Book { str="boek"; nounDefinition="book"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans: boek" }
      |> MyDict.add Good { str="goed"; nounDefinition="good"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans: goed" }

let toStrOpt (key: item): string option =
      Belt.Option.map
            MyDict.(find_opt key dict)
            (fun value -> value.str)

let getStr (key: item): string = MyDict.(find key dict).str

let getTerm (key: item): term = MyDict.find key dict

let fromStr (str: string): item option = 
      let findFn key value res = match res with
            | Some(res) -> Some(res)
            | None ->
                  if str = value.str
                  then (Some key)
                  else None 
      in
      MyDict.fold findFn dict None

