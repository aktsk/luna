%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "web/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Readability.MaxLineLength, max_length: 120},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Refactor.Nesting, false},
        {Credo.Check.Refactor.PipeChainStart, false},
      ]
    }
  ]
}
