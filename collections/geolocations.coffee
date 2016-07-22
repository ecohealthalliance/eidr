Geolocations = new Mongo.Collection "geolocations"

@grid ?= {}
@grid.Geolocations = Geolocations

if Meteor.isServer
  Meteor.publish "eventLocations", (userEventId) ->
    Geolocations.find({userEventId: userEventId})

Meteor.methods
  addEventLocations: (eventId, locations) ->
    if Meteor.user()
      for l in locations
        if l.url and l.url.trim().length
          Geolocations.insert({userEventId: eventId, url: l.url})
    else
        throw new Meteor.Error(403, "Not authorized")
  removeEventLocation: (id) ->
    if Meteor.user()
      Geolocations.remove(id)
    else
        throw new Meteor.Error(403, "Not authorized")