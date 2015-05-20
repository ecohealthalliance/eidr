fields = () =>
  @grid.Fields
  
references = () =>
  @grid.References

Template.statsTable.showStat = (key, object) ->
  field = grid.Fields.findOne {"spreadsheetName": key}
  if field.Quotations isnt 0
    quote = @Quotations
  if object[key] isnt 'undefined' and 
     object[key] isnt '' and 
     object[key] isnt 'Not Applicable' and 
     object[key] isnt 'Not Found' and
     object[key] not in field.valuesToHide
    object[key]
  else if object[key] is 'Not Found' and object[quote] and (object[quote] isnt 'undefined' or object[quote] isnt '')
    object[key]

Template.statsTable.getVal = (key, object) ->
  object[key]

Template.statsTable.getQuote = (event) ->
  if @Quotations isnt 0 and @Quotations isnt ''
    quotes = Template.statsTable.getVal(@Quotations, event)
    if quotes
      quotes.trim()
    
Template.statsTable.getReference = (event) ->
  fieldName = @spreadsheetName.slice(0, -3) # cut off "Val"
  zoteroIds = event.references[fieldName]
  refs = _.map zoteroIds, (zoteroIdOrString) ->
    references().findOne({zoteroId: zoteroIdOrString})?.title or zoteroIdOrString
  refs.join("; ")

Template.tables.checkStats = (table, event) ->
  values = []
  table.forEach (t) ->
    value = Template.statsTable.getVal(t.spreadsheetName, event)
    if (value and value isnt 'Not Found' and value isnt 'Not Applicable')
      values.push(value)
  values.length > 0

Template.tables.getNotFound = (event) ->
  notFound = []
  for key, value of event when value is "Not Found"
    info = fields().findOne({"spreadsheetName" : key})
    if info
      notFound.push
        name: info.displayName
        description: info.description
  notFound

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

