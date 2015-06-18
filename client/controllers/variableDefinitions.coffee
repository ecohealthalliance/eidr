Template.variableDefinitions.helpers
  getTabs: (fields) ->
    _.chain(fields.fetch())
    .pluck('tab')
    .unique()
    .value()

  getTabVariables: (fields, tab) ->
    _.filter fields.fetch(), (value) -> value.tab is tab 

  getDropdownValues: (values) ->
    for key, value of values
      type: key
      explanation: value
