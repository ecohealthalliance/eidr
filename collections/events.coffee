Events = new Meteor.Collection "events"

@grid ?= {}
@grid.Events = Events

if Meteor.isServer
  Meteor.publish "events", () ->
    Events.find()

  Meteor.publish "event", (eidID) ->
    Events.find({'eidID': eidID})
