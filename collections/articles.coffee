Articles = new Meteor.Collection "articles"

@grid ?= {}
@grid.Articles = Articles

UserEvents = () ->
  @grid.UserEvents
  
getArticles = (userEventId) ->
  Articles.find({userEventId: userEventId})
  
Articles.getArticles = getArticles

if Meteor.isServer
  Meteor.publish "articles", (ueId) ->
    getArticles(ueId)