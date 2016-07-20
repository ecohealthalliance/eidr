Geolocations = new Mongo.Collection "geolocations"

@grid ?= {}
@grid.Geolocations = Geolocations

if Meteor.isServer
  Meteor.publish "eventLocations", (userEventId) ->
    Geolocations.find({userEventId: userEventId})

Meteor.methods
  addEventLocation: (eventId, location) ->
    if Meteor.user()
      if location.url and location.url.trim().length
        geolocation = {userEventId: eventId, url: location.url}
        urlSplit = location.url.split("/")
        if urlSplit.length >= 4 and urlSplit[2] is "www.geonames.org"
          geolocation.geonameId = urlSplit[3]
        else
          throw new Meteor.Error("geolocations.addEventLocation.invalid")
        Geolocations.insert(geolocation)
    else
        throw new Meteor.Error(403, "Not authorized")
  removeEventLocation: (id) ->
    if Meteor.user()
      Geolocations.remove(id)
    else
        throw new Meteor.Error(403, "Not authorized")