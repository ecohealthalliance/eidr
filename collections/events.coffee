Events = new Meteor.Collection "events"

@grid ?= {}
@grid.Events = Events

if Meteor.isServer
  ReactiveTable.publish "events", Events, {'eidVal': {"$in": ["1", "2"]}}

  Meteor.publish "event", (eidID) ->
    Events.find({'eidID': eidID, 'eidVal': {"$in": ["1", "2"]}})
    
  Meteor.publish "locations", () ->
    Events.find({'eidVal': "1"}, {fields: {'locations.locationLatitude': 1, 'locations.locationLongitude': 1, eidID: 1, eventNameVal: 1, eidVal: 1}})
