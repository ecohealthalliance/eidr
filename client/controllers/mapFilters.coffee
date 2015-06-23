filterMap = (userSearchText) ->
  query = Template.instance().data.query
  if query.get()
    inputValues = getInputInfo()
    filters =
      _.chain(inputValues)
        .groupBy('variable')
        .map((inputValues, variable) ->
          checkedValues = _.filter inputValues, (value) ->
            value.checked
          if checkedValues.length
            _.map checkedValues, (value) ->
              varQuery = {}
              varQuery[value.variable+'Val'] = new RegExp(value.value, 'i')
              varQuery
          else
            varQuery = {}
            varQuery[inputValues[0].variable+'Val'] = ''
            [varQuery]
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

getInputInfo = (type) ->
  _.map $('input[type=checkbox]').get(), (input) ->
    'variable': input.className
    'value': input.value
    'checked': input.checked

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
    filterMap($('.map-search').val() || '', getInputInfo())

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

