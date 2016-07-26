UserEvents = new Mongo.Collection "userEvents"

@grid ?= {}
@grid.UserEvents = UserEvents

if Meteor.isServer
  ReactiveTable.publish "userEvents", UserEvents, {}

  Meteor.publish "userEvent", (eidID) ->
    UserEvents.find({_id: eidID})

  UserEvents.allow
    insert: (userID, doc) ->
      doc.creationDate = new Date()
      Meteor.user()
    update: (userId, doc, fieldNames, modifier) ->
      Meteor.user()
