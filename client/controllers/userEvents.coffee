Template.userEvents.onCreated ->
  @userEventFields = [
    {
      arrayName: '',
      description: 'Date the event was created.',
      displayName: 'Creation Date',
      fieldName: 'creationDate',
      defaultSortDirection: -1
    },
    {
      arrayName: '',
      description: 'The name of the EID.',
      displayName: 'Event Name',
      fieldName: 'eventName',
      defaultSortDirection: 1
    }
  ]

  @currentPage = new ReactiveVar(Session.get('events-current-page') or 0)
  @rowsPerPage = new ReactiveVar(Session.get('events-rows-per-page') or 10)
  @fieldVisibility = {}
  @sortOrder = {}
  @sortDirection = {}

  for field in @userEventFields
    oldVisibility = Session.get('events-field-visible-' + field.fieldName)
    visibility = if _.isUndefined(oldVisibility) then true else oldVisibility
    @fieldVisibility[field.fieldName] = new ReactiveVar(visibility)

    defaultSortOrder = Infinity
    oldSortOrder = Session.get('events-field-sort-order-' + field.fieldName)
    sortOrder = if _.isUndefined(oldSortOrder) then defaultSortOrder else oldSortOrder
    @sortOrder[field.fieldName] = new ReactiveVar(sortOrder)

    defaultSortDirection = field.defaultSortDirection
    oldSortDirection = Session.get('events-field-sort-direction-' + field.fieldName)
    sortDirection = if _.isUndefined(oldSortDirection) then defaultSortDirection else oldSortDirection
    @sortDirection[field.fieldName] = new ReactiveVar(sortDirection)

  @autorun =>
    Session.set 'events-current-page', @currentPage.get()
    Session.set 'events-rows-per-page', @rowsPerPage.get()
    for field in @userEventFields
      Session.set 'events-field-visible-' + field.fieldName, @fieldVisibility[field.fieldName].get()
      Session.set 'events-field-sort-order-' + field.fieldName, @sortOrder[field.fieldName].get()
      Session.set 'events-field-sort-direction-' + field.fieldName, @sortDirection[field.fieldName].get()

Template.userEvents.helpers
  userEvents: ->
    return grid.UserEvents.find()

  settings: ->
    fields = []
    for field in Template.instance().userEventFields
      fields.push {
        key: field.fieldName
        label: field.displayName
        isVisible: Template.instance().fieldVisibility[field.fieldName]
        sortOrder: Template.instance().sortOrder[field.fieldName]
        sortDirection: Template.instance().sortDirection[field.fieldName]
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
  "click .next-page, click .previous-page": ->
    if (window.scrollY > 0 and window.innerHeight < 700)
      $(document.body).animate({scrollTop: 0}, 400)
