Fields = () ->
  @grid.Fields

Template.mapFilters.created = () ->
  # show property is if we want to hide some of the variable checkboxes on load since the list is getting long
  filterVariables = [
    {name: 'eidCategoryVal', show: true}
    {name: 'zoonoticVal',show: false}
    {name: 'eventTransmissionAnimalVal', show: false}
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
  @userSearchText = new ReactiveVar ''

Template.mapFilters.rendered = () ->
  @autorun () ->
    checkValues = getCheckboxValues()
    filters =
      _.chain(checkValues)
        .map((variable) ->
          checkedValues = _.filter variable.values, (value) ->
            value.state
          if checkedValues.length
            _.map checkedValues, (value) ->
              varQuery = {}
              field = Fields().findOne({spreadsheetName: variable.variable})
              if not _.isEmpty field.dropdownExplanations
                varQuery[variable.variable] = new RegExp(value.name, 'i')
              else
                varQuery[variable.variable] = new RegExp('^'+value.name+'$', 'i')
              varQuery
          else
            varQuery = {}
            varQuery[variable.variable] = ''
            [varQuery]
        ).map((variable) ->
          {$or: variable}
        )
        .value()

    userSearchText = Template.instance().userSearchText.get()
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, () -> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    filters.push({$or: nameQuery})

    Template.instance().data.query.set({ $and: filters })

getCheckboxStates = () ->
  _.map @checkBoxes.get()[@variable], (value, key)->
    value

checkAll = (state) ->
  variables = Template.instance().variables.get()
  for value of variables[@variable]
    variables[@variable][value] = state
  Template.instance().variables.set(variables)

getCheckboxValues = () ->
  variables = Template.instance().variables.get()
  variablesList = []
  for variable, valueStates of variables
    field = Fields().findOne({spreadsheetName: variable})
    values = []
    for name, state of valueStates
      values.push({name: name, state: state})
    variablesList.push({variable: variable, displayName: field.displayName, values: values})
  variablesList

Template.mapFilters.helpers
  getCheckboxValues : getCheckboxValues

  getCheckboxList: () ->
    Template.instance().variables

Template.checkboxControl.helpers
  showUncheckAll: () ->
    checkboxStates = getCheckboxStates.call(@)
    _.some(checkboxStates) or _.every(checkboxStates, _.identity)
  showCheckAll : () ->
    checkboxStates = getCheckboxStates.call(@)
    unChecked = _.filter(checkboxStates, (state) -> return state)
    unChecked.length is 0 or unChecked.length < checkboxStates.length

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

  'keyup .map-search': (e) ->
    e.preventDefault()
    text = $(e.target).val()
    Template.instance().userSearchText.set(text)

  'click .clear-search': (e) ->
    $('.map-search').val('')
    Template.instance().userSearchText.set('')

  'click .check': (e) ->
    if $(e.target).hasClass('check-all')
      checkAll.call(this,true)
    else
      checkAll.call(this, false)

  'click .mobile-control': (e) ->
    $('.map-search-wrap').toggleClass('open')
