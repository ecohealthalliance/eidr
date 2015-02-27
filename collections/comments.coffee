Comments = new Meteor.Collection "comments"

@grid ?= {}
@grid.Comments = Comments

if Meteor.isServer
  Comments.allow
    insert: (userID, doc) ->
      userID
