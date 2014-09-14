fields = () =>
  @grid.Fields

Template.tabs.rendered = () ->
  $('#tabs').tabs()


Template.statsTable.showStat = (key, object) ->
  object[key] isnt 'undefined' and object[key] isnt '' and object[key] isnt 'NF' and object[key] isnt 'NAP'

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.tabs.stats = () ->
  fields().find({"tab": "Stats"})

Template.tabs.pathogenStats = () ->
  fields().find({"tab": "Pathogen"})

Template.tabs.locationStats = () ->
  fields().find({"tab": "Location"})

Template.tabs.economicsStats = () ->
  fields().find({"tab": "Economics"})

Template.reference.formatAuthor = () ->
  @creators[0].lastName
