Comments = new Meteor.Collection "comments"

@grid ?= {}
@grid.Comments = Comments

if Meteor.isServer
  Comments.allow
    insert: (userID, doc) ->
      doc.timeStamp = new Date()
      doc.userID = Meteor.user()._id
