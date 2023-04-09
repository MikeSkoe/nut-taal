type term = {
      nounDefinition: string;
      verbDefinition: string;
      adDefinition: string;
      description: string;
}

type conjTerm = {
      definition: string;
      description: string;
}

module MyDict = Map.Make(String)

let conjDict: conjTerm MyDict.t = MyDict.empty
      |> MyDict.add "en" { definition="and"; description="Afrikaans: en" }
      |> MyDict.add "of" { definition="or"; description="Afrikaans: of" }
      |> MyDict.add "vant" { definition="because"; description="Afrikaans: want" }
      |> MyDict.add "sodat" { definition="so that"; description="Afrikaans: sodat" }

let dict: term MyDict.t = MyDict.empty
      |> MyDict.add "ek" { nounDefinition="me"; verbDefinition="TODO"; adDefinition="my"; description="Afrikaans: ek" }
      |> MyDict.add "jy" { nounDefinition="you"; verbDefinition="TODO"; adDefinition="your"; description="Afrikaans: jy" }
      |> MyDict.add "het" { nounDefinition="have"; verbDefinition="to have"; adDefinition="owning/having"; description="Afrikaans: het" }
      |> MyDict.add "lief" { nounDefinition="love"; verbDefinition="to love"; adDefinition="lovely"; description="Afrikaans: lief" }
      |> MyDict.add "buk" { nounDefinition="book"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans: boek" }
      |> MyDict.add "gud" { nounDefinition="good"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans: goed" }

let mem (key: string): bool = Belt.Option.isSome MyDict.(find_opt key dict)
let conjMem (key: string): bool = Belt.Option.isSome MyDict.(find_opt key conjDict)
let getTerm (key: string): term = MyDict.find key dict
let getConjTerm (key: string): conjTerm = MyDict.find key conjDict
