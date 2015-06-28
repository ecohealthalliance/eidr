Fields = () ->
  @grid.Fields

Template.registerHelper 'log', (l)->
  console.log l

Template.mapFilters.created = () ->
  filterVariables = [
    {
      name: 'eidCategoryVal'
      show: true
    }
    {
      name: 'zoonoticVal'
      show: false
    }
    {
      name: 'eventTransmissionAnimalVal'
      show: false
    }
  ]
  variables = {}
  _.each filterVariables, (variable) ->
    field = Fields().findOne({spreadsheetName: variable.name})
    variables[variable.name] = {}
    if _.isEmpty(field.dropdownExplanations)
      _.each field.values.split(','), (value) ->
        variables[variable.name][value.trim()] = true
    else
      for key of field.dropdownExplanations
        variables[variable.name][key.trim()] = true

  @variables = new ReactiveVar variables

Template.mapFilters.rendered = () ->

  # @autorun (userSearchText) ->
  #   query = Template.instance().data.query
  #   checked = Template.instance().checkBoxes
  #   console.log "Checked",checked
  #   if query.get()
  #     filters =
  #       _.chain(inputValues)
  #         .groupBy('variable')
  #         .map((inputValues, variable) ->
  #           checkedValues = _.filter inputValues, (value) ->
  #             value.checked
  #           if checkedValues.length
  #             _.map checkedValues, (value) ->
  #               varQuery = {}
  #               if value.dropdownExplanations
  #                 varQuery[value.variable+'Val'] = new RegExp(value.value, 'i')
  #               else
  #                 varQuery[value.variable+'Val'] = new RegExp('^'+value.value+'$', 'i')
  #               varQuery
  #           else
  #             varQuery = {}
  #             varQuery[inputValues[0].variable+'Val'] = ''
  #             [varQuery]
  #         ).map((variable) ->
  #           {$or: variable}
  #         )
  #         .value()
  #     nameQuery = []
  #     searchWords = userSearchText.split(' ')
  #     _.each searchWords, () -> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
  #     filters.push({$or: nameQuery})
  #     query.set({ $and: filters })
  #   else
  #     query.set(false)

clearSearch = () ->
  filterMap('')

getInputValues = (type) ->
  _.map $('input[type=checkbox]').get(), (input) ->
    fields = Fields().findOne({spreadsheetName: input.className+'Val'})
    'variable': input.className
    'value': input.value
    'checked': input.checked
    'dropdownExplanations': not _.isEmpty(fields.dropdownExplanations)

getCheckboxStates = () ->
  _.map @checkBoxes.get()[@variable], (value, key)->
    value

Template.mapFilters.helpers
  getCheckedValues : () ->
    variables = Template.instance().variables.get()
    variablesList = []
    for key,variable of variables
      field = Fields().findOne({spreadsheetName: key})
      values = []
      for name, value of variable
        values.push({name: name, state: value})
      variablesList.push({variable: key, displayName: field.displayName, values: values})
    variablesList
  getCheckboxList: () ->
    Template.instance().variables

Template.checkControl.helpers
  showUncheckAll: () ->
    checkboxStates = getCheckboxStates.call(@)
    if _.some(checkboxStates) or _.every(checkboxStates, _.identity) # and _.filter(checkboxStates, (v) -> return v).length > 0
      return true
  showCheckAll : () ->
    checkboxStates = getCheckboxStates.call(@)
    unChecked = _.filter(checkboxStates, (v) -> return v)
    console.log unChecked.length, checkboxStates.length
    if unChecked.length is 0 or unChecked.length < checkboxStates.length
      return true

Template.mapFilters.events
  'click .filter' : (e) ->
    $('.filter').toggleClass('open')
    $('.filters-wrap').toggleClass('hidden')

  'click input[type=checkbox]': (e) ->
    variables = Template.instance().variables.get()
    target = $(e.target)
    value = target.val()
    variable = target[0].className
    state = target[0].checked
    variables[variable][value] = state
    Template.instance().variables.set(variables)
    # filterMap($('.map-search').val() || '', getInputValues())

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
