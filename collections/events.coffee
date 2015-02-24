Events = new Meteor.Collection "events"

@grid ?= {}
@grid.Events = Events

if Meteor.isServer
  ReactiveTable.publish "events", Events, {'eidVal': "1"}

  Meteor.publish "event", (eidID) ->
    Events.find({'eidID': eidID})
    
  Meteor.publish "locations", () ->
    Events.find({}, {fields: {'locations.locationLatitude': 1, 'locations.locationLongitude': 1, eidID: 1, eventNameVal: 1}})
