Template.comments.helpers 
  checkComments : () ->
    @comments.count() > 0

Template.comments.events
  "submit #add-comment" : (e) ->
    e.preventDefault()
    grid.Comments.insert
      comment: e.target.comment.value
      event: @event.eidID
      userID: Meteor.user()._id
      username: Meteor.user().username
    e.target.comment.value = ''
    return false
