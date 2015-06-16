filterMap = (userSearchText, zoonosis, eventTransmission) ->
  query = Template.instance().data.query
  zoonoticQuery = []
  eventTransmissionQuery = []
  if userSearchText and zoonosis.length and eventTransmission.length
    nameQuery = []
    searchWords = userSearchText.split(' ')
    _.each searchWords, ()-> nameQuery.push {eventNameVal: new RegExp(userSearchText, 'i')}
    _.each zoonosis, (value) -> zoonoticQuery.push({zoonoticVal: new RegExp(value, 'i')})
    _.each eventTransmission, (value) -> eventTransmissionQuery.push({eventTransmissionVal: new RegExp(value, 'i')})
    query.set({ $and: [ {$or: nameQuery}, {$or: zoonoticQuery}, {$or: eventTransmissionQuery} ] })
  else if zoonosis.length and eventTransmission.length
    _.each zoonosis, (value) -> zoonoticQuery.push({zoonoticVal: new RegExp(value, 'i')})
    _.each eventTransmission, (value) -> eventTransmissionQuery.push({eventTransmissionVal: new RegExp(value, 'i')})
    query.set({$and: [{$or: zoonoticQuery}, {$or: eventTransmissionQuery}]})
  else 
    query.set(false)

clearSearch = () ->
  filterMap(false, getChecked('zoonosis'), getChecked('category'))

clearAllFilters = () ->
  Template.instance().filteredEvents.set(Template.instance().allEvents.get())

getChecked = (type) ->
  _.map $('.'+type+':checked').get(), (input) -> input.value

checkAll = (state, target) ->
  $('.category').each () -> $(this).prop("checked", state)
  filterMap($('.map-search').val() || false, getChecked('zoonosis'), getChecked('category'))
  $(target).toggleClass 'uncheck-all check-all'

Template.mapFilters.helpers
  getTransmissionTypes: (field) ->
    types = []
    for key of field.dropdownExplanations
      types.push(key)
    types.push("Not Found")
    types

Template.mapFilters.events
  'click .filter' : (e) ->
    $('.filter').toggleClass('open')
    $('.filters-wrap').toggleClass('hidden')

  'change input[type=checkbox]': (e) ->
    filterMap($('.map-search').val() || false, getChecked('zoonosis'), getChecked('category'))

  'keyup .map-search': (e) ->
    e.preventDefault()
    if $(e.target).val() == ''
      clearSearch()
    if e.keyCode == 13
      userSearchText = $(e.target).val()
      filterMap(userSearchText, getChecked('zoonosis'), getChecked('category'))
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

