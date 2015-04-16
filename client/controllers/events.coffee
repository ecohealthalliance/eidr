Template.events.onCreated () ->
  @currentPage = new ReactiveVar(Session.get('events-current-page') or 0)
  @rowsPerPage = new ReactiveVar(Session.get('events-rows-per-page') or 10)

  fields = @data.fields.fetch()
  @fieldVisibility = {}
  for field in @data.fields.fetch()
    defaultVisibility = field['Event table'] is '2'
    @fieldVisibility[field.spreadsheetName] = new ReactiveVar(Session.get('events-field-visible-' + field.spreadsheetName) or defaultVisibility)

  @autorun () =>
    Session.set 'events-current-page', @currentPage.get()
    Session.set 'events-rows-per-page', @rowsPerPage.get()
    for field in @data.fields.fetch()
      Session.set 'events-field-visible-' + field.spreadsheetName, @fieldVisibility[field.spreadsheetName].get()


Template.events.settings = () ->
  fields = []
  for field in @fields.fetch()
    do (field) ->
      fields.push
        key: field.spreadsheetName
        label: field.displayName
        sortable: not field.arrayName
        isVisible: Template.instance().fieldVisibility[field.spreadsheetName]
        fn: (val, object) ->
          if field.arrayName
            array = object[field.arrayName] or []
            output = _.unique(element[field.spreadsheetName] for element in array).join(", ")
          else
            output = val or ''

          # hide Not Found/Not Applicable
          if output in ['Not Found', 'Not Applicable']
            output = ''

          # capitalize first letter
          if output.length > 1
            output = output.charAt(0).toUpperCase() + output.slice(1)

          # truncate long fields
          if output.length > 100
            output = output.slice(0, 100) + '...'

          # put empty values at the end
          if output is '' then sort = 2 else sort = 1

          new Spacebars.SafeString("<span sort=#{sort}>#{output}</span>")
  
  {
    id: 'events-table'
    showColumnToggles: true
    fields: fields
    currentPage: Template.instance().currentPage
    rowsPerPage: Template.instance().rowsPerPage
  }

Template.events.events
  "click .reactive-table tbody tr": (event) ->
    if event.metaKey
      url = Router.url "event", { eidID: @eidID }
      window.open(url, "_blank")
    else
      Router.go "event", { eidID: @eidID }
  "click .next-page, click .previous-page" : () ->
    if (window.scrollY > 0)
      $('body').animate({scrollTop:0,400})