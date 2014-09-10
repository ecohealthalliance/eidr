events = () =>
  @grid.Events

Template.events.loaded = () ->
  events().find().count() > 400

Template.events.collection = () ->
  events()

Template.events.settings = () ->
  fields: [
    { key: 'eventName', label: 'Event' }
  ]

Template.events.events
  "click .reactive-table tbody tr": (event) ->
    Router.go "event", { eidID: @eidID }
