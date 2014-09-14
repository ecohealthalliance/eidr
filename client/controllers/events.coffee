events = () =>
  @grid.Events

Template.events.loaded = () ->
  events().find().count() > 400

Template.events.collection = () ->
  events().find({'eidVal': '1'})

Template.events.settings = () ->
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
  ]

Template.events.events
  "click .reactive-table tbody tr": (event) ->
    Router.go "event", { eidID: @eidID }
