let onWordClickContext: React.Context.t<string => unit> = React.createContext(_ => ());

module OnWordClickProvider = {
    let make = React.Context.provider(onWordClickContext);
}
