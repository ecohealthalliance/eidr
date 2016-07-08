UserEvents = new Mongo.Collection "userEvents"

@grid ?= {}
@grid.UserEvents = UserEvents

if Meteor.isServer
  Meteor.publish "userEvents", () ->
    UserEvents.find()
  
  UserEvents.allow
    insert: (userID, doc) ->
      return Meteor.user()