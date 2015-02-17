fields = () =>
  @grid.Fields

# Template.tabs.rendered = () ->
#   $('#tabs').tabs()


Template.statsTable.showStat = (key, object) ->
  object[key] isnt 'undefined' and object[key] isnt '' and object[key] isnt 'NF' and object[key] isnt 'NAP'

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.statsTable.getDescription = (event) ->
  val = Template.statsTable.getVal(@spreadsheetName, event)
  explanation = @dropdownExplanations[val]
  if explanation
    "#{@description} (#{val}: #{explanation})"
  else
    @description

Template.tabs.stats = () ->
  fields().find({"tab": "Stats"}, {"sort": {"order": 1}})

Template.tabs.pathogenStats = () ->
  fields().find({"tab": "Pathogen"}, {"sort": {"order": 1}})

Template.tabs.locationStats = () ->
  fields().find({"tab": "Location"}, {"sort": {"order": 1}})

Template.tabs.economicsStats = () ->
  fields().find({"tab": "Economics"}, {"sort": {"order": 1}})

Template.referenceDescription.formatAuthor = () ->
  @creators[0].lastName

Template.reference.isPMCID = () ->
  @archive is 'PMCID'

Template.reference.isPMID = () ->
  @archive is 'PMID'
