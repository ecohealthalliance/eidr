Fields = () ->
  @grid.Fields

Template.mapFilters.created = () ->
  filterVariables = [
    {name: 'eidCategoryVal', show: true}
    {name: 'zoonoticVal',show: false}
    {name: 'eventTransmissionAnimalVal', show: false}
  ]
  variables = {}
  _.each filterVariables, (variable) ->
    field = Fields().findOne({spreadsheetName: variable.name})
    values = {}
    if _.isEmpty(field.dropdownExplanations)
      _.each field.values.split(','), (value) ->
        values[value.trim()] = true
    else
      for key of field.dropdownExplanations
        values[key.trim()] = true
    variableInfo =
      values: values
      show: variable.show
      displayName: field.displayName
      spreadsheetName: field.spreadsheetName
      strictSearch: _.isEmpty field.dropdownExplanations
    variables[variable.name] = variableInfo

  @variables = new ReactiveVar variables
  @userSearchText = new ReactiveVar ''

Template.mapFilters.rendered = () ->
  @autorun () ->
    checkValues = Template.instance().variables.get()
    filters =
      _.chain(checkValues)
        .map((variable) ->
          checkedValues = []
          for key, value of variable.values
            if value
              checkedValues.push key
          if checkedValues.length
            _.map checkedValues, (value) ->
              varQuery = {}
              if variable.strictSearch
                varQuery[variable.spreadsheetName] = new RegExp('^'+value+'$', 'i')
              else
                varQuery[variable.spreadsheetName] = new RegExp(value, 'i')
              varQuery
          else
            varQuery = {}
            varQuery[variable.variable] = ''
            [varQuery]
        ).map((variable) -> {$or: variable})
        .value()
    userSearchText = Template.instance().userSearchText.get()
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, () -> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    filters.push({$or: nameQuery})

    Template.instance().data.query.set({ $and: filters })

getCheckboxStates = () ->
  _.map @checkBoxes.get()[@variable].values, (value, key)->
    value

checkAll = (state) ->
  variables = Template.instance().variables.get()
  for value of variables[@variable].values
    variables[@variable]['values'][value] = state
  Template.instance().variables.set(variables)

Template.mapFilters.helpers
  getCheckboxList: () ->
    Template.instance().variables

  getVariables: () ->
    _.map Template.instance().variables.get(), (variable, key)->
      variable

  getValues: () ->
    values = []
    for name, state of @values
      values.push({'name': name, 'state': state})
    values

Template.checkboxControl.helpers
  showUncheckAll: () ->
    checkboxStates = getCheckboxStates.call(@)
    _.some(checkboxStates) or _.every(checkboxStates)
  showCheckAll : () ->
    !_.every(getCheckboxStates.call(@))

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
    variables[variable]['values'][value] = state
    Template.instance().variables.set(variables)

  'keyup .map-search': _.debounce (e, templateInstance) ->
    e.preventDefault()
    text = $(e.target).val()
    templateInstance.userSearchText.set(text)

  'click .clear-search': (e) ->
    $('.map-search').val('')
    setUserSearchText('')

  'click .check': (e) ->
    if $(e.target).hasClass('check-all')
      checkAll.call(this,true)
    else
      checkAll.call(this, false)

  'click .mobile-control': (e) ->
    $('.map-search-wrap').toggleClass('open')
