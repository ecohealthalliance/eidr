Fields = () ->
  @grid.Fields

filterMap = (userSearchText) ->
  query = Template.instance().data.query
  if query.get()
    inputValues = getInputValues()
    filters =
      _.chain(inputValues)
        .groupBy('variable')
        .map((inputValues, variable) ->
          checkedValues = _.filter inputValues, (value) ->
            value.checked
          if checkedValues.length
            _.map checkedValues, (value) ->
              varQuery = {}
              if value.dropdownExplanations
                varQuery[value.variable+'Val'] = new RegExp(value.value, 'i')
              else
                varQuery[value.variable+'Val'] = new RegExp('^'+value.value+'$', 'i')
              varQuery
          else
            varQuery = {}
            varQuery[inputValues[0].variable+'Val'] = ''
            [varQuery]
        ).map((variable) ->
          {$or: variable}
        )
        .value()
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, () -> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    filters.push({$or: nameQuery})
    query.set({ $and: filters })
  else
    query.set(false)

clearSearch = () ->
  filterMap('')

getInputValues = (type) ->
  _.map $('input[type=checkbox]').get(), (input) ->
    fields = Fields().findOne({spreadsheetName: input.className+'Val'})
    'variable': input.className
    'value': input.value
    'checked': input.checked
    'dropdownExplanations': not _.isEmpty(fields.dropdownExplanations)


checkAll = (state, target) ->
  parent = $(target).closest('.filter-block')[0].classList[1]
  $('.'+parent+' input[type=checkbox]').each () -> $(this).prop("checked", state)
  filterMap($('.map-search').val() || '')
  countChecked(parent)

changeToggle = (state, hide, parent) ->
  if hide
    $('.'+parent+' .'+state+'-all').addClass 'hidden'
  else
    $('.'+parent+' .'+state+'-all').removeClass 'hidden'

countChecked = (parent) ->
  allCheckBoxes = $('.'+parent+' input[type=checkbox]').get().length
  checkedCheckBoxes = $('.'+parent+' input[type=checkbox]:checked').get().length
  if checkedCheckBoxes is 0
    changeToggle('check', false, parent)
    changeToggle('uncheck', true, parent)
  else if checkedCheckBoxes == allCheckBoxes
    changeToggle('check', true, parent)
    changeToggle('uncheck', false, parent)
  else
    changeToggle('check', false, parent)
    changeToggle('uncheck', false, parent)

Template.mapFilters.helpers
  getFieldValues: (spreadsheetName) ->
    types = []
    field = Fields().findOne({spreadsheetName: spreadsheetName+'Val'})
    for key of field.dropdownExplanations
      types.push(key)
    types.push('Not Found')
    types
  getEventTransmissionAnimal: () ->
    ['Yes', 'No', 'Uncertain', 'Not Found']


Template.mapFilters.events
  'click .filter' : (e) ->
    $('.filter').toggleClass('open')
    $('.filters-wrap').toggleClass('hidden')

  'change input[type=checkbox]': (e) ->
    countChecked()
    filterMap($('.map-search').val() || '', getInputValues())

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

