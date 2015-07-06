Template.variableDefinitions.helpers
  getTabs: (fields) ->
    _.chain(fields.fetch())
    .pluck('tab')
    .unique()
    .value()

  getTabVariables: (fields, tab) ->
    _.filter fields.fetch(), (value) -> value.tab is tab

  getDropdownExplanations: () ->
    _.map @webDropdownExplanations.split(';'), (value) ->
      value = value.split(':')
      type: value[0].trim()
      explanation: value[1].trim()

  checkExtendedExplanation: () ->
    @webDropdownExplanations.indexOf(':') >= 0
