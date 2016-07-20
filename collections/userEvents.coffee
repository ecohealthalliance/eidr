UserEvents = new Mongo.Collection "userEvents"

@grid ?= {}
@grid.UserEvents = UserEvents

if Meteor.isServer
  ReactiveTable.publish "userEvents", UserEvents, {}
  
  Meteor.publish "userEvent", (eidID) ->
    UserEvents.find({'_id': eidID})
  
  UserEvents.allow
    update: (userId, doc, fieldNames, modifier) ->
      return Meteor.user()

Meteor.methods
  addUserEvent: (name, locations) ->
    trimmedName = name.trim()
    if trimmedName.length isnt 0
      UserEvents.insert({eventName: trimmedName, creationDate: new Date()}, (error, result) ->
        if result
          for location in locations
            Meteor.call("addEventLocation", result, location)
      )