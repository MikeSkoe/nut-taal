module MyDict = Map.Make(String)

module Term: Lang.TERMIN_DICTIONARY = struct
   type t = {
      str: string;
      nounDefinition: string;
      verbDefinition: string;
      adDefinition: string;
      description: string;
   }

   let dict: t MyDict.t = MyDict.empty
      |> MyDict.add "ek" { str="ek"; nounDefinition="me"; verbDefinition="TODO"; adDefinition="my"; description="Afrikaans ek" }
      |> MyDict.add "jy" { str="jy"; nounDefinition="you"; verbDefinition="TODO"; adDefinition="your"; description="Afrikaans jy" }
      |> MyDict.add "het" { str="het"; nounDefinition="have"; verbDefinition="to have"; adDefinition="owning/having"; description="Afrikaans het" }
      |> MyDict.add "lief" { str="lief"; nounDefinition="love"; verbDefinition="to love"; adDefinition="lovely"; description="Afrikaans lief" }
      |> MyDict.add "buk" { str="buk"; nounDefinition="book"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans boek" }
      |> MyDict.add "gud" { str="gud"; nounDefinition="good"; verbDefinition="TODO"; adDefinition="TODO"; description="Afrikaans goed" }

   let all = Belt.List.map (MyDict.bindings dict) (fun (_, term) -> term)

   let parse string = MyDict.(find_opt string dict)
   let getAdDef { adDefinition } = adDefinition
   let getNounDef { nounDefinition } = nounDefinition
   let getVerbDef { verbDefinition } = verbDefinition
   let getDescription { description } = description
   let show { str } = str
end

module Conj: Lang.CONJ_DICTIONARY = struct
   type t = {
         str: string;
         definition: string;
         description: string;
   }

   let dict: t MyDict.t = MyDict.empty
         |> MyDict.add "en" { str="en"; definition="and"; description="Afrikaans: en" }
         |> MyDict.add "of" { str="of"; definition="or"; description="Afrikaans: of" }
         |> MyDict.add "vant" { str="vant"; definition="because"; description="Afrikaans: want" }
         |> MyDict.add "sodat" { str="sodat"; definition="so that"; description="Afrikaans: sodat" }

   let all = Belt.List.map (MyDict.bindings dict) (fun (_, term) -> term)

   let mem key = Belt.Option.isSome MyDict.(find_opt key dict)
   let parse key = MyDict.find_opt key dict
   let show { str } = str
   let getDef { definition } = definition
   let getDescription { description } = description
end
