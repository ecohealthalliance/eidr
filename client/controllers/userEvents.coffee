Template.userEvents.onCreated () ->
  @userEventFields = [
    {
      arrayName: '',
      description: 'The name of the EID.',
      displayName: 'Event Name',
      spreadsheetName: 'eventName'
    }
  ]
  
  @currentPage = new ReactiveVar(Session.get('events-current-page') or 0)
  @rowsPerPage = new ReactiveVar(Session.get('events-rows-per-page') or 10)
  @fieldVisibility = {}
  @sortOrder = {}
  @sortDirection = {}
  
  for field in @userEventFields
    oldVisibility = Session.get('events-field-visible-' + field.spreadsheetName)
    visibility = if _.isUndefined(oldVisibility) then true else oldVisibility
    @fieldVisibility[field.spreadsheetName] = new ReactiveVar(visibility)
    
    defaultSortOrder = Infinity
    oldSortOrder = Session.get('events-field-sort-order-' + field.spreadsheetName)
    sortOrder = if _.isUndefined(oldSortOrder) then defaultSortOrder else oldSortOrder
    @sortOrder[field.spreadsheetName] = new ReactiveVar(sortOrder)
    
    defaultSortDirection = 1
    oldSortDirection = Session.get('events-field-sort-direction-' + field.spreadsheetName)
    sortDirection = if _.isUndefined(oldSortDirection) then defaultSortDirection else oldSortDirection
    @sortDirection[field.spreadsheetName] = new ReactiveVar(sortDirection)
  
  @autorun () =>
    Session.set 'events-current-page', @currentPage.get()
    Session.set 'events-rows-per-page', @rowsPerPage.get()
    for field in @userEventFields
      Session.set 'events-field-visible-' + field.spreadsheetName, @fieldVisibility[field.spreadsheetName].get()
      Session.set 'events-field-sort-order-' + field.spreadsheetName, @sortOrder[field.spreadsheetName].get()
      Session.set 'events-field-sort-direction-' + field.spreadsheetName, @sortDirection[field.spreadsheetName].get()

Template.userEvents.helpers
  userEvents: () ->
    return grid.UserEvents.find()
  
  settings : () ->
    fields = []
    for field in Template.instance().userEventFields
      fields.push {
        key: field.spreadsheetName
        label: field.displayName
        isVisible: Template.instance().fieldVisibility[field.spreadsheetName]
        sortOrder: Template.instance().sortOrder[field.spreadsheetName]
        sortDirection: Template.instance().sortDirection[field.spreadsheetName]
        sortable: not field.arrayName
      }
    
    return {
      id: 'user-events-table'
      showColumnToggles: true
      fields: fields
      currentPage: Template.instance().currentPage
      rowsPerPage: Template.instance().rowsPerPage
      showRowCount: true
    }

Template.userEvents.events
  "click .reactive-table tbody tr": (event) ->
    if event.metaKey
      url = Router.url "user-event", {_id: @_id}
      window.open(url, "_blank")
    else
      Router.go "user-event", {_id: @_id}
  "click .next-page, click .previous-page" : () ->
    if (window.scrollY > 0 and window.innerHeight < 700)
      $('body').animate({scrollTop:0,400})