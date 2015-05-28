Template.varDefs.helpers
  log: (l) ->
    console.log l
  displayValues: (values) ->
    for key, value of values
      type: key
      explanation: value
