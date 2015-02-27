Meteor.publish "comments", () ->
  grid.Comments.find()
