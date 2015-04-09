Template.events.settings = () ->
  fields = []
  for field in @fields.fetch()
    do (field) ->
      fields.push
        key: field.spreadsheetName
        label: field.displayName
        hidden: field['Event table'] isnt '2'
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
    showColumnToggles: true
    fields: fields
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