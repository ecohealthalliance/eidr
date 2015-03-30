fields = () =>
  @grid.Fields
  
references = () =>
  @grid.References

Template.tables.unknowns = []

Template.statsTable.showStat = (key, object) ->
  if grid.Fields.findOne({"spreadsheetName" : key}).Quotations isnt 0
    quote = @Quotations
  if object[key] isnt 'undefined' and object[key] isnt '' and object[key] isnt 'NAP' and object[key] isnt 'NF'
    object[key]
  else if object[key] is 'NF' and object[quote] and (object[quote] isnt 'undefined' or object[quote] isnt '')
    object[key]
  # else if object[key] is 'NF' or object[key] is 'NAP'
    # console.log("test", object)

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.statsTable.getDescription = (event) ->
  vals = Template.statsTable.getVal(@spreadsheetName, event).trim().split(", ")
  explanations = ("#{val}: #{@dropdownExplanations[val]}" for val in vals when @dropdownExplanations[val]).join("; ")
  if explanations
    "#{@description} (#{explanations})"
  else
    @description

Template.tables.getDescription = Template.statsTable.getDescription

Template.tables.log = (t) ->
  console.log t

Template.statsTable.getQuote = (event) ->
  if @Quotations isnt 0 and @Quotations isnt ''
    Template.statsTable.getVal(@Quotations, event)
    
Template.statsTable.getReference = (event) ->
  fieldName = @spreadsheetName.slice(0, -3) # cut off "Val"
  zoteroIds = event.references[fieldName]
  refs = _.map zoteroIds, (zoteroIdOrString) ->
    references().findOne({zoteroId: zoteroIdOrString})?.title or zoteroIdOrString
  refs.join(", ")

Template.tables.checkStats = (table, event) ->
  values = []
  table.forEach (t) ->
    value = Template.statsTable.getVal(t.spreadsheetName, event)
    if (value and value isnt 'NF' and value isnt 'NAP')
      values.push(value)
    else if value is 'NF' or value is 'NAP'
      console.log t
      Template.tables.unknowns.push({'name': t.displayName, 'description':t.description})
  values.length > 0

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

