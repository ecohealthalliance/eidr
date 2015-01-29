Events = new Meteor.Collection "events"

@grid ?= {}
@grid.Events = Events

if Meteor.isServer
  ReactiveTable.publish "events", Events, {'eidVal': "1"}

  Meteor.publish "event", (eidID) ->
    Events.find({'eidID': eidID})
