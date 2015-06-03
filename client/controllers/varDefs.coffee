Template.varDefs.helpers
  getTabs: (fields) ->
    tabs = _.chain(fields.fetch())
    .groupBy('tab')
    .keys()
    .value()

  getTabValues: (fields, tab) ->
    values = _.filter fields.fetch(), (value) -> value.tab is tab 

  getDropdownValues: (values) ->
    for key, value of values
      type: key
      explanation: value
