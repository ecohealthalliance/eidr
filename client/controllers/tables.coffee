fields = () =>
  @grid.Fields
  
references = () =>
  @grid.References

Template.statsTable.showStat = (key, object) ->
  object[key] isnt 'undefined' and object[key] isnt '' and object[key] isnt 'NF' and object[key] isnt 'NAP'

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.statsTable.getDescription = (event) ->
  vals = Template.statsTable.getVal(@spreadsheetName, event).trim().split(", ")
  explanations = ("#{val}: #{@dropdownExplanations[val]}" for val in vals when @dropdownExplanations[val]).join("; ")
  if explanations
    "#{@description} (#{explanations})"
  else
    @description

Template.statsTable.getQuote = (event) ->
  if @Quotations isnt 0 and @Quotations isnt ''
    Template.statsTable.getVal(@Quotations, event)
    
Template.statsTable.getReference = (event) ->
  fieldName = @spreadsheetName.slice(0, -3) # cut off "Val"
  zoteroIds = event.references[fieldName]
  refs = _.map zoteroIds, (zoteroIdOrString) ->
    references().findOne({zoteroId: zoteroIdOrString})?.title or zoteroIdOrString
  refs.join(", ")
  

Template.tables.stats = () ->
  fields().find({"tab": "Stats"}, {"sort": {"order": 1}})

Template.tables.pathogenStats = () ->
  fields().find({"tab": "Pathogen"}, {"sort": {"order": 1}})

Template.event.locationStats = () ->
  fields().find({"tab": "Location"}, {"sort": {"order": 1}})

Template.tables.economicsStats = () ->
  fields().find({"tab": "Economics"}, {"sort": {"order": 1}})

Template.author.formatAuthor = () ->
  @creators[0].lastName

Template.reference.isPMCID = () ->
  @archive is 'PMCID'

Template.reference.isPMID = () ->
  @archive is 'PMID'

