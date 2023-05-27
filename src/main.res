let root = ReactDOM.Client.createRoot(ReactDOM.querySelector("#root")->Belt.Option.getExn)
root -> ReactDOM.Client.Root.render (
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
