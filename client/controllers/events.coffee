Template.events.loaded = () ->
  @eventList.count() > 300 and @fields.count() > 1

Template.events.settings = () ->
  {
    showColumnToggles: true
    fields: {
      key: field.spreadsheetName
      label: field.displayName
      hidden: field['Event table'] isnt '2'
      fn: (val) ->
        output = val

        # hide NF/NAP
        if output in ['NF', 'NAP']
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
    } for field in @fields.fetch()
  }

Template.events.events
  "click .reactive-table tbody tr": (event) ->
    Router.go "event", { eidID: @eidID }
