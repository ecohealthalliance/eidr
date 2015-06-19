filterMap = (userSearchText) ->
  query = Template.instance().data.query
  if query.get()
    checkedValues = getChecked()
    filters =
      _.chain(checkedValues)
        .groupBy('variable')
        .map((checkedValues, variable) ->
          _.map checkedValues, (value) ->
            varQuery = {}
            varQuery[value.variable+'Val'] = new RegExp(value.value, 'i')
            varQuery
        ).map((variable)->
          {$or: variable}
        )
        .value()
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, ()-> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    filters.push({$or: nameQuery})
    query.set({ $and: filters })
  else
    query.set(false)

clearSearch = () ->
  filterMap('')

getChecked = (type) ->
  _.map $('input[type=checkbox]:checked').get(), (input) ->
    'variable': input.className
    'value': input.value

checkAll = (state, target) ->
  $('.checkAll input[type=checkbox]').each () -> $(this).prop("checked", state)
  filterMap($('.map-search').val() || '')
  $(target).toggleClass 'uncheck-all check-all'

Template.mapFilters.helpers
  getFieldValues: (fields, spreadsheetName) ->
    types = []
    field = fields.findOne({spreadsheetName: spreadsheetName+'Val'})
    for key of field.dropdownExplanations
      types.push(key)
    types

Template.mapFilters.events
  'click .filter' : (e) ->
    $('.filter').toggleClass('open')
    $('.filters-wrap').toggleClass('hidden')

  'change input[type=checkbox]': (e) ->
    filterMap($('.map-search').val() || '', getChecked())

  'keyup .map-search': (e) ->
    e.preventDefault()
    text = $(e.target).val()
    if !text
      clearSearch()
    else if text.length > 2
      filterMap(text)
  'click .clear-search': (e) ->
    $('.map-search').val('')
    clearSearch()
  'click .check': (e) ->
    if $(e.target).hasClass('check-all')
      checkAll(true, e.target)
    else
      checkAll(false, e.target)
  'click .mobile-control': (e) ->
    $('.map-search-wrap').toggleClass('open')

