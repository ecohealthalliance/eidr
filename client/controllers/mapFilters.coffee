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
              if value.variable == 'eidCategory'
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
    'variable': input.className
    'value': input.value
    'checked': input.checked

checkAll = (state, target) ->
  $('.checkAll input[type=checkbox]').each () -> $(this).prop("checked", state)
  filterMap($('.map-search').val() || '')
  countChecked()

changeToggle = (state, hide) ->
  if hide
    $('.'+state+'-all').addClass 'hidden'
  else
    $('.'+state+'-all').removeClass 'hidden'

countChecked = () ->
  allCheckBoxes = $('.checkAll input[type=checkbox]').get().length
  checkedCheckBoxes = $('.checkAll input[type=checkbox]:checked').get().length
  if checkedCheckBoxes is 0
    changeToggle('check')
    changeToggle('uncheck', true)
  else if checkedCheckBoxes == allCheckBoxes
    changeToggle('check', true)
    changeToggle('uncheck')
  else
    changeToggle('check')
    changeToggle('uncheck')

Template.mapFilters.helpers
  getFieldValues: (fields, spreadsheetName) ->
    types = []
    field = fields.findOne({spreadsheetName: spreadsheetName+'Val'})
    for key of field.dropdownExplanations
      types.push(key)
    types.push('Not Found')
    types

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

