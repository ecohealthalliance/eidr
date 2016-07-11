UserEvents = new Mongo.Collection "userEvents"

@grid ?= {}
@grid.UserEvents = UserEvents

if Meteor.isServer
  ReactiveTable.publish "userEvents", UserEvents, {}
  
  Meteor.publish "userEvent", (eidID) ->
    UserEvents.find({'_id': eidID})
    
  Meteor.publish "eventCount", () ->
    UserEvents.find({'_id': "YTHJwWrjcCzPmjuDz"})
  , {
    url: 'event-count',
    httpMethod: 'get'
  }
  
  UserEvents.allow
    insert: (userID, doc) ->
      return Meteor.user()
    update: (userId, doc, fieldNames, modifier) ->
      return Meteor.user()