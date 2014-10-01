Template.events.loaded = () ->
  @eventList.count() > 300

Template.events.settings = () ->
  showColumnToggles: true
  fields: [
    { key: 'eventNameVal', label: 'Event' }
    {
      key: 'diseaseVal'
      label: 'Disease'
      fn: (val) ->
        if val is 'NF'
          ''
        else
          val.charAt(0).toUpperCase() + val.slice(1)
    }
    { key: 'startDateISO', label: 'Start Date', hidden: true }
    { key: 'endDateISO', label: 'End Date', hidden: true }
    { key: 'transmissionVal', label: 'Transmission', hidden: true }
    { key: 'locationName', label: 'Location', hidden: true }
    {
      key: 'Abstract'
      label: 'Abstract'
      hidden: true
      fn: (val) ->
        return val.slice(0, 100) + '...'
    }
  ]

Template.events.events
  "click .reactive-table tbody tr": (event) ->
    Router.go "event", { eidID: @eidID }
